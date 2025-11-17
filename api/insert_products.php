<?php
header('Content-Type: application/json');
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
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
        
        // Insert into database
        $columns = implode(', ', array_keys($data));
        $placeholders = ':' . implode(', :', array_keys($data));
        
        $query = "INSERT INTO products ($columns) VALUES ($placeholders)";
        $stmt = $conn->prepare($query);
        
        foreach ($data as $key => $value) {
            $stmt->bindValue(":$key", $value);
        }
        
        if ($stmt->execute()) {
            $productId = $conn->lastInsertId();
            echo json_encode([
                'success' => true,
                'message' => 'Product added successfully',
                'product_id' => $productId
            ]);
        } else {
            throw new Exception('Failed to insert product');
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