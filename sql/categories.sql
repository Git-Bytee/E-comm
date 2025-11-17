-- Categories SQL examples

-- List all categories
SELECT category_id, category_name, description, parent_category_id, is_active, created_at
FROM categories
ORDER BY category_name ASC;

-- Insert a category
INSERT INTO categories (category_name, description, parent_category_id, is_active)
VALUES ('New Category', 'Description here', NULL, TRUE);

-- Update a category
UPDATE categories
SET category_name='Updated Category', is_active=TRUE
WHERE category_id = 1;

-- Delete a category (only if unused)
DELETE FROM categories WHERE category_id = 1;
