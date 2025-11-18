<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Insert Brand - EasyCart Admin</title>
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
      <span class="navbar-text text-light ms-auto me-3">Admin • Insert Brand</span>
    </div>
  </nav>

  <div class="container my-4">
    <div class="card shadow-sm">
      <div class="card-body">
        <h4 class="mb-3">Insert Brand</h4>
        <form id="brandForm" class="row g-3">
          <div class="col-md-8">
            <label class="form-label">Brand Name</label>
            <input type="text" class="form-control" id="bname" required />
          </div>
          <div class="col-md-4">
            <label class="form-label">Website URL</label>
            <input type="url" class="form-control" id="bwebsite" />
          </div>
          <div class="col-12">
            <label class="form-label">Description</label>
            <textarea class="form-control" id="bdesc" rows="3"></textarea>
          </div>
          <div class="col-12">
            <label class="form-label">Logo URL</label>
            <input type="text" class="form-control" id="blogo" />
          </div>
          <div class="col-12 d-flex gap-2">
            <button type="submit" class="btn btn-primary">Save</button>
            <a class="btn btn-secondary" href="manage-brands.html">Back to Brands</a>
          </div>
        </form>
      </div>
    </div>
  </div>

<!-- bootstrap js link -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('brandForm').addEventListener('submit', async function(e) {
      e.preventDefault();
      
      const submitBtn = e.target.querySelector('button[type="submit"]');
      submitBtn.disabled = true;
      submitBtn.textContent = 'Saving...';
      
      const formData = new FormData();
      formData.append('brand_name', document.getElementById('bname').value);
      formData.append('description', document.getElementById('bdesc').value);
      formData.append('logo_url', document.getElementById('blogo').value || '');
      formData.append('website_url', document.getElementById('bwebsite').value || '');
      formData.append('is_active', 1);
      
      try {
        const response = await fetch('../api/insert_brand.php', {
          method: 'POST',
          body: formData
        });
        
        const result = await response.json();
        
        if (response.ok && result.success) {
          alert('✓ Brand added successfully!');
          document.getElementById('brandForm').reset();
          window.location.href = 'manage-brands.html';
        } else {
          alert('✗ Error: ' + (result.message || 'Failed to add brand'));
          submitBtn.disabled = false;
          submitBtn.textContent = 'Save';
        }
      } catch (error) {
        console.error('Error:', error);
        alert('✗ Error adding brand: ' + error.message);
        submitBtn.disabled = false;
        submitBtn.textContent = 'Save';
      }
    });
  </script>
</body>
</html>
