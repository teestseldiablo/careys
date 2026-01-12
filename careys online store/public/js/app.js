document.addEventListener('alpine:init', () => {
    
    // Logic for Shop and Cart
    Alpine.data('shopEngine', () => ({
        category: 'all',
        // Load cart from storage or start empty
        cart: JSON.parse(localStorage.getItem('careys_cart')) || [],
        
        products: [
            { cat: 'electronics', brand: 'SONY', name: 'Bravia XR OLED', price: 1899, desc: '65" 4K Smart TV', img: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=600' },
            { cat: 'appliances', brand: 'GE PROFILE', name: 'Smart French Door', price: 3200, desc: 'Counter-depth Refrigerator', img: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600' },
            { cat: 'furniture', brand: 'ASHLEY', name: 'Signature Sofa', price: 1250, desc: 'Midnight Grain Leather', img: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600' }
        ],

        addToCart(product) {
            this.cart.push(product);
            localStorage.setItem('careys_cart', JSON.stringify(this.cart));
            alert(`${product.name} added to your project!`);
        },

        get cartCount() {
            return this.cart.length;
        }
    }));

    // Logic for Admin Portal
    Alpine.data('careyAdmin', () => ({
        view: 'Dashboard',
        searchQuery: '',
        orders: [
            { id: 1024, customer: 'Robert Peterson', item: 'Sony 8K OLED', status: 'Processing' },
            { id: 1025, customer: 'Maria Gomez', item: 'Ashley Sofa', status: 'In Warehouse' }
        ],
        // Use the same product list as the shop for consistency
        products: [
            { cat: 'electronics', brand: 'SONY', name: 'Bravia XR OLED', price: 1899, img: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=200' },
            { cat: 'appliances', brand: 'GE PROFILE', name: 'Smart French Door', price: 3200, img: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=200' },
            { cat: 'furniture', brand: 'ASHLEY', name: 'Signature Sofa', price: 1250, img: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200' }
        ],
        pushToTruck(id) {
            this.orders = this.orders.filter(o => o.id !== id);
            alert("Order Dispatched to Carey's Fleet!");
        }
    }));
});