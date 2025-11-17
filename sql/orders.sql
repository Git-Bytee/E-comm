-- Orders SQL examples

-- List orders with summary
SELECT o.order_id, o.order_number, o.order_status, o.payment_status, o.total_amount, o.order_date,
       u.first_name, u.last_name, u.email,
       COUNT(oi.order_item_id) AS item_count, SUM(oi.quantity) AS total_items
FROM orders o
JOIN users u ON o.user_id = u.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_number, o.order_status, o.payment_status, o.total_amount, o.order_date, u.first_name, u.last_name, u.email
ORDER BY o.order_date DESC;

-- View single order with items
SELECT oi.order_item_id, oi.product_id, p.product_name, oi.quantity, oi.unit_price, oi.total_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;

-- Update order status
UPDATE orders SET order_status='Shipped', payment_status='Paid' WHERE order_id = 1;
