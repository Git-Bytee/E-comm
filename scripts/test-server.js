// Simple test server - just to verify Node.js works
import express from 'express';

const app = express();
const PORT = 3000;

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});

app.use(express.json());

app.get('/api/test', (req, res) => {
    res.json({ 
        message: 'Test server is running!',
        port: PORT,
        status: 'ok',
        timestamp: new Date().toISOString()
    });
});

app.get('/api/health', (req, res) => {
    res.json({ 
        ok: true,
        server: 'running',
        port: PORT,
        connection: 'successful'
    });
});

console.log('');
console.log('========================================');
console.log('  TEST SERVER - Starting...');
console.log('========================================');
console.log('');

const server = app.listen(PORT, () => {
    console.log('');
    console.log('========================================');
    console.log('  ✓ TEST SERVER IS RUNNING!');
    console.log('========================================');
    console.log(`  URL: http://localhost:${PORT}`);
    console.log(`  Test: http://localhost:${PORT}/api/test`);
    console.log('========================================');
    console.log('');
    console.log('✓ Server listening on port 3000');
    console.log('✓ Connection successful!');
    console.log('');
    console.log('If you see this, Node.js and Express work!');
    console.log('Now try running: node src/index.js');
    console.log('');
});

server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error('');
        console.error('✗ ERROR: Port 3000 is already in use!');
        console.error('');
        console.error('Run this to find and kill the process:');
        console.error('  netstat -ano | findstr :3000');
        console.error('  taskkill /PID <PID> /F');
        console.error('');
    } else {
        console.error('✗ Error:', err);
    }
    process.exit(1);
});

