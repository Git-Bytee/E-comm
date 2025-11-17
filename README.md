# E-Commerce Website

A complete e-commerce website EasyCart with database integration, featuring product management, shopping cart, user authentication and more.

## 🚀 Features

- **User Management**
  - User registration and authentication
  - Profile management
  - Address book

- **Product Catalog**
  - Product categories and brands
  - Product details with images
  - Search and filter functionality

- **Shopping Experience**
  - Shopping cart
  - Wishlist
  - Order tracking

- **Admin Dashboard**
  - Product management (CRUD)
  - Category management
  - Brand management
  - Order management
  - User management

## 📁 Project Structure

```
E-comm/
├── admin/                  # Admin panel files
│   ├── index.html         # Admin dashboard
│   ├── manage-products.html
│   ├── manage-categories.html
│   ├── manage-brands.html
│   ├── manage-orders.html
│   ├── insert-product.html
│   ├── insert-category.html
│   └── insert-brand.html
├── api/                    # Backend API endpoints
│   ├── delete_*.php       # Delete operations
│   ├── get_*.php          # Data retrieval
│   ├── insert_*.php       # Create operations
│   ├── update_*.php       # Update operations
│   ├── login.php          # User authentication
│   └── register.php       # User registration
├── css/                   # Stylesheets
├── images/                # Static assets
├── js/                    # Frontend JavaScript
│   ├── app.js
│   └── datastore.js
├── config.php             # Database configuration
├── database_schema.sql    # Complete database schema
├── index.html             # Main storefront
├── login.php              # Login page
├── register.php           # Registration page
└── README.md              # This file
```

## 🗄️ Database Schema

### Core Tables
- **users** - User accounts and profiles
- **addresses** - Shipping/billing addresses
- **products** - Product catalog with pricing and inventory
- **categories** - Product categories with hierarchical support
- **brands** - Product brands and manufacturers
- **cart** - Shopping cart items
- **orders** - Order management
- **order_items** - Individual order line items
- **product_images** - Product image gallery
- **wishlist** - User wishlists

### Database Features
- **Normalized schema** (3NF)
- **Referential integrity** with foreign key constraints
- **Indexed columns** for better query performance
- **Timestamps** for tracking record changes

## 🛠️ Setup Instructions

### 1. Database Setup
```sql
-- Create database
CREATE DATABASE easycart_db;

-- Import schema
SOURCE database_schema.sql;

-- Import sample data
SOURCE sample_data.sql;
```

### 2. Configuration
1. Update `config/database.php` with your database credentials:
   ```php
   private $host = 'localhost';
   private $db_name = 'easycart_db';
   private $username = 'your_username';
   private $password = 'your_password';
   ```

### 3. Web Server Setup
- Ensure PHP 7.4+ is installed
- Enable PDO and PDO_MySQL extensions
- Set up Apache/Nginx to serve PHP files
- Ensure `uploads/` directory is writable

### 4. Run Setup Script
```bash
php setup.php
```

## 🔌 API Endpoints

### Products API (`api/products.php`)
- `GET api/products.php` - Get all products
- `GET api/products.php?featured=true` - Get featured products
- `GET api/products.php?categories=true` - Get categories
- `GET api/products.php?brands=true` - Get brands
- `GET api/products.php?id=1` - Get single product

### Cart API (`api/cart.php`)
- `GET api/cart.php` - Get cart items
- `GET api/cart.php?count=true` - Get cart count
- `POST api/cart.php` - Add item to cart
- `PUT api/cart.php` - Update cart item
- `DELETE api/cart.php?cart_id=1` - Remove from cart

### Authentication API (`api/auth.php`)
- `POST api/auth.php` - Login/Register/Logout
- `GET api/auth.php?user=true` - Get current user
- `PUT api/auth.php` - Update profile

## 💻 Frontend Integration

The website uses JavaScript to dynamically load content:

### Key Features
- **Dynamic Product Loading** - Products loaded from database
- **Real-time Cart Updates** - Cart count and total updates
- **Search Functionality** - Live search as you type
- **Category/Brand Filtering** - Filter products by category or brand
- **User Authentication** - Login/logout functionality
- **Responsive Notifications** - User feedback for actions

### JavaScript Classes
- `EasyCartApp` - Main application class
- Handles all API calls and DOM updates
- Manages user sessions and cart state

## 🎨 UI Components

### Navigation
- **Top Navigation** - Logo, menu items, cart, search
- **Secondary Navigation** - User status, login/logout
- **Sidebar** - Categories and brands for filtering

### Product Display
- **Product Cards** - Image, name, description, price
- **Add to Cart** - Dynamic cart updates
- **View More** - Product details (expandable)

### Shopping Cart
- **Cart Icon** - Shows item count
- **Total Price** - Dynamic price calculation
- **Cart Management** - Add/remove/update items

## 🔒 Security Features

- **Password Hashing** - Secure password storage
- **SQL Injection Prevention** - Prepared statements
- **Input Validation** - Server-side validation
- **Session Management** - Secure user sessions
- **CSRF Protection** - Token-based protection

## 📊 Sample Data

The database includes comprehensive sample data:

- **5 Users** with complete profiles
- **9 Categories** with hierarchical structure
- **9 Brands** with logos and descriptions
- **9 Products** with images and details
- **Sample Orders** with order items
- **Product Reviews** with ratings
- **Coupons** for testing discounts
- **Admin Users** for management

## 🚀 Getting Started

1. **Clone/Download** the project files
2. **Set up MySQL database** and import schema
3. **Configure database** credentials
4. **Run setup script** for initial configuration
5. **Test the website** functionality
6. **Customize** products, categories, and branding

## 🔧 Customization

### Adding Products
1. Add product images to `images/` directory
2. Insert product data into database
3. Products will automatically appear on website

### Styling
- Modify `style.css` for custom styling
- Update Bootstrap classes in HTML
- Customize JavaScript behavior in `js/app.js`

### Database
- Add new categories/brands in database
- Modify product structure as needed
- Add custom fields to tables

## 📱 Mobile Responsive

The website is fully responsive and works on:
- **Desktop** - Full feature set
- **Tablet** - Optimized layout
- **Mobile** - Touch-friendly interface

## 🛒 E-commerce Features

- **Product Catalog** - Browse all products
- **Search & Filter** - Find products easily
- **Shopping Cart** - Add/remove items
- **User Accounts** - Registration and profiles
- **Order Management** - Track orders
- **Reviews & Ratings** - Customer feedback
- **Coupons** - Discount codes
- **Admin Panel** - Manage products and orders

## 📈 Analytics Ready

The database structure supports analytics:
- **Sales Reports** - Revenue tracking
- **Product Performance** - Best sellers
- **Customer Analytics** - User behavior
- **Inventory Management** - Stock tracking

## 🎯 Perfect for DBMS Projects

This project is ideal for DBMS coursework because it includes:
- **Complex Database Design** - 15 interconnected tables
- **Real-world Relationships** - E-commerce business logic
- **Advanced Queries** - Joins, subqueries, aggregations
- **Performance Optimization** - Indexes and triggers
- **Data Integrity** - Constraints and validations
- **Complete Documentation** - ER diagrams and documentation

## 📞 Support

For questions or issues:
1. Check the database documentation
2. Review the setup instructions
3. Verify database connection
4. Check PHP error logs

---

**Created by**: Relational Minds Development Team  
**Version**: 1.0  
**Last Updated**: November 2025


