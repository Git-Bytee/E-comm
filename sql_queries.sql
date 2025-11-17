-- E-Commerce Website SQL Queries
-- Database: easycart_db
-- Common operations for EasyCart E-Commerce Website

USE easycart_db;

-- =============================================
-- USER MANAGEMENT QUERIES
-- =============================================

-- 1. User Registration
INSERT INTO users (username, email, password_hash, first_name, last_name, phone, date_of_birth, gender)
VALUES ('john_doe', 'john@example.com', 'hashed_password_here', 'John', 'Doe', '9876543210', '1990-05-15', 'Male');

-- 2. User Login (Check credentials)
SELECT user_id, username, email, first_name, last_name, is_active
FROM users 
WHERE (username = 'john_doe' OR email = 'john@example.com') 
AND password_hash = 'hashed_password_here' 
AND is_active = TRUE;

-- 3. Update User Profile
UPDATE users 
SET first_name = 'John', last_name = 'Smith', phone = '9876543210'
WHERE user_id = 1;

-- 4. Add User Address
INSERT INTO addresses (user_id, address_type, full_name, phone, address_line1, city, state, postal_code, is_default)
VALUES (1, 'Home', 'John Doe', '9876543210', '123 Main Street', 'Mumbai', 'Maharashtra', '400001', TRUE);

-- 5. Get User Addresses
SELECT * FROM addresses WHERE user_id = 1 ORDER BY is_default DESC, created_at DESC;

-- =============================================
-- PRODUCT MANAGEMENT QUERIES
-- =============================================

-- 6. Get All Products with Category and Brand
SELECT 
    p.product_id,
    p.product_name,
    p.description,
    p.price,
    p.discount_price,
    p.stock_quantity,
    p.image_url,
    c.category_name,
    b.brand_name,
    CASE 
        WHEN p.discount_price IS NOT NULL THEN p.discount_price
        ELSE p.price
    END AS final_price
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
WHERE p.is_active = TRUE
ORDER BY p.created_at DESC;

-- 7. Search Products by Name
SELECT * FROM product_details 
WHERE product_name LIKE '%apple%' 
AND is_active = TRUE;

-- 8. Get Products by Category
SELECT * FROM product_details 
WHERE category_name = 'Fruits' 
AND is_active = TRUE;

-- 9. Get Products by Brand
SELECT * FROM product_details 
WHERE brand_name = 'Fresh Farm' 
AND is_active = TRUE;

-- 10. Get Featured Products
SELECT * FROM product_details 
WHERE is_featured = TRUE 
AND is_active = TRUE
ORDER BY created_at DESC
LIMIT 8;

-- 11. Get Products by Price Range
SELECT * FROM product_details 
WHERE final_price BETWEEN 50 AND 200 
AND is_active = TRUE
ORDER BY final_price;

-- 12. Get Low Stock Products
SELECT product_id, product_name, stock_quantity, min_stock_level
FROM products 
WHERE stock_quantity <= min_stock_level 
AND is_active = TRUE;

-- =============================================
-- CART MANAGEMENT QUERIES
-- =============================================

-- 13. Add Product to Cart
INSERT INTO cart (user_id, product_id, quantity)
VALUES (1, 1, 2)
ON DUPLICATE KEY UPDATE quantity = quantity + 2;

-- 14. Get User Cart with Product Details
SELECT 
    c.cart_id,
    c.quantity,
    p.product_id,
    p.product_name,
    p.price,
    p.discount_price,
    p.image_url,
    CASE 
        WHEN p.discount_price IS NOT NULL THEN p.discount_price
        ELSE p.price
    END AS final_price,
    (c.quantity * CASE 
        WHEN p.discount_price IS NOT NULL THEN p.discount_price
        ELSE p.price
    END) AS total_price
FROM cart c
JOIN products p ON c.product_id = p.product_id
WHERE c.user_id = 1;

-- 15. Update Cart Quantity
UPDATE cart 
SET quantity = 3 
WHERE user_id = 1 AND product_id = 1;

-- 16. Remove Product from Cart
DELETE FROM cart 
WHERE user_id = 1 AND product_id = 1;

