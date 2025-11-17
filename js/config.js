const Config = {
    api: {
        baseUrl: '/api',
        endpoints: {
            categories: '/categories.php',
            brands: '/brands.php',
            products: '/products.php'
        }
    },
    upload: {
        maxFileSize: 5 * 1024 * 1024, // 5MB
        allowedImageTypes: ['image/jpeg', 'image/png', 'image/webp']
    }
};

window.Config = Config;