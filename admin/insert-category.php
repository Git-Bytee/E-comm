<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Insert Category - EasyCart Admin</title>
    <!-- bootstrap CSS link -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- font awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <!-- css file -->
    <link rel="stylesheet" href="../style.css">
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-light bg-success p-2">
    <div class="container-fluid">
      <a class="navbar-brand" href="index.html">
        <img src="../images/logo.png" alt="EasyCart Logo" class="logo" />
      </a>
      <span class="navbar-text text-light ms-auto me-3">Admin • Insert Category</span>
    </div>
  </nav>

  <div class="container my-4">
    <div class="card shadow-sm">
      <div class="card-body">
        <h4 class="mb-3">Insert Category</h4>
        <form id="categoryForm" class="row g-3">
          <div class="col-md-8">
            <label class="form-label">Category Name *</label>
            <input type="text" class="form-control" id="cname" required />
          </div>
          <div class="col-md-4">
            <label class="form-label">Parent Category</label>
            <select class="form-select" id="parent_category">
              <option value="">Loading categories...</option>
            </select>
          </div>
          <div class="col-12">
            <label class="form-label">Description</label>
            <textarea class="form-control" id="cdesc" rows="3"></textarea>
          </div>
          <div class="col-12 d-flex gap-2">
            <button type="submit" class="btn btn-primary">Save</button>
            <a class="btn btn-secondary" href="manage-categories.html">Back to Categories</a>
          </div>
        </form>
      </div>
    </div>
  </div>

<!-- bootstrap js link -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let categories = [];

    document.addEventListener('DOMContentLoaded', function() {
        loadCategories();
    });

    async function loadCategories() {
        try {
            const response = await fetch('../api/get_categories.php');
            if (response.ok) {
                categories = await response.json();
                const select = document.getElementById('parent_category');
                select.innerHTML = '<option value="">None (Top Level Category)</option>';
                
                categories.forEach(category => {
                    const option = document.createElement('option');
                    option.value = category.category_id;
                    option.textContent = category.category_name;
                    select.appendChild(option);
                });
            }
        } catch (error) {
            console.error('Error loading categories:', error);
        }
    }

    document.getElementById('categoryForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const submitBtn = e.target.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Saving...';
        
        const formData = new FormData();
        formData.append('category_name', document.getElementById('cname').value);
        formData.append('description', document.getElementById('cdesc').value);
        formData.append('parent_category_id', document.getElementById('parent_category').value || null);
        formData.append('is_active', 1);
        
        try {
            const response = await fetch('../api/insert_category.php', {
                method: 'POST',
                body: formData
            });
            
            const result = await response.json();
            
            if (response.ok && result.success) {
                alert('✓ Category added successfully!');
                document.getElementById('categoryForm').reset();
                window.location.href = 'manage-categories.html';
            } else {
                alert('✗ Error: ' + (result.message || 'Failed to add category'));
                submitBtn.disabled = false;
                submitBtn.textContent = 'Save';
            }
        } catch (error) {
            console.error('Error:', error);
            alert('✗ Error adding category: ' + error.message);
            submitBtn.disabled = false;
            submitBtn.textContent = 'Save';
        }
    });
</script>
        const form = e.target;
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalBtnText = submitBtn.innerHTML;
        
        try {
            // Disable submit button and show loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
            
            const categoryData = {
                category_name: document.getElementById('cname').value.trim(),
                description: document.getElementById('cdesc').value.trim(),
                parent_category_id: document.getElementById('parent_category').value || null,
                is_active: true
            };
            
            // Validate required fields
            if (!categoryData.category_name) {
                throw new Error('Category name is required');
            }
            
            // Check for duplicate category name
            const isDuplicate = categories.some(
                cat => cat.category_name.toLowerCase() === categoryData.category_name.toLowerCase()
            );
            
            if (isDuplicate) {
                throw new Error('A category with this name already exists');
            }
            
            // Create the category
            const result = await storeInstance.create('categories', categoryData);
            
            if (result) {
                alert('Category added successfully!');
                form.reset();
                // Reload categories to include the new one
                await loadCategories();
            } else {
                throw new Error('Failed to save category');
            }
            
        } catch (error) {
            console.error('Error:', error);
            alert('Error: ' + error.message);
        } finally {
            // Restore button state
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnText;
            }
        }
    }
  </script>
</body>
</html>
