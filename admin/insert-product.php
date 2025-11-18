<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Insert Product - EasyCart Admin</title>
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
            <a class="navbar-brand" href="../index.html">
        <img src="../images/logo.png" alt="EasyCart Logo" class="logo" />
      </a>
      <span class="navbar-text text-light ms-auto me-3">Admin • Insert Product</span>
    </div>
  </nav>

  <div class="container my-4">
    <div class="card shadow-sm">
      <div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h4 class="m-0">Add New Product</h4>
          <a href="manage-products.html" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left me-1"></i> Back to Products
          </a>
        </div>
        
        <form id="productForm" class="row g-3" enctype="multipart/form-data">
          <!-- Basic Information -->
          <div class="col-12">
            <h5 class="border-bottom pb-2">Basic Information</h5>
          </div>
          
          <div class="col-md-6">
            <label class="form-label">Product Name *</label>
            <input type="text" class="form-control" id="pname" required 
                   placeholder="Enter product name" />
            <div class="form-text">A clear and descriptive name for the product</div>
          </div>
          
          <div class="col-md-3">
            <label class="form-label">Price (₹) *</label>
            <div class="input-group">
              <span class="input-group-text">₹</span>
              <input type="number" step="0.01" min="0" class="form-control" 
                     id="price" required placeholder="0.00" />
            </div>
          </div>
          
          <div class="col-md-3">
            <label class="form-label">Discount Price (₹)</label>
            <div class="input-group">
              <span class="input-group-text">₹</span>
              <input type="number" step="0.01" min="0" class="form-control" 
                     id="dprice" placeholder="0.00" />
            </div>
            <div class="form-text">Leave empty if no discount</div>
          </div>
          
          <div class="col-md-6">
            <label class="form-label">Category *</label>
            <select class="form-select" id="category" required>
              <option value="">Loading categories...</option>
            </select>
          </div>
          
          <div class="col-md-6">
            <label class="form-label">Brand</label>
            <select class="form-select" id="brand">
              <option value="">Loading brands...</option>
            </select>
          </div>
          <div class="col-12">
            <label class="form-label">Short Description</label>
            <input type="text" class="form-control" id="sdesc" required />
          </div>
          <div class="col-12">
            <label class="form-label">Description</label>
            <textarea class="form-control" id="desc" rows="4" required></textarea>
          </div>
          <div class="col-md-6">
            <label class="form-label">Stock Quantity</label>
            <input type="number" class="form-control" id="stock" required />
          </div>
          <div class="col-md-6">
            <label class="form-label">SKU(Stock Keeping Unit)</label>
            <input type="text" class="form-control" id="sku" required />
          </div>
          <div class="col-12">
            <label class="form-label">Image URL</label>
            <input type="url" class="form-control" id="imgurl" />
          </div>
          <div class="col-12 d-flex gap-2">
            <button type="submit" class="btn btn-primary">Save</button>
            <a class="btn btn-secondary" href="manage-products.html">Back to Products</a>
          </div>
        </form>
      </div>
    </div>
  </div>

<!-- bootstrap js link -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let categories = [];
    let brands = [];

    document.addEventListener('DOMContentLoaded', function() {
      loadCategories();
      loadBrands();
    });

    async function loadCategories() {
      try {
        const response = await fetch('../api/get_categories.php');
        if (response.ok) {
          categories = await response.json();
          const select = document.getElementById('category');
          select.innerHTML = '<option value="">Select Category</option>';
          categories.forEach(cat => {
            select.innerHTML += `<option value="${cat.category_id}">${cat.category_name}</option>`;
          });
        }
      } catch (error) {
        console.error('Error loading categories:', error);
        alert('Failed to load categories');
      }
    }

    async function loadBrands() {
      try {
        const response = await fetch('../api/get_brands.php');
        if (response.ok) {
          brands = await response.json();
          const select = document.getElementById('brand');
          select.innerHTML = '<option value="">Select Brand</option>';
          brands.forEach(brand => {
            select.innerHTML += `<option value="${brand.brand_id}">${brand.brand_name}</option>`;
          });
        }
      } catch (error) {
        console.error('Error loading brands:', error);
      }
    }

    document.getElementById('productForm').addEventListener('submit', async function(e) {
      e.preventDefault();
      
      const submitBtn = e.target.querySelector('button[type="submit"]');
      submitBtn.disabled = true;
      submitBtn.textContent = 'Saving...';
      
      const formData = new FormData();
      formData.append('product_name', document.getElementById('pname').value);
      formData.append('description', document.getElementById('desc').value);
      formData.append('short_description', document.getElementById('sdesc').value);
      formData.append('category_id', document.getElementById('category').value);
      formData.append('brand_id', document.getElementById('brand').value || null);
      formData.append('sku', document.getElementById('sku').value);
      formData.append('price', document.getElementById('price').value);
      formData.append('discount_price', document.getElementById('dprice').value || null);
      formData.append('stock_quantity', document.getElementById('stock').value);
      formData.append('image_url', document.getElementById('imgurl').value || './images/logo.png');
      formData.append('is_active', 1);
      formData.append('is_featured', 0);

      try {
        const response = await fetch('../api/insert_products.php', {
          method: 'POST',
          body: formData
        });
        
        const result = await response.json();
        
        if (response.ok && result.success) {
          alert('✓ Product added successfully!');
          document.getElementById('productForm').reset();
          window.location.href = 'manage-products.html';
        } else {
          alert('✗ Error: ' + (result.message || 'Failed to add product'));
          submitBtn.disabled = false;
          submitBtn.textContent = 'Save';
        }
      } catch (error) {
        console.error('Error:', error);
        alert('✗ Error adding product: ' + error.message);
        submitBtn.disabled = false;
        submitBtn.textContent = 'Save';
      }
    });
  </script>
</body>
</html>
