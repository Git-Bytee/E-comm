<?php
header('Content-Type: application/json');
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Validate input
        $brandName = trim($_POST['brand_name'] ?? '');
        $description = trim($_POST['description'] ?? '');
        $isActive = isset($_POST['is_active']) ? (int)$_POST['is_active'] : 1;
        
        if (empty($brandName)) {
            throw new Exception('Brand name is required');
        }
        
        // Check for duplicate brand name
        $checkStmt = $conn->prepare("SELECT brand_id FROM brands WHERE brand_name = ?");
        $checkStmt->execute([$brandName]);
        
        if ($checkStmt->rowCount() > 0) {
            throw new Exception('A brand with this name already exists');
        }
        
        // Handle logo upload
        $logoUrl = null;
        if (isset($_FILES['logo']) && $_FILES['logo']['error'] === UPLOAD_ERR_OK) {
            $uploadDir = '../uploads/brands/';
            if (!file_exists($uploadDir)) {
                mkdir($uploadDir, 0777, true);
            }
            
            $fileName = uniqid() . '_' . basename($_FILES['logo']['name']);
            $targetPath = $uploadDir . $fileName;
            
            if (move_uploaded_file($_FILES['logo']['tmp_name'], $targetPath)) {
                $logoUrl = 'uploads/brands/' . $fileName;
            }
        }
        
        // Insert new brand
        $stmt = $conn->prepare("
            INSERT INTO brands (brand_name, description, logo_url, is_active)
            VALUES (?, ?, ?, ?)
        ");
        
        $success = $stmt->execute([
            $brandName,
            $description,
            $logoUrl,
            $isActive
        ]);
        
        if ($success) {
            echo json_encode([
                'success' => true,
                'message' => 'Brand added successfully',
                'brand_id' => $conn->lastInsertId()
            ]);
        } else {
            throw new Exception('Failed to add brand');
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