-- 17. Clear User Cart
DELETE FROM cart WHERE user_id = 1;

-- 18. Get Cart Total
SELECT 
    SUM(c.quantity * CASE 
        WHEN p.discount_price IS NOT NULL THEN p.discount_price
        ELSE p.price
    END) AS cart_total
FROM cart c
JOIN products p ON c.product_id = p.product_id
WHERE c.user_id = 1;

-- =============================================
-- WISHLIST MANAGEMENT QUERIES
-- =============================================

-- 19. Add Product to Wishlist
INSERT INTO wishlist (user_id, product_id)
VALUES (1, 2)
ON DUPLICATE KEY UPDATE added_at = CURRENT_TIMESTAMP;

-- 20. Get User Wishlist
SELECT 
    w.wishlist_id,
    w.added_at,
    p.product_id,
    p.product_name,
    p.price,
    p.discount_price,
    p.image_url,
    CASE 
        WHEN p.discount_price IS NOT NULL THEN p.discount_price
        ELSE p.price
    END AS final_price
FROM wishlist w
JOIN products p ON w.product_id = p.product_id
WHERE w.user_id = 1
ORDER BY w.added_at DESC;

-- 21. Remove from Wishlist
DELETE FROM wishlist 
WHERE user_id = 1 AND product_id = 2;

-- =============================================
-- ORDER MANAGEMENT QUERIES
-- =============================================

-- 22. Create New Order
INSERT INTO orders (user_id, payment_method, subtotal, total_amount, shipping_address_id, billing_address_id)
VALUES (1, 'UPI', 350.00, 350.00, 1, 1);

-- 23. Add Items to Order
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price)
VALUES 
(1, 1, 2, 120.00, 240.00),
(1, 2, 1, 80.00, 80.00),
(1, 3, 1, 60.00, 60.00);

-- 24. Get User Orders
SELECT 
    o.order_id,
    o.order_number,
    o.order_status,
    o.payment_status,
    o.total_amount,
    o.order_date,
    COUNT(oi.order_item_id) as item_count
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.user_id = 1
GROUP BY o.order_id, o.order_number, o.order_status, o.payment_status, o.total_amount, o.order_date
ORDER BY o.order_date DESC;

-- 25. Get Order Details
SELECT 
    o.order_id,
    o.order_number,
    o.order_status,
    o.payment_status,
    o.total_amount,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.total_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_id = 1;

-- 26. Update Order Status
UPDATE orders 
SET order_status = 'Shipped', shipped_date = CURRENT_TIMESTAMP
WHERE order_id = 1;

-- 27. Get Orders by Status
SELECT * FROM order_summary 
WHERE order_status = 'Pending'
ORDER BY order_date DESC;

-- =============================================
-- REVIEW MANAGEMENT QUERIES
-- =============================================

-- 28. Add Product Review
INSERT INTO reviews (user_id, product_id, order_id, rating, title, comment, is_verified)
VALUES (1, 1, 1, 5, 'Great product!', 'Fresh and delicious apples, highly recommended!', TRUE);

-- 29. Get Product Reviews
SELECT * FROM product_reviews 
WHERE product_id = 1
ORDER BY created_at DESC;

-- 30. Get Average Rating for Product
SELECT 
    product_id,
    AVG(rating) as average_rating,
    COUNT(*) as total_reviews
FROM reviews 
WHERE product_id = 1 AND is_approved = TRUE
GROUP BY product_id;

-- 31. Get User Reviews
SELECT 
    r.review_id,
    p.product_name,
    r.rating,
    r.title,
    r.comment,
    r.created_at
FROM reviews r
JOIN products p ON r.product_id = p.product_id
WHERE r.user_id = 1
ORDER BY r.created_at DESC;

-- =============================================
-- COUPON MANAGEMENT QUERIES
-- =============================================

-- 32. Check Coupon Validity
SELECT 
    coupon_id,
    discount_type,
    discount_value,
    minimum_order_amount,
    maximum_discount_amount,
    usage_limit,
    used_count
FROM coupons 
WHERE coupon_code = 'WELCOME10' 
AND is_active = TRUE 
AND valid_from <= CURRENT_TIMESTAMP 
AND valid_until >= CURRENT_TIMESTAMP
AND (usage_limit IS NULL OR used_count < usage_limit);

