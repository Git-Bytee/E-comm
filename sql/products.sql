-- Products SQL examples (no backend runtime required)

-- List all products with category and brand
SELECT p.product_id, p.product_name, p.price, p.discount_price, p.stock_quantity,
       c.category_name, b.brand_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
ORDER BY p.created_at DESC;

-- Insert a new product
INSERT INTO products (
  product_name, description, short_description, category_id, brand_id,
  sku, price, discount_price, stock_quantity, image_url, is_active, is_featured
) VALUES (
  'Sample Product', 'Long description...', 'Short desc', 1, 1,
  'SMP-001', 999.00, NULL, 10, './images/sample.png', TRUE, FALSE
);

-- Update a product
UPDATE products
SET product_name='Updated Name', price=899.00, stock_quantity=25
WHERE product_id = 1;

-- Delete a product
DELETE FROM products WHERE product_id = 1;
