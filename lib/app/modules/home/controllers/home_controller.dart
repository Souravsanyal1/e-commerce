import 'dart:async';
import 'package:get/get.dart';

// ═══════════════════════════════════════════════════════════════
// Product Model
// ═══════════════════════════════════════════════════════════════
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String category;
  final String tag; // e.g., 'Flash Sale', 'Popular', 'Hot Offer'
  final int stock;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.category,
    required this.tag,
    required this.stock,
  });

  double get activePrice => discountPrice > 0 ? discountPrice : price;
  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  int get discountPercentage => hasDiscount ? (((price - discountPrice) / price) * 100).round() : 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ═══════════════════════════════════════════════════════════════
// HomeController
// ═══════════════════════════════════════════════════════════════
class HomeController extends GetxController {
  // Navigation
  final currentTab = 0.obs;

  // Active user / Location
  final deliveryLocation = 'Dhaka'.obs; // Dhaka / Outside Dhaka
  final deliveryAddress = 'Dhanmondi, Dhaka'.obs;

  // Search & Filtering
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;

  // Loading
  final isLoading = false.obs;

  // Live Timer for Flash Sale
  final flashSaleSeconds = (2 * 3600 + 45 * 60 + 12).obs; // 2h 45m 12s
  Timer? _timer;
  final flashSaleTimerText = '02:45:12'.obs;

  // Wishlist
  final wishlist = <int>[].obs;

  // Cart Management
  final cart = <Product, int>{}.obs;
  final promoControllerText = ''.obs;
  final appliedPromoCode = ''.obs;
  final promoDiscountAmount = 0.0.obs;

  // ── Mock Categories ──
  final categories = [
    {'name': 'All', 'icon': '🛍️'},
    {'name': 'Groceries', 'icon': '🍏'},
    {'name': 'Fashion', 'icon': '👗'},
    {'name': 'Electronics', 'icon': '📱'},
    {'name': 'Beauty', 'icon': '💄'},
    {'name': 'Books', 'icon': '📚'},
  ];

