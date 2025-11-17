# EasyCart - Setup Guide

## 🚀 Prerequisites

1. **Web Server**
   - XAMPP (Recommended) or WAMP
   - PHP 7.4 or higher
   - MySQL 5.7 or higher
   - Web browser (Chrome, Firefox, or Edge)

2. **Required PHP Extensions**
   - PDO
   - PDO_MySQL
   - JSON
   - Session
   - cURL (if using external APIs)

## 🛠️ Installation Steps

### 1. Server Setup

1. Install XAMPP/WAMP if not already installed
2. Start Apache and MySQL services

### 2. Database Setup

1. Open phpMyAdmin (usually at http://localhost/phpmyadmin)
2. Create a new database named `easycart_db`
3. Import the database schema:
   - Click on the newly created database
   - Go to the "Import" tab
   - Click "Choose File" and select `database_schema.sql`
   - Click "Go" to import

### 3. Project Setup

1. Clone or extract the project files to your web server root directory:
   - For XAMPP: `C:\xampp\htdocs\E-comm`
   - For WAMP: `C:\wamp64\www\E-comm`

2. Configure database connection:
   - Open `config.php`
   - Update the database credentials if needed:
     ```php
     define('DB_HOST', 'localhost');
     define('DB_USER', 'root');     // Default XAMPP username
     define('DB_PASS', '');        // Default XAMPP password (empty)
     define('DB_NAME', 'easycart_db');
     ```

### 4. File Permissions

Ensure the following directories are writable by the web server:
- `/images/` - For product images
- Any directory where file uploads are stored

## 🌐 Accessing the Application

1. **Frontend (Customer Site)**
   - URL: http://localhost/E-comm/
   - Browse products, register, and make purchases

2. **Admin Panel**
   - URL: http://localhost/E-comm/admin/
   - Default Admin Credentials:
     - Username: admin@easycart.com
     - Password: admin123

## 🔧 Troubleshooting

### Common Issues

1. **Database Connection Error**
   - Verify MySQL service is running
   - Check database credentials in `config.php`
   - Ensure database exists and is accessible

2. **Page Not Found (404)**
   - Ensure mod_rewrite is enabled in Apache
   - Check `.htaccess` file exists in the root directory

3. **Permission Denied**
   - Check file permissions on upload directories
   - Ensure PHP has write access to necessary directories

### Error Logs
- XAMPP: `C:\xampp\php\logs\php_error_log`
- WAMP: `C:\wamp64\logs\php_error.log`

## 🔄 Updating the Application

1. Backup your database and any uploaded files
2. Replace project files with the new version
3. If there are database changes, run any new SQL migrations
4. Clear browser cache if experiencing display issues

## 📦 Sample Data

Sample products, categories, and brands are included in the database schema. You can manage these through the admin panel after logging in.

## 🔒 Security Notes

1. Change default admin credentials after first login
2. Keep the application updated
3. Never share database credentials
4. Use strong passwords for all user accounts

## 📞 Support

For additional help:
1. Check the [README.md](README.md) file
2. Review the database documentation
3. Check PHP error logs for specific error messages

Open:
- Main: http://localhost:5500/index.html
- Admin: http://localhost:5500/admin/index.html

### Option 3: VS Code Live Server
- Open the folder in VS Code, install Live Server, then “Open with Live Server”.

## Admin Panel Features

### Access Admin Panel
Navigate to: `admin index.html` or `admin/index.html`

### Available Features:
1. **Products Management** (`admin/manage-products.html`)
   - View all products
   - Add new products
   - Edit existing products
   - Delete products

2. **Categories Management** (`admin/manage-categories.html`)
   - View all categories
   - Add new categories
   - Edit categories
   - Delete categories (only if no products use them)

3. **Brands Management** (`admin/manage-brands.html`)
   - View all brands
   - Add new brands
   - Edit brands
   - Delete brands (only if no products use them)

4. **Orders Management** (`admin/manage-orders.html`)
   - View all orders
   - View order details
   - Update order status
   - Update payment status

## API Endpoints (File-based)

All API endpoints are in the `api/` directory and read/write to JSON files:

- `api/products.php` - Product CRUD operations (storage/products.json)
- `api/categories.php` - Category CRUD operations (storage/categories.json)
- `api/brands.php` - Brand CRUD operations (storage/brands.json)
- `api/orders.php` - Order viewing and status updates (storage/orders.json)

## Troubleshooting

### Storage Issues
- Ensure the `storage/` folder is writable
- JSON files are valid (use a JSON validator if needed)

### Products Not Loading
- Check PHP error logs
- Verify database connection
- Ensure sample data is imported
- Check browser console for JavaScript errors

### CORS Issues
- If accessing from different port, update CORS headers in API files
- Or use a web server instead of file:// protocol

## Default Admin Credentials

If you've imported sample data, you can use:
- Username: `admin_user`
- Password: (check database or create new admin user)

## Notes

- Images should be placed in the `images/` directory
- Update image URLs in products to match your file structure
- The project uses Bootstrap 5 and Font Awesome for styling
- All data is stored in MySQL database

## Support

For issues or questions:
1. Check PHP error logs
2. Check browser console for JavaScript errors
3. Verify database connection
4. Ensure all API files are accessible

