-- Sample Data for E-Commerce Website
-- Database: easycart_db
-- This file contains sample data to populate the database for testing

USE easycart_db;

-- =============================================
-- INSERT SAMPLE CATEGORIES
-- =============================================
INSERT INTO categories (category_name, description, parent_category_id, is_active) VALUES
('Fruits', 'Fresh and seasonal fruits', NULL, TRUE),
('Vegetables', 'Fresh organic vegetables', NULL, TRUE),
('Dairy', 'Fresh dairy products', NULL, TRUE),
('Beverages', 'Drinks and beverages', NULL, TRUE),
('Clothing', 'Fashion and apparel', NULL, TRUE),
('Tropical Fruits', 'Exotic tropical fruits', 1, TRUE),
('Leafy Vegetables', 'Fresh leafy greens', 2, TRUE),
('Milk Products', 'Various milk-based products', 3, TRUE);

-- =============================================
-- INSERT SAMPLE BRANDS
-- =============================================
INSERT INTO brands (brand_name, description, logo_url, website_url, is_active) VALUES
('Fresh Farm', 'Organic farm-fresh produce', 'https://example.com/logos/freshfarm.png', 'https://freshfarm.com', TRUE),
('Green Valley', 'Premium organic vegetables', 'https://example.com/logos/greenvalley.png', 'https://greenvalley.com', TRUE),
('Dairy Fresh', 'Fresh dairy products', 'https://example.com/logos/dairyfresh.png', 'https://dairyfresh.com', TRUE),
('Yogurt Co', 'Premium yogurt products', 'https://example.com/logos/yogurtco.png', 'https://yogurtco.com', TRUE),
('Nutty Good', 'Plant-based milk alternatives', 'https://example.com/logos/nuttygood.png', 'https://nuttygood.com', TRUE),
('Veggie Fresh', 'Fresh vegetable supplier', 'https://example.com/logos/veggiefresh.png', 'https://veggiefresh.com', TRUE),
('Tropical Fruits', 'Exotic fruit importer', 'https://example.com/logos/tropicalfruits.png', 'https://tropicalfruits.com', TRUE),
('Coco Fresh', 'Coconut water and products', 'https://example.com/logos/cocofresh.png', 'https://cocofresh.com', TRUE),
('Fashion Hub', 'Trendy clothing and accessories', 'https://example.com/logos/fashionhub.png', 'https://fashionhub.com', TRUE);

