<?php
header('Content-Type: application/json');
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $categoryId = $_GET['id'] ?? null;
        
        if (!$categoryId) {
            throw new Exception('Category ID is required');
        }
        
        $category_name = $_POST['category_name'] ?? '';
        $description = $_POST['description'] ?? '';
        $parent_category_id = $_POST['parent_category_id'] ?? null;
        $is_active = $_POST['is_active'] ?? 1;
        
        if (empty($category_name)) {
            throw new Exception('Category name is required');
        }
        
        $query = "UPDATE categories SET category_name = :category_name, description = :description, 
                  parent_category_id = :parent_category_id, is_active = :is_active 
                  WHERE category_id = :id";
        
        $stmt = $conn->prepare($query);
        $stmt->bindValue(':category_name', $category_name);
        $stmt->bindValue(':description', $description);
        $stmt->bindValue(':parent_category_id', $parent_category_id ?: null, PDO::PARAM_INT);
        $stmt->bindValue(':is_active', $is_active);
        $stmt->bindValue(':id', $categoryId);
        
        if ($stmt->execute()) {
            echo json_encode([
                'success' => true,
                'message' => 'Category updated successfully',
                'category_id' => $categoryId
            ]);
        } else {
            throw new Exception('Failed to update category');
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
