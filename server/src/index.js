import express from 'express';
import cors from 'cors';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import mysql from 'mysql2/promise';

const app = express();
const SERVER_PORT = 3000; // ALWAYS port 3000
const JWT_SECRET = process.env.JWT_SECRET || 'dev_secret_change_me';

// CORS - Allow all origins
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// MySQL configuration
const MYSQL_HOST = process.env.MYSQL_HOST || 'localhost';
const MYSQL_USER = process.env.MYSQL_USER || 'root';
const MYSQL_PASSWORD = process.env.MYSQL_PASSWORD || '';
const MYSQL_DATABASE = process.env.MYSQL_DATABASE || 'easycart_db';

let mysqlPool = null;
let dbReady = false;

// Initialize database (non-blocking)
(async () => {
    try {
        console.log('[DB] Connecting to MySQL...');
        console.log(`[DB]   Host: ${MYSQL_HOST}`);
        console.log(`[DB]   User: ${MYSQL_USER}`);
        console.log(`[DB]   Database: ${MYSQL_DATABASE}`);
        
        // First, try to connect without database (to create it if needed)
        let adminPool;
        try {
            adminPool = await mysql.createPool({
                host: MYSQL_HOST,
                user: MYSQL_USER,
                password: MYSQL_PASSWORD || '',
                waitForConnections: true,
                connectionLimit: 5,
                connectTimeout: 5000
            });
            
            // Try to create database if it doesn't exist
            await adminPool.query(`CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}`);
            console.log('[DB] ✓ Database created/verified');
            await adminPool.end();
        } catch (e) {
            console.log('[DB]   Note: Could not auto-create database, will try to connect anyway');
        }
        
        // Now connect to the database
        mysqlPool = await mysql.createPool({
            host: MYSQL_HOST,
            user: MYSQL_USER,
            password: MYSQL_PASSWORD || '',
            database: MYSQL_DATABASE,
            waitForConnections: true,
            connectionLimit: 10,
            connectTimeout: 5000
        });
        
        await mysqlPool.query('SELECT 1');
        console.log('[DB] ✓ MySQL connected!');
        
        // Create users table
        await mysqlPool.query(`
            CREATE TABLE IF NOT EXISTS users (
                user_id INT PRIMARY KEY AUTO_INCREMENT,
                username VARCHAR(50) UNIQUE NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                first_name VARCHAR(50) NOT NULL,
                last_name VARCHAR(50) NOT NULL,
                phone VARCHAR(15),
                date_of_birth DATE,
                gender ENUM('Male', 'Female', 'Other'),
                is_active BOOLEAN DEFAULT TRUE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `);
        
        // Create indexes (ignore errors if they exist)
        try {
            await mysqlPool.query('CREATE INDEX idx_users_email ON users(email)');
        } catch (e) {}
        try {
            await mysqlPool.query('CREATE INDEX idx_users_username ON users(username)');
        } catch (e) {}
        
        dbReady = true;
        console.log('[DB] ✓ Tables ready!');
    } catch (err) {
        console.error('[DB] ✗ Connection failed:', err.message);
        console.error('');
        console.error('[DB] To fix this:');
        console.error('[DB]   1. Make sure MySQL is running');
        console.error('[DB]   2. Create database: CREATE DATABASE IF NOT EXISTS easycart_db;');
        console.error('[DB]   3. Check MySQL username/password in START.bat');
        console.error('[DB]   4. See: SETUP_DATABASE_MANUAL.md for detailed instructions');
        console.error('');
        console.error('[DB] Server will start but registration/login disabled');
        dbReady = false;
        mysqlPool = null;
    }
})();

// JWT functions
function createToken(payload) {
    return jwt.sign(payload, JWT_SECRET, { expiresIn: '7d' });
}

function authMiddleware(req, res, next) {
    const authHeader = req.headers.authorization || '';
    const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;
    if (!token) return res.status(401).json({ message: 'Missing token' });
    try {
        req.user = jwt.verify(token, JWT_SECRET);
        next();
    } catch (e) {
        return res.status(401).json({ message: 'Invalid token' });
    }
}

// Health endpoints
app.get('/api/test', (req, res) => {
    res.json({ 
        message: 'Server is running!',
        port: SERVER_PORT,
        connection: 'successful',
        status: 'ok',
        timestamp: new Date().toISOString()
    });
});

app.get('/api/health', (req, res) => {
    res.json({ 
        ok: true, 
        db: dbReady ? 'up' : 'down',
        server: 'running',
        port: SERVER_PORT,
        connection: 'successful',
        timestamp: new Date().toISOString()
    });
});

app.get('/api/health/db', async (req, res) => {
    try {
        if (!mysqlPool) return res.status(503).json({ ok: false, message: 'DB not initialized' });
        await mysqlPool.query('SELECT 1');
        res.json({ ok: true, db: 'up' });
    } catch (e) {
        res.status(500).json({ ok: false, db: 'down', message: e.message });
    }
});

