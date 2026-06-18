import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

// ═══════════════════════════════════════════════════════════════
// Admin Order Model
// ═══════════════════════════════════════════════════════════════
class AdminOrder {
  final int orderId;
  final String customerName;
  final String itemsSummary;
  final String address;
  final RxString status; // RxString so status tag updates reactively
  final String paymentMethod;
  final double amount;
  final String date;

  AdminOrder({
    required this.orderId,
    required this.customerName,
    required this.itemsSummary,
    required this.address,
    required String initialStatus,
    required this.paymentMethod,
    required this.amount,
    required this.date,
  }) : status = initialStatus.obs;
}

// ═══════════════════════════════════════════════════════════════
// Admin Controller
// ═══════════════════════════════════════════════════════════════
class AdminController extends GetxController {
  // Main Admin Tab Selection
  final adminTab = 0.obs;

  // Mock Sales & Revenue data
  final totalRevenue = 45200.0.obs;
  
  // Reference to HomeController
  late final HomeController homeController;

  // Mock Active Orders list
  final activeOrders = <AdminOrder>[].obs;

  // Mock Active Vouchers list
  final vouchers = <Map<String, dynamic>>[
    {'code': 'BAZAAR10', 'discount': '10% OFF', 'isActive': true.obs},
    {'code': 'EID50', 'discount': '50% OFF (Max ৳200)', 'isActive': true.obs},
    {'code': 'FREE60', 'discount': 'Free Delivery inside Dhaka', 'isActive': false.obs},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    homeController = Get.find<HomeController>();
    _initializeMockOrders();
  }

  void changeTab(int index) {
    adminTab.value = index;
  }

  // ── Initialize Mock Orders ──
  void _initializeMockOrders() {
    activeOrders.value = [
      AdminOrder(
        orderId: 90432,
        customerName: 'Sourav Sanyal',
        itemsSummary: '1x Premium Chinigura Chal, 1x ghani Mustard Oil',
        address: 'Dhanmondi, Dhaka',
        initialStatus: 'Pending',
        paymentMethod: 'bKash',
        amount: 445.0,
        date: '18 Jun 2026, 02:30 PM',
      ),
      AdminOrder(
        orderId: 90431,
        customerName: 'Tariqul Islam',
        itemsSummary: '1x Premium Cotton Punjabi (Teal)',
        address: 'Agrabad, Chattogram',
        initialStatus: 'Shipped',
        paymentMethod: 'Cash on Delivery',
        amount: 1570.0,
        date: '17 Jun 2026, 06:15 PM',
      ),
      AdminOrder(
        orderId: 90430,
        customerName: 'Nabila Rahman',
        itemsSummary: '1x Amoled Smart Watch Series 8',
        address: 'Mirpur, Dhaka',
        initialStatus: 'Delivered',
        paymentMethod: 'Nagad',
        amount: 3160.0,
        date: '15 Jun 2026, 11:20 AM',
      ),
    ];
  }

  // ── Inventory Stats ──
  int get totalProductsCount => homeController.products.length;

  int get lowStockProductsCount {
    return homeController.products.where((p) => p.stock < 10).length;
  }

  double get totalInventoryValue {
    return homeController.products.fold(0.0, (sum, p) => sum + (p.activePrice * p.stock));
  }

  // ── Product CRUD (Directly updates HomeController.products rx list) ──
  void addProduct(Product product) {
    homeController.products.add(product);
    Get.snackbar(
      'Product Added',
      '"${product.title}" has been added to catalog.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteProduct(int productId) {
    homeController.products.removeWhere((p) => p.id == productId);
    Get.snackbar(
      'Product Deleted',
      'Product removed from catalog.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateProductStock(int productId, int newStock) {
    final index = homeController.products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final old = homeController.products[index];
      homeController.products[index] = Product(
        id: old.id,
        title: old.title,
        description: old.description,
        price: old.price,
        discountPrice: old.discountPrice,
        imageUrl: old.imageUrl,
        rating: old.rating,
        reviews: old.reviews,
        category: old.category,
        tag: old.tag,
        stock: newStock,
      );
    }
  }

  void updateProductPrice(int productId, double price, double discountPrice) {
    final index = homeController.products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final old = homeController.products[index];
      homeController.products[index] = Product(
        id: old.id,
        title: old.title,
        description: old.description,
        price: price,
        discountPrice: discountPrice,
        imageUrl: old.imageUrl,
        rating: old.rating,
        reviews: old.reviews,
        category: old.category,
        tag: old.tag,
        stock: old.stock,
      );
    }
  }

  // ── Order status update ──
  void updateOrderStatus(int orderId, String newStatus) {
    final order = activeOrders.firstWhereOrNull((o) => o.orderId == orderId);
    if (order != null) {
      order.status.value = newStatus;
      Get.snackbar(
        'Order Updated',
        'Order #$orderId status set to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ── Voucher Management ──
  void toggleVoucherStatus(String code) {
    final voucher = vouchers.firstWhereOrNull((v) => v['code'] == code);
    if (voucher != null) {
      final rxActive = voucher['isActive'] as RxBool;
      rxActive.value = !rxActive.value;
      Get.snackbar(
        'Voucher Updated',
        'Coupon code $code is now ${rxActive.value ? 'Active' : 'Inactive'}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addNewVoucher(String code, String discount) {
    if (vouchers.any((v) => v['code'].toString().toUpperCase() == code.toUpperCase())) {
      Get.snackbar('Error', 'Promo code already exists!', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    vouchers.add({
      'code': code.toUpperCase(),
      'discount': discount,
      'isActive': true.obs,
    });
    Get.snackbar('Voucher Added', 'Coupon code $code created successfully.', snackPosition: SnackPosition.BOTTOM);
  }
}
