# Quick Start Guide

## ✅ Start a static server

## 📋 Access Your Application

Start a static server (no backend needed):

- Python:
  ```
  cd E-Commerce-Website
  python -m http.server 5500
  ```
- Node:
  ```
  cd E-Commerce-Website
  npx http-server -p 5500
  ```

Then open:
- Main: http://localhost:5500/index.html
- Admin: http://localhost:5500/admin/index.html

## 🗄️ Data Storage (client-side)

- On first load, data seeds from `storage/*.json`.
- All changes (Add/Edit/Delete) are saved to browser localStorage.
- To reset data, clear site data in your browser (Application → Clear storage).

## 🎯 Admin Panel Features

Once logged in, you can:

1. **Manage Products** - View, Add, Edit, Delete products
2. **Manage Categories** - View, Add, Edit, Delete categories  
3. **Manage Brands** - View, Add, Edit, Delete brands
4. **View Orders** - See all orders and update status

## 🛑 Stopping the server
Press `Ctrl+C` in the terminal, or close the terminal.

## 🔄 Restarting the Server

Double-click `start-server-xampp.bat` (if XAMPP is installed)
OR
Double-click `start-server.bat` (if PHP is in PATH)

## ⚠️ Troubleshooting

### Products not showing?
- Check database connection: http://localhost:5500/test-connection.php
- Verify database is created and schema is imported
- Check browser console for errors

### JSON not loading?
- Make sure you started a static server (file:// won’t work for fetch)
- Check the browser console for CORS/file path errors

### Can't access pages?
- Make sure server is running on port 5500
- Try: http://localhost:5500/test-connection.php first
- Check if port 5500 is already in use

## 📝 Notes

- The server runs in the background
- All API endpoints are in the `api/` folder
- Database config is in `config/database.php`
- Images are stored in the `images/` folder