-- =============================================
-- INSERT SAMPLE USERS
-- =============================================
INSERT INTO users (username, email, password_hash, first_name, last_name, phone, date_of_birth, gender, is_active) VALUES
('john_doe', 'john.doe@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John', 'Doe', '9876543210', '1990-05-15', 'Male', TRUE),
('jane_smith', 'jane.smith@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane', 'Smith', '9876543211', '1992-08-22', 'Female', TRUE),
('mike_wilson', 'mike.wilson@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mike', 'Wilson', '9876543212', '1988-12-10', 'Male', TRUE),
('sarah_jones', 'sarah.jones@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sarah', 'Jones', '9876543213', '1995-03-18', 'Female', TRUE),
('admin_user', 'admin@easycart.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'User', '9876543214', '1985-01-01', 'Other', TRUE);

-- =============================================
-- INSERT SAMPLE ADDRESSES
-- =============================================
INSERT INTO addresses (user_id, address_type, full_name, phone, address_line1, address_line2, city, state, postal_code, country, is_default) VALUES
(1, 'Home', 'John Doe', '9876543210', '123 Main Street', 'Apt 4B', 'Mumbai', 'Maharashtra', '400001', 'India', TRUE),
(1, 'Work', 'John Doe', '9876543210', '456 Business Park', 'Office 201', 'Mumbai', 'Maharashtra', '400002', 'India', FALSE),
(2, 'Home', 'Jane Smith', '9876543211', '789 Garden Road', 'Villa 12', 'Delhi', 'Delhi', '110001', 'India', TRUE),
(3, 'Home', 'Mike Wilson', '9876543212', '321 Lake View', 'House 5', 'Bangalore', 'Karnataka', '560001', 'India', TRUE),
(4, 'Home', 'Sarah Jones', '9876543213', '654 Hill Station', 'Flat 8A', 'Pune', 'Maharashtra', '411001', 'India', TRUE);

-- =============================================
-- INSERT SAMPLE PRODUCTS
-- =============================================
INSERT INTO products (product_name, description, short_description, category_id, brand_id, sku, price, discount_price, stock_quantity, min_stock_level, weight, dimensions, image_url, is_active, is_featured) VALUES
('Fresh Apples', 'Crisp and juicy red apples, perfect for snacking or cooking. Rich in fiber and vitamins.', 'Crisp and juicy red apples', 1, 1, 'FRU-APP-001', 120.00, NULL, 50, 10, 0.5, '10x8x8 cm', './images/apple.png', TRUE, TRUE),
('Organic Carrots', 'Fresh organic carrots, rich in vitamins and perfect for healthy cooking.', 'Fresh organic carrots, rich in vitamins', 2, 2, 'VEG-CAR-001', 80.00, NULL, 30, 5, 0.3, '15x3x3 cm', './images/carrot.png', TRUE, TRUE),
('Cow Milk', 'Fresh pasteurized cow milk, 1 liter. Perfect for daily consumption.', 'Fresh pasteurized cow milk, 1 liter', 3, 3, 'DAI-MIL-001', 60.00, NULL, 100, 20, 1.0, '10x10x20 cm', './images/cowmilk.png', TRUE, FALSE),
('Greek Yogurt', 'Creamy Greek yogurt, high in protein and probiotics. Perfect for breakfast or snacks.', 'Creamy Greek yogurt, high in protein', 8, 4, 'DAI-YOG-001', 150.00, 120.00, 25, 5, 0.5, '8x8x8 cm', './images/greekyoghurt.png', TRUE, TRUE),
('Almond Milk', 'Plant-based almond milk, lactose-free and rich in nutrients.', 'Plant-based almond milk, lactose-free', 4, 5, 'BEV-ALM-001', 200.00, NULL, 40, 8, 1.0, '10x10x20 cm', './images/almondmilk.png', TRUE, FALSE),
('Capsicum', 'Fresh green capsicum, perfect for cooking and salads.', 'Fresh green capsicum, perfect for cooking', 2, 6, 'VEG-CAP-001', 90.00, NULL, 35, 7, 0.2, '12x6x6 cm', './images/capsicum1.png', TRUE, FALSE),
('Mango', 'Sweet and juicy mangoes, seasonal special. Rich in vitamin C and antioxidants.', 'Sweet and juicy mangoes, seasonal special', 6, 7, 'FRU-MAN-001', 180.00, 150.00, 20, 5, 0.4, '15x10x8 cm', './images/mango2.png', TRUE, TRUE),
('Coconut Water', 'Natural coconut water, refreshing and hydrating drink.', 'Natural coconut water, refreshing drink', 4, 8, 'BEV-COC-001', 50.00, NULL, 60, 12, 0.3, '8x8x15 cm', './images/coconutwater.jpg', TRUE, FALSE),
('Ethnic Wear', 'Beautiful traditional ethnic clothing, perfect for festivals and special occasions.', 'Beautiful traditional ethnic clothing', 5, 9, 'CLO-ETH-001', 2500.00, 2000.00, 15, 3, 0.8, '30x25x5 cm', './images/ethnic1.jpg', TRUE, TRUE);

-- =============================================
-- INSERT SAMPLE PRODUCT IMAGES
-- =============================================
INSERT INTO product_images (product_id, image_url, alt_text, is_primary, sort_order) VALUES
(1, './images/apple.png', 'Fresh Red Apples', TRUE, 1),
(1, './images/apple2.png', 'Apple Side View', FALSE, 2),
(2, './images/carrot.png', 'Organic Carrots', TRUE, 1),
(3, './images/cowmilk.png', 'Fresh Cow Milk', TRUE, 1),
(4, './images/greekyoghurt.png', 'Greek Yogurt', TRUE, 1),
(5, './images/almondmilk.png', 'Almond Milk', TRUE, 1),
(6, './images/capsicum1.png', 'Green Capsicum', TRUE, 1),
(7, './images/mango2.png', 'Fresh Mango', TRUE, 1),
(8, './images/coconutwater.jpg', 'Coconut Water', TRUE, 1),
(9, './images/ethnic1.jpg', 'Ethnic Wear', TRUE, 1);

-- =============================================
-- INSERT SAMPLE CART ITEMS
-- =============================================
INSERT INTO cart (user_id, product_id, quantity, added_at) VALUES
(1, 1, 2, '2024-01-15 10:30:00'),
(1, 3, 1, '2024-01-15 10:35:00'),
(2, 2, 3, '2024-01-15 11:00:00'),
(2, 4, 1, '2024-01-15 11:05:00'),
(3, 7, 2, '2024-01-15 12:00:00'),
(3, 8, 4, '2024-01-15 12:05:00');

-- =============================================
-- INSERT SAMPLE WISHLIST ITEMS
-- =============================================
INSERT INTO wishlist (user_id, product_id, added_at) VALUES
(1, 9, '2024-01-10 09:00:00'),
(1, 5, '2024-01-12 14:30:00'),
(2, 1, '2024-01-11 16:45:00'),
(2, 7, '2024-01-13 11:20:00'),
(3, 4, '2024-01-14 08:15:00'),
(4, 9, '2024-01-15 13:30:00');

-- =============================================
-- INSERT SAMPLE ORDERS
-- =============================================
INSERT INTO orders (user_id, order_number, order_status, payment_status, payment_method, subtotal, tax_amount, shipping_amount, discount_amount, total_amount, shipping_address_id, billing_address_id, order_date) VALUES
(1, 'ORD202401150001', 'Delivered', 'Paid', 'UPI', 300.00, 30.00, 50.00, 0.00, 380.00, 1, 1, '2024-01-10 10:00:00'),
(1, 'ORD202401150002', 'Shipped', 'Paid', 'Credit Card', 450.00, 45.00, 50.00, 25.00, 520.00, 1, 1, '2024-01-12 14:30:00'),
(2, 'ORD202401150003', 'Processing', 'Paid', 'Debit Card', 200.00, 20.00, 50.00, 0.00, 270.00, 3, 3, '2024-01-14 16:45:00'),
(3, 'ORD202401150004', 'Pending', 'Pending', 'Cash on Delivery', 150.00, 15.00, 50.00, 0.00, 215.00, 4, 4, '2024-01-15 09:30:00');

-- =============================================
-- INSERT SAMPLE ORDER ITEMS
-- =============================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 2, 120.00, 240.00),
(1, 3, 1, 60.00, 60.00),
(2, 2, 3, 80.00, 240.00),
(2, 4, 1, 120.00, 120.00),
(2, 5, 1, 200.00, 200.00),
(3, 6, 2, 90.00, 180.00),
(3, 7, 1, 150.00, 150.00),
(4, 8, 3, 50.00, 150.00);

