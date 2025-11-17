document.addEventListener('DOMContentLoaded', async function() {
    try {
        // Initialize the store
        window.store = await EasyCartStore.init();
        
        // Initialize tooltips
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Initialize form validation
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });

        // Add loading state to all forms
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', async function(e) {
                const submitBtn = this.querySelector('button[type="submit"]');
                if (submitBtn) {
                    Utils.showLoading(submitBtn);
                }
            });
        });

        console.log('Application initialized');
    } catch (error) {
        console.error('Failed to initialize application:', error);
        Utils.showToast('Failed to initialize application', 'danger');
    }
});