// Registration
app.post('/api/auth/register', async (req, res) => {
    if (!dbReady || !mysqlPool) {
        return res.status(503).json({ message: 'Database not ready' });
    }
    
    const { username, email, password, firstName, lastName } = req.body || {};
    
    if (!username || !email || !password || !firstName || !lastName) {
        return res.status(400).json({ message: 'All fields required' });
    }
    
    if (username.length < 3) return res.status(400).json({ message: 'Username too short' });
    if (password.length < 6) return res.status(400).json({ message: 'Password too short' });
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        return res.status(400).json({ message: 'Invalid email' });
    }
    
    try {
        const passwordHash = bcrypt.hashSync(password, 10);
        const [result] = await mysqlPool.execute(
            'INSERT INTO users (username, email, password_hash, first_name, last_name) VALUES (?, ?, ?, ?, ?)',
            [username.trim(), email.trim().toLowerCase(), passwordHash, firstName.trim(), lastName.trim()]
        );
        
        const user = {
            id: result.insertId,
            username,
            email: email.trim().toLowerCase(),
            firstName,
            lastName
        };
        const token = createToken({ id: user.id, username: user.username });
        
        console.log(`[REGISTER] ✓ User ${username} registered`);
        return res.status(201).json({ user, token });
    } catch (err) {
        if (err.code === 'ER_DUP_ENTRY' || err.message.includes('Duplicate')) {
            return res.status(409).json({ message: 'Username or email exists' });
        }
        console.error('[REGISTER] Error:', err.message);
        return res.status(500).json({ message: 'Registration failed', detail: err.message });
    }
});

// Login
app.post('/api/auth/login', async (req, res) => {
    if (!dbReady || !mysqlPool) {
        return res.status(503).json({ message: 'Database not ready' });
    }
    
    const { emailOrUsername, password } = req.body || {};
    if (!emailOrUsername || !password) {
        return res.status(400).json({ message: 'Credentials required' });
    }
    
    try {
        const isEmail = emailOrUsername.includes('@');
        const query = isEmail ? 'SELECT * FROM users WHERE email = ?' : 'SELECT * FROM users WHERE username = ?';
        const [rows] = await mysqlPool.execute(query, [
            isEmail ? emailOrUsername.trim().toLowerCase() : emailOrUsername.trim()
        ]);
        
        const row = rows[0];
        if (!row || !bcrypt.compareSync(password, row.password_hash)) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }
        
        const user = {
            id: row.user_id,
            username: row.username,
            email: row.email,
            firstName: row.first_name,
            lastName: row.last_name
        };
        const token = createToken({ id: user.id, username: user.username });
        
        return res.json({ user, token });
    } catch (err) {
        console.error('[LOGIN] Error:', err.message);
        return res.status(500).json({ message: 'Login failed' });
    }
});

// Get current user
app.get('/api/auth/me', authMiddleware, async (req, res) => {
    if (!dbReady || !mysqlPool) {
        return res.status(503).json({ message: 'Database not ready' });
    }
    
    try {
        const [rows] = await mysqlPool.execute(
            'SELECT user_id AS id, username, email, first_name AS firstName, last_name AS lastName FROM users WHERE user_id = ?',
            [req.user.id]
        );
        if (!rows[0]) return res.status(404).json({ message: 'User not found' });
        return res.json({ user: rows[0] });
    } catch (err) {
        return res.status(500).json({ message: 'Failed to load user' });
    }
});

// START SERVER - This is the critical part
console.log('');
console.log('========================================');
console.log('  Starting EasyCart Server...');
console.log('========================================');
console.log('');

const server = app.listen(SERVER_PORT, () => {
    console.log('');
    console.log('========================================');
    console.log('  ✓ SERVER IS RUNNING!');
    console.log('========================================');
    console.log(`  URL: http://localhost:${SERVER_PORT}`);
    console.log(`  Test: http://localhost:${SERVER_PORT}/api/test`);
    console.log(`  Health: http://localhost:${SERVER_PORT}/api/health`);
    console.log(`  Database: ${dbReady ? '✓ Connected' : '✗ Not connected'}`);
    console.log('========================================');
    console.log('');
    console.log('✓ Server listening on port 3000');
    console.log('✓ Connection successful!');
    console.log('');
    console.log('Keep this window open while using the website!');
    console.log('Press Ctrl+C to stop the server');
    console.log('');
});

server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error('');
        console.error('✗ ERROR: Port 3000 is already in use!');
        console.error('');
        console.error('To fix:');
        console.error('  1. Close other applications using port 3000');
        console.error('  2. Or run: netstat -ano | findstr :3000');
        console.error('  3. Then: taskkill /PID <PID> /F');
        console.error('');
    } else {
        console.error('✗ Server error:', err);
    }
    process.exit(1);
});

process.on('SIGTERM', () => {
    console.log('Shutting down...');
    server.close(() => process.exit(0));
});

process.on('uncaughtException', (err) => {
    console.error('Uncaught Exception:', err);
});

process.on('unhandledRejection', (reason) => {
    console.error('Unhandled Rejection:', reason);
});