-- =============================================
-- INSERT SAMPLE PAYMENTS
-- =============================================
INSERT INTO payments (order_id, payment_method, payment_status, transaction_id, amount, payment_date) VALUES
(1, 'UPI', 'Completed', 'TXN202401100001', 380.00, '2024-01-10 10:05:00'),
(2, 'Credit Card', 'Completed', 'TXN202401120002', 520.00, '2024-01-12 14:35:00'),
(3, 'Debit Card', 'Completed', 'TXN202401140003', 270.00, '2024-01-14 16:50:00'),
(4, 'Cash on Delivery', 'Pending', NULL, 215.00, NULL);

-- =============================================
-- INSERT SAMPLE REVIEWS
-- =============================================
INSERT INTO reviews (user_id, product_id, order_id, rating, title, comment, is_verified, is_approved) VALUES
(1, 1, 1, 5, 'Excellent Quality!', 'The apples were fresh, crisp, and delicious. Will definitely order again!', TRUE, TRUE),
(1, 3, 1, 4, 'Good Milk', 'Fresh milk, good quality. Delivery was on time.', TRUE, TRUE),
(2, 2, 2, 5, 'Perfect Carrots', 'Organic carrots were fresh and sweet. Great for cooking!', TRUE, TRUE),
(2, 4, 2, 4, 'Nice Yogurt', 'Creamy and tasty Greek yogurt. Good protein content.', TRUE, TRUE),
(3, 6, 3, 3, 'Average Quality', 'Capsicum was okay, but could be fresher.', TRUE, TRUE),
(3, 7, 3, 5, 'Amazing Mangoes!', 'Sweet and juicy mangoes, exactly as described. Highly recommended!', TRUE, TRUE);

