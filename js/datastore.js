class EasyCartStore {
    static async init() {
        if (!this.instance) {
            this.instance = new EasyCartStore();
            await this.instance.initialize();
        }
        return this.instance;
    }

    async initialize() {
        // Initialize any required resources
        console.log('EasyCartStore initialized');
        return this;
    }

    async list(collection, filters = {}) {
        try {
            const query = Object.entries(filters)
                .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
                .join('&');
            
            const response = await fetch(`/api/${collection}.php${query ? '?' + query : ''}`);
            
            if (!response.ok) {
                throw new Error(`Failed to fetch ${collection}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error(`Error in list(${collection}):`, error);
            throw error;
        }
    }

    async create(collection, data) {
        try {
            const formData = new FormData();
            for (const key in data) {
                if (data[key] !== null && data[key] !== undefined) {
                    formData.append(key, data[key]);
                }
            }

            const response = await fetch(`/api/insert_${collection}.php`, {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                const error = await response.json().catch(() => ({}));
                throw new Error(error.message || 'Failed to create record');
            }

            return await response.json();
        } catch (error) {
            console.error(`Error in create(${collection}):`, error);
            throw error;
        }
    }

    async update(collection, id, data) {
        try {
            const formData = new FormData();
            for (const key in data) {
                if (data[key] !== null && data[key] !== undefined) {
                    formData.append(key, data[key]);
                }
            }

            const response = await fetch(`/api/update_${collection}.php?id=${id}`, {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                const error = await response.json().catch(() => ({}));
                throw new Error(error.message || 'Failed to update record');
            }

            return await response.json();
        } catch (error) {
            console.error(`Error in update(${collection}):`, error);
            throw error;
        }
    }

    async delete(collection, id) {
        try {
            const response = await fetch(`/api/delete_${collection}.php`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ id })
            });

            if (!response.ok) {
                const error = await response.json().catch(() => ({}));
                throw new Error(error.message || 'Failed to delete record');
            }

            return await response.json();
        } catch (error) {
            console.error(`Error in delete(${collection}):`, error);
            throw error;
        }
    }
}

window.EasyCartStore = EasyCartStore;