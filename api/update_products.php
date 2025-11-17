<?php
header('Content-Type: application/json');
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $productId = $_GET['id'] ?? null;
        
        if (!$productId) {
            throw new Exception('Product ID is required');
        }
        
        // Get and validate input
        $required = ['product_name', 'price', 'category_id', 'sku', 'stock_quantity'];
        $data = [];
        
        foreach ($required as $field) {
            if (empty($_POST[$field])) {
                throw new Exception("Missing required field: $field");
            }
            $data[$field] = $_POST[$field];
        }
        
        // Optional fields
        $optional = [
            'description' => '',
            'short_description' => '',
            'brand_id' => null,
            'discount_price' => null,
            'image_url' => '',
            'is_active' => 1,
            'is_featured' => 0
        ];
        
        foreach ($optional as $field => $default) {
            $data[$field] = $_POST[$field] ?? $default;
        }
        
        // Handle file upload if present
        if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
            $uploadDir = '../uploads/products/';
            if (!file_exists($uploadDir)) {
                mkdir($uploadDir, 0777, true);
            }
            
            $fileName = uniqid() . '_' . basename($_FILES['image']['name']);
            $targetPath = $uploadDir . $fileName;
            
            if (move_uploaded_file($_FILES['image']['tmp_name'], $targetPath)) {
                $data['image_url'] = 'uploads/products/' . $fileName;
            }
        }
        
        // Update database
        $columns = array_map(fn($key) => "$key = :$key", array_keys($data));
        $query = "UPDATE products SET " . implode(', ', $columns) . " WHERE product_id = :product_id";
        
        $stmt = $conn->prepare($query);
        
        foreach ($data as $key => $value) {
            $stmt->bindValue(":$key", $value);
        }
        $stmt->bindValue(':product_id', $productId);
        
        if ($stmt->execute()) {
            echo json_encode([
                'success' => true,
                'message' => 'Product updated successfully',
                'product_id' => $productId
            ]);
        } else {
            throw new Exception('Failed to update product');
        }
        
    } catch (Exception $e) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage()
        ]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