  // ── Mock Products (High-Quality Bangladeshi context with Unsplash URLs) ──
  final products = <Product>[
    const Product(
      id: 1,
      title: 'Premium Chinigura Chal (Chondrabhona)',
      description: 'Chinigura Rice is famous for its aroma, taste, and quality. Handpicked organic grains perfect for Biryani, Pulao, and Payesh.',
      price: 180.0,
      discountPrice: 165.0,
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=600&auto=format&fit=crop',
      rating: 4.8,
      reviews: 145,
      category: 'Groceries',
      tag: 'Flash Sale',
      stock: 45,
    ),
    const Product(
      id: 2,
      title: 'Pure Mustard Oil (Ghani Vanga) - 1L',
      description: '100% pure mustard oil extracted using traditional cold press (Ghani). Keeps aroma and pungency intact, ensuring natural health benefits.',
      price: 320.0,
      discountPrice: 280.0,
      imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?q=80&w=600&auto=format&fit=crop',
      rating: 4.9,
      reviews: 98,
      category: 'Groceries',
      tag: 'Flash Sale',
      stock: 20,
    ),
    const Product(
      id: 3,
      title: 'Premium Handloom Jamdani Saree',
      description: 'Authentic Tangail Handloom Dhakai Jamdani Saree. Exquisite thread work in elegant colors, ideal for festivals and weddings.',
      price: 4500.0,
      discountPrice: 3800.0,
      imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?q=80&w=600&auto=format&fit=crop',
      rating: 4.7,
      reviews: 32,
      category: 'Fashion',
      tag: 'Popular',
      stock: 5,
    ),
    const Product(
      id: 4,
      title: 'Slim Fit Cotton Panjabi - Teal Green',
      description: 'Made from high-quality organic cotton. Soft, breathable, and features modern minimal embroidery on the collar and placket.',
      price: 1850.0,
      discountPrice: 1450.0,
      imageUrl: 'https://images.unsplash.com/photo-1605518216938-7c31b7b14ad0?q=80&w=600&auto=format&fit=crop',
      rating: 4.6,
      reviews: 64,
      category: 'Fashion',
      tag: 'Popular',
      stock: 12,
    ),
    const Product(
      id: 5,
      title: 'Noise Cancelling Wireless Earbuds',
      description: 'TWS earbuds featuring Active Noise Cancellation (ANC), 30-hour battery life, water resistance, and rich deep bass.',
      price: 2500.0,
      discountPrice: 1999.0,
      imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=600&auto=format&fit=crop',
      rating: 4.5,
      reviews: 210,
      category: 'Electronics',
      tag: 'Flash Sale',
      stock: 35,
    ),
    const Product(
      id: 6,
      title: 'Amoled Smart Watch Series 8',
      description: 'Full touch premium smartwatch with blood oxygen monitor, steps tracker, custom watch faces, and direct call functionality.',
      price: 3800.0,
      discountPrice: 3100.0,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=600&auto=format&fit=crop',
      rating: 4.7,
      reviews: 87,
      category: 'Electronics',
      tag: 'Hot Offer',
      stock: 15,
    ),
    const Product(
      id: 7,
      title: 'Organic Aloe Vera Gel - 250ml',
      description: 'Pure soothing gel containing 99% organic Aloe Vera. Refreshes skin, hydrates hair, and soothes burns or skin irritations.',
      price: 450.0,
      discountPrice: 390.0,
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600&auto=format&fit=crop',
      rating: 4.8,
      reviews: 124,
      category: 'Beauty',
      tag: 'Hot Offer',
      stock: 50,
    ),
    const Product(
      id: 8,
      title: 'Shorisha Modhu (Mustard Honey) - 500g',
      description: 'Natural raw mustard honey harvested directly by bee farms. Unprocessed, pure, and loaded with essential nutrients.',
      price: 380.0,
      discountPrice: 0.0, // No discount
      imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?q=80&w=600&auto=format&fit=crop',
      rating: 4.9,
      reviews: 43,
      category: 'Groceries',
      tag: 'Popular',
      stock: 18,
    ),
    const Product(
      id: 9,
      title: 'Humayun Ahmed Upanyas Somogro',
      description: 'A masterpiece hardcover compilation of selected novels by beloved Bangladeshi writer Humayun Ahmed.',
      price: 950.0,
      discountPrice: 820.0,
      imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=600&auto=format&fit=crop',
      rating: 4.9,
      reviews: 57,
      category: 'Books',
      tag: 'Popular',
      stock: 8,
    )
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _startFlashSaleTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  // ═══════════════════════════════════════════════════════════════
  // Timer logic
  // ═══════════════════════════════════════════════════════════════
  void _startFlashSaleTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (flashSaleSeconds.value > 0) {
        flashSaleSeconds.value--;
        
        final hours = flashSaleSeconds.value ~/ 3600;
        final minutes = (flashSaleSeconds.value % 3600) ~/ 60;
        final seconds = flashSaleSeconds.value % 60;

        final hStr = hours.toString().padLeft(2, '0');
        final mStr = minutes.toString().padLeft(2, '0');
        final sStr = seconds.toString().padLeft(2, '0');

        flashSaleTimerText.value = '$hStr:$mStr:$sStr';
      } else {
        flashSaleTimerText.value = 'Expired';
        _timer?.cancel();
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // Filtering & Search
  // ═══════════════════════════════════════════════════════════════
  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          product.category.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == 'All' || product.category == selectedCategory.value;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Product> get flashSaleProducts {
    return products.where((product) => product.tag == 'Flash Sale').toList();
  }

  // ═══════════════════════════════════════════════════════════════
  // Wishlist Logic
  // ═══════════════════════════════════════════════════════════════
  void toggleWishlist(int productId) {
    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
      Get.snackbar(
        'Wishlist Updated',
        'Product removed from your wishlist.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      wishlist.add(productId);
      Get.snackbar(
        'Wishlist Updated',
        'Product added to your wishlist.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Cart Logic
  // ═══════════════════════════════════════════════════════════════
  void addToCart(Product product) {
    if (cart.containsKey(product)) {
      final currentQuantity = cart[product]!;
      if (currentQuantity < product.stock) {
        cart[product] = currentQuantity + 1;
        _recalculateDiscount();
      } else {
        Get.snackbar(
          'Out of Stock',
          'Only ${product.stock} items available.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      cart[product] = 1;
      _recalculateDiscount();
      Get.snackbar(
        'Added to Cart',
        '${product.title} has been added to your shopping cart.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeFromCart(Product product) {
    if (cart.containsKey(product)) {
      cart.remove(product);
      _recalculateDiscount();
    }
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeFromCart(product);
    } else if (quantity <= product.stock) {
      cart[product] = quantity;
      _recalculateDiscount();
    } else {
      Get.snackbar(
        'Out of Stock',
        'Maximum available quantity is ${product.stock}.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearCart() {
    cart.clear();
    appliedPromoCode.value = '';
    promoDiscountAmount.value = 0.0;
  }

  int get cartItemCount => cart.values.fold(0, (sum, qty) => sum + qty);

  double get subtotal => cart.entries.fold(
      0.0, (sum, entry) => sum + (entry.key.activePrice * entry.value));

  double get deliveryFee => deliveryLocation.value == 'Dhaka' ? 60.0 : 120.0;

  double get total => subtotal + deliveryFee - promoDiscountAmount.value;

  // ═══════════════════════════════════════════════════════════════
  // Promo Coupon Validation
  // ═══════════════════════════════════════════════════════════════
  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'BAZAAR10') {
      appliedPromoCode.value = cleanCode;
      _recalculateDiscount();
      Get.snackbar(
        'Promo Applied',
        'You got 10% discount on your order!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else if (cleanCode == 'EID50') {
      appliedPromoCode.value = cleanCode;
      _recalculateDiscount();
      Get.snackbar(
        'Promo Applied',
        'You got 50% discount (up to ৳200) on your order!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else {
      Get.snackbar(
        'Invalid Promo',
        'The promo code entered is not valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  void removePromoCode() {
    appliedPromoCode.value = '';
    promoDiscountAmount.value = 0.0;
  }

  void _recalculateDiscount() {
    if (appliedPromoCode.value == 'BAZAAR10') {
      promoDiscountAmount.value = subtotal * 0.10;
    } else if (appliedPromoCode.value == 'EID50') {
      // 50% up to 200
      final calculated = subtotal * 0.50;
      promoDiscountAmount.value = calculated > 200.0 ? 200.0 : calculated;
    } else {
      promoDiscountAmount.value = 0.0;
    }
  }

  void updateDeliveryLocation(String location) {
    deliveryLocation.value = location;
    if (location == 'Dhaka') {
      deliveryAddress.value = 'Dhanmondi, Dhaka';
    } else {
      deliveryAddress.value = 'Agrabad, Chattogram';
    }
  }
}