-- =============================================
-- INSERT SAMPLE COUPONS
-- =============================================
INSERT INTO coupons (coupon_code, description, discount_type, discount_value, minimum_order_amount, maximum_discount_amount, usage_limit, used_count, is_active, valid_from, valid_until) VALUES
('WELCOME10', 'Welcome discount for new customers', 'Percentage', 10.00, 500.00, 100.00, 100, 5, TRUE, '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
('SAVE50', 'Flat discount on orders above 1000', 'Fixed Amount', 50.00, 1000.00, 50.00, 50, 12, TRUE, '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
('FRESH20', '20% off on fresh produce', 'Percentage', 20.00, 300.00, 200.00, 200, 8, TRUE, '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
('FIRST25', '25% off for first-time buyers', 'Percentage', 25.00, 200.00, 150.00, 1000, 25, TRUE, '2024-01-01 00:00:00', '2024-12-31 23:59:59');

-- =============================================
-- INSERT SAMPLE COUPON USAGE
-- =============================================
INSERT INTO coupon_usage (coupon_id, user_id, order_id, discount_amount, used_at) VALUES
(1, 1, 1, 30.00, '2024-01-10 10:00:00'),
(2, 1, 2, 50.00, '2024-01-12 14:30:00'),
(3, 2, 2, 48.00, '2024-01-12 14:30:00'),
(4, 3, 3, 50.00, '2024-01-14 16:45:00');

-- =============================================
-- INSERT SAMPLE ADMIN USERS
-- =============================================
INSERT INTO admin_users (username, email, password_hash, first_name, last_name, role, is_active) VALUES
('admin', 'admin@easycart.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Super', 'Admin', 'Super Admin', TRUE),
('manager1', 'manager@easycart.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John', 'Manager', 'Manager', TRUE),
('support1', 'support@easycart.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sarah', 'Support', 'Support', TRUE);

-- =============================================
-- UPDATE ORDER STATUSES WITH DATES
-- =============================================
UPDATE orders 
SET shipped_date = '2024-01-11 10:00:00', delivered_date = '2024-01-12 15:00:00'
WHERE order_id = 1;

UPDATE orders 
SET shipped_date = '2024-01-13 09:00:00'
WHERE order_id = 2;

-- =============================================
-- VERIFY DATA INSERTION
-- =============================================

-- Check total counts
SELECT 'Categories' as table_name, COUNT(*) as count FROM categories
UNION ALL
SELECT 'Brands', COUNT(*) FROM brands
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Addresses', COUNT(*) FROM addresses
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Cart Items', COUNT(*) FROM cart
UNION ALL
SELECT 'Wishlist Items', COUNT(*) FROM wishlist
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'Coupons', COUNT(*) FROM coupons
UNION ALL
SELECT 'Admin Users', COUNT(*) FROM admin_users;