-- 33. Apply Coupon to Order
UPDATE orders 
SET discount_amount = 35.00, total_amount = total_amount - 35.00
WHERE order_id = 1;

-- 34. Record Coupon Usage
INSERT INTO coupon_usage (coupon_id, user_id, order_id, discount_amount)
VALUES (1, 1, 1, 35.00);

-- =============================================
-- ANALYTICS AND REPORTING QUERIES
-- =============================================

-- 35. Get Sales Report (Last 30 days)
SELECT 
    DATE(order_date) as sale_date,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as average_order_value
FROM orders 
WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
AND order_status IN ('Delivered', 'Shipped')
GROUP BY DATE(order_date)
ORDER BY sale_date DESC;

-- 36. Get Top Selling Products
SELECT 
    p.product_name,
    SUM(oi.quantity) as total_sold,
    SUM(oi.total_price) as total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status IN ('Delivered', 'Shipped')
AND o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 10;

-- 37. Get Customer Statistics
SELECT 
    COUNT(DISTINCT user_id) as total_customers,
    COUNT(DISTINCT CASE WHEN created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) THEN user_id END) as new_customers_30_days,
    AVG(order_count) as avg_orders_per_customer
FROM (
    SELECT 
        user_id,
        created_at,
        COUNT(*) as order_count
    FROM orders 
    GROUP BY user_id, created_at
) customer_stats;

-- 38. Get Inventory Report
SELECT 
    c.category_name,
    COUNT(p.product_id) as total_products,
    SUM(p.stock_quantity) as total_stock,
    COUNT(CASE WHEN p.stock_quantity <= p.min_stock_level THEN 1 END) as low_stock_products
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
GROUP BY c.category_id, c.category_name
ORDER BY total_products DESC;

-- =============================================
-- ADMIN QUERIES
-- =============================================

-- 39. Get All Users (Admin)
SELECT 
    user_id,
    username,
    email,
    first_name,
    last_name,
    phone,
    is_active,
    created_at
FROM users 
ORDER BY created_at DESC;

-- 40. Get Order Statistics (Admin)
SELECT 
    order_status,
    COUNT(*) as order_count,
    SUM(total_amount) as total_value
FROM orders 
WHERE order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
GROUP BY order_status;

-- 41. Get Product Performance (Admin)
SELECT 
    p.product_name,
    p.price,
    p.stock_quantity,
    COUNT(oi.order_item_id) as times_ordered,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.total_price) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_status IN ('Delivered', 'Shipped')
GROUP BY p.product_id, p.product_name, p.price, p.stock_quantity
ORDER BY total_revenue DESC;

-- =============================================
-- SEARCH AND FILTER QUERIES
-- =============================================

-- 42. Advanced Product Search
SELECT * FROM product_details 
WHERE (product_name LIKE '%apple%' OR description LIKE '%apple%')
AND final_price BETWEEN 50 AND 200
AND category_name = 'Fruits'
AND is_active = TRUE
ORDER BY 
    CASE WHEN product_name LIKE 'apple%' THEN 1 ELSE 2 END,
    final_price;

-- 43. Get Products by Multiple Categories
SELECT * FROM product_details 
WHERE category_name IN ('Fruits', 'Vegetables', 'Dairy')
AND is_active = TRUE
ORDER BY category_name, product_name;

-- 44. Get Recently Added Products
SELECT * FROM product_details 
WHERE created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
AND is_active = TRUE
ORDER BY created_at DESC;

-- =============================================
-- MAINTENANCE QUERIES
-- =============================================

-- 45. Clean Up Old Cart Items (older than 30 days)
DELETE FROM cart 
WHERE added_at < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 30 DAY);

-- 46. Update Product Stock
UPDATE products 
SET stock_quantity = stock_quantity + 100
WHERE product_id = 1;

-- 47. Deactivate Out of Stock Products
UPDATE products 
SET is_active = FALSE 
WHERE stock_quantity = 0;

-- 48. Get Database Size
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'easycart_db'
ORDER BY (data_length + index_length) DESC;
