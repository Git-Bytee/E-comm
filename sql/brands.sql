-- Brands SQL examples

-- List all brands
SELECT brand_id, brand_name, description, logo_url, website_url, is_active, created_at
FROM brands
ORDER BY brand_name ASC;

-- Insert a brand
INSERT INTO brands (brand_name, description, logo_url, website_url, is_active)
VALUES ('New Brand', 'Brand description', '', '', TRUE);

-- Update a brand
UPDATE brands
SET brand_name='Updated Brand', website_url='https://example.com'
WHERE brand_id = 1;

-- Delete a brand (only if unused)
DELETE FROM brands WHERE brand_id = 1;
