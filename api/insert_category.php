<?php
header('Content-Type: application/json');
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Validate input
        $categoryName = trim($_POST['category_name'] ?? '');
        $description = trim($_POST['description'] ?? '');
        $parentId = !empty($_POST['parent_category_id']) ? (int)$_POST['parent_category_id'] : null;
        $isActive = isset($_POST['is_active']) ? (int)$_POST['is_active'] : 1;
        
        if (empty($categoryName)) {
            throw new Exception('Category name is required');
        }
        
        // Check for duplicate category name
        $checkStmt = $conn->prepare("SELECT category_id FROM categories WHERE category_name = ?");
        $checkStmt->execute([$categoryName]);
        
        if ($checkStmt->rowCount() > 0) {
            throw new Exception('A category with this name already exists');
        }
        
        // Insert new category
        $stmt = $conn->prepare("
            INSERT INTO categories (category_name, description, parent_category_id, is_active)
            VALUES (?, ?, ?, ?)
        ");
        
        $success = $stmt->execute([
            $categoryName,
            $description,
            $parentId,
            $isActive
        ]);
        
        if ($success) {
            echo json_encode([
                'success' => true,
                'message' => 'Category added successfully',
                'category_id' => $conn->lastInsertId()
            ]);
        } else {
            throw new Exception('Failed to add category');
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