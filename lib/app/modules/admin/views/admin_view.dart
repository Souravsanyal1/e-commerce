import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/admin_controller.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // ── Admin AppBar ──
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B), // Dark Slate
        elevation: 1,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BazaarBD Admin',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Store Manager Portal',
              style: TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar('Admin Settings', 'System configurations are up to date.', snackPosition: SnackPosition.BOTTOM);
            },
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
          ),
        ],
      ),

      // ── Body Tabs ──
      body: Obx(() {
        switch (controller.adminTab.value) {
          case 0:
            return const _AdminDashboardTab();
          case 1:
            return const _AdminProductsTab();
          case 2:
            return const _AdminOrdersTab();
          case 3:
            return const _AdminVouchersTab();
          default:
            return const _AdminDashboardTab();
        }
      }),

      // ── Bottom Navigation ──
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.adminTab.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF3F51B5), // Slate Blue / Indigo
          unselectedItemColor: const Color(0xFF64748B),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2_rounded),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              activeIcon: Icon(Icons.local_offer_rounded),
              label: 'Vouchers',
            ),
          ],
        ),
      ),

      // ── Add Product FAB (only visible in Products Tab) ──
      floatingActionButton: Obx(
        () => controller.adminTab.value == 1
            ? FloatingActionButton(
                backgroundColor: const Color(0xFF3F51B5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () => _showAddProductSheet(context),
                child: const Icon(Icons.add_rounded, size: 24),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  // ── Show Add Product Form Bottom Sheet ──
  void _showAddProductSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final discCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final imgCtrl = TextEditingController(
      text: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop', // Default red sneaker
    );

    final selectedCategory = 'Groceries'.obs;
    final selectedTag = 'Popular'.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Product',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Form Fields
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product Title *',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),

                Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: ['Groceries', 'Fashion', 'Electronics', 'Beauty', 'Books']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) selectedCategory.value = val;
                    },
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Original Price (৳) *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: discCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Discount Price (৳)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: stockCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stock Qty *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: selectedTag.value,
                          decoration: const InputDecoration(
                            labelText: 'Tag',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: ['None', 'Flash Sale', 'Popular', 'Hot Offer']
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) selectedTag.value = val;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: imgCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product Image URL',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.isEmpty || priceCtrl.text.isEmpty || stockCtrl.text.isEmpty) {
                        Get.snackbar('Input Error', 'Please fill in all required (*) fields.', snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      final price = double.tryParse(priceCtrl.text) ?? 0.0;
                      final discount = double.tryParse(discCtrl.text) ?? 0.0;
                      final stock = int.tryParse(stockCtrl.text) ?? 0;

                      final newProd = Product(
                        id: controller.homeController.products.length + 1,
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim().isEmpty ? 'No description available.' : descCtrl.text.trim(),
                        price: price,
                        discountPrice: discount,
                        imageUrl: imgCtrl.text.trim(),
                        rating: 5.0, // Brand new items start at 5 stars
                        reviews: 0,
                        category: selectedCategory.value,
                        tag: selectedTag.value == 'None' ? '' : selectedTag.value,
                        stock: stock,
                      );

                      controller.addProduct(newProd);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Add Product to Catalog', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Tab 0: Analytics & Sales Dashboard
// ═══════════════════════════════════════════════════════════════
class _AdminDashboardTab extends GetView<AdminController> {
  const _AdminDashboardTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Overview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),

          // KPI Metrices Grid (2x2)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              // Card 1: Revenue
              _buildKPICard(
                title: 'Revenue',
                value: '৳${controller.totalRevenue.value.toStringAsFixed(0)}',
                subtitle: '+12.4% from last week',
                icon: Icons.monetization_on_rounded,
                iconColor: Colors.green,
                bgColor: const Color(0xFFE8F5E9),
              ),
              // Card 2: Active Orders
              Obx(
                () => _buildKPICard(
                  title: 'Active Orders',
                  value: '${controller.activeOrders.length}',
                  subtitle: 'Pending packaging',
                  icon: Icons.local_shipping_rounded,
                  iconColor: Colors.blue,
                  bgColor: const Color(0xFFE3F2FD),
                ),
              ),
              // Card 3: Products
              Obx(
                () => _buildKPICard(
                  title: 'Store Products',
                  value: '${controller.totalProductsCount}',
                  subtitle: '5 active categories',
                  icon: Icons.inventory_rounded,
                  iconColor: Colors.purple,
                  bgColor: const Color(0xFFF3E5F5),
                ),
              ),
              // Card 4: Low Stock Alert
              Obx(
                () => _buildKPICard(
                  title: 'Low Stock Alerts',
                  value: '${controller.lowStockProductsCount}',
                  subtitle: 'Items with stock < 10',
                  icon: Icons.warning_rounded,
                  iconColor: Colors.red,
                  bgColor: const Color(0xFFFFEBEE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stock Value Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.store_mall_directory_rounded, color: Color(0xFF1E88E5)),
                ),
                const SizedBox(width: 14),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Inventory Asset Valuation',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '৳${controller.totalInventoryValue.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Low Stock warning items list
          const Text(
            '⚠️ Low Stock Warnings',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),

          Obx(() {
            final lowItems = controller.homeController.products.where((p) => p.stock < 10).toList();
            if (lowItems.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Center(
                  child: Text('All products are healthy in stock!', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              );
            }

            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lowItems.length,
                itemBuilder: (context, idx) {
                  final p = lowItems[idx];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          p.title,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(p.category, style: TextStyle(color: Colors.grey.shade400, fontSize: 9)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Only ${p.stock} Left',
                                style: const TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.updateProductStock(p.id, 25), // Quick restock to 25 items
                              child: const Icon(Icons.add_circle, color: Color(0xFF3F51B5), size: 18),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Tab 1: Product Inventory Manager
// ═══════════════════════════════════════════════════════════════
class _AdminProductsTab extends GetView<AdminController> {
  const _AdminProductsTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.homeController.products;

      return ListView.separated(
        itemCount: items.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final p = items[idx];
          final lowStock = p.stock < 10;

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Product Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: p.imageUrl,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey.shade100),
                  ),
                ),
                const SizedBox(width: 12),

                // Title, Price, category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(p.category, style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                          const SizedBox(width: 8),
                          if (p.tag.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1EE),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                p.tag,
                                style: const TextStyle(color: Color(0xFFFF5A36), fontSize: 7, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '৳${p.activePrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF3F51B5), fontSize: 12),
                          ),
                          if (p.hasDiscount) ...[
                            const SizedBox(width: 4),
                            Text(
                              '৳${p.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                          const SizedBox(width: 12),
                          // Stock Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: lowStock ? Colors.red.shade50 : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Stock: ${p.stock}',
                              style: TextStyle(
                                color: lowStock ? Colors.red : Colors.green,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Admin Controls (Stock Stepper, Price Edit, Delete)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Edit Price & Delete Row
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note, color: Colors.blue, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _showEditPriceDialog(context, p),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => controller.deleteProduct(p.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Quick stock stepper
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => controller.updateProductStock(p.id, p.stock - 1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              child: Icon(Icons.remove, size: 12),
                            ),
                          ),
                          Text(
                            '${p.stock}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () => controller.updateProductStock(p.id, p.stock + 1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              child: Icon(Icons.add, size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  // ── Show Edit Price Dialog ──
  void _showEditPriceDialog(BuildContext context, Product p) {
    final priceCtrl = TextEditingController(text: p.price.toStringAsFixed(0));
    final discCtrl = TextEditingController(text: p.discountPrice.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Edit Price: ${p.title}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Original Price (৳)', isDense: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: discCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Discount Price (৳) (Enter 0 if none)', isDense: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceCtrl.text) ?? p.price;
                final discount = double.tryParse(discCtrl.text) ?? 0.0;
                controller.updateProductPrice(p.id, price, discount);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51B5), foregroundColor: Colors.white),
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Tab 2: Orders Management List
// ═══════════════════════════════════════════════════════════════
class _AdminOrdersTab extends GetView<AdminController> {
  const _AdminOrdersTab();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final orders = controller.activeOrders;

      if (orders.isEmpty) {
        return const Center(child: Text('No active orders.'));
      }

      return ListView.separated(
        itemCount: orders.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final order = orders[idx];

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID & Status tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #BD-${order.orderId}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF1E293B)),
                    ),
                    Obx(() {
                      final status = order.status.value;
                      Color statusBg;
                      Color statusFg;

                      if (status == 'Delivered') {
                        statusBg = const Color(0xFFE8F5E9);
                        statusFg = Colors.green;
                      } else if (status == 'Shipped') {
                        statusBg = const Color(0xFFE3F2FD);
                        statusFg = Colors.blue;
                      } else if (status == 'Pending') {
                        statusBg = const Color(0xFFFFF3E0);
                        statusFg = Colors.orange;
                      } else {
                        statusBg = const Color(0xFFFFEBEE);
                        statusFg = Colors.red;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(color: statusFg, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  order.date,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 9),
                ),
                const Divider(height: 16),

                // Order details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      order.customerName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.itemsSummary,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      order.address,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                    ),
                  ],
                ),
                const Divider(height: 16),

                // Payment summary & Status selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Paid via ${order.paymentMethod}', style: TextStyle(color: Colors.grey.shade400, fontSize: 9)),
                        const SizedBox(height: 2),
                        Text(
                          '৳${order.amount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFFF5A36), fontSize: 14),
                        ),
                      ],
                    ),

                    // Status Dropdown selector
                    Obx(
                      () => DropdownButton<String>(
                        value: order.status.value,
                        underline: const SizedBox.shrink(),
                        icon: const Icon(Icons.edit_location_alt_rounded, color: Color(0xFF3F51B5), size: 16),
                        style: const TextStyle(color: Color(0xFF3F51B5), fontSize: 11, fontWeight: FontWeight.bold),
                        items: ['Pending', 'Packing', 'Shipped', 'Delivered', 'Cancelled']
                            .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.updateOrderStatus(order.orderId, val);
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════
// Tab 3: Voucher Code Panel
// ═══════════════════════════════════════════════════════════════
class _AdminVouchersTab extends GetView<AdminController> {
  const _AdminVouchersTab();

  @override
  Widget build(BuildContext context) {
    final codeCtrl = TextEditingController();
    final discCtrl = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Promo Coupons',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddVoucherDialog(context, codeCtrl, discCtrl),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Voucher', style: TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: controller.vouchers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, idx) {
                  final v = controller.vouchers[idx];
                  final code = v['code'] as String;
                  final disc = v['discount'] as String;
                  final rxActive = v['isActive'] as RxBool;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8EAF6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_offer, color: Color(0xFF3F51B5), size: 18),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                code,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                disc,
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                              ),
                            ],
                          ),
                        ),

                        // Toggle switch
                        Obx(
                          () => Switch(
                            value: rxActive.value,
                            onChanged: (_) => controller.toggleVoucherStatus(code),
                            activeThumbColor: const Color(0xFF3F51B5),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // ── Show Add Voucher Dialog ──
  void _showAddVoucherDialog(BuildContext context, TextEditingController codeCtrl, TextEditingController discCtrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Voucher Coupon', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Coupon Code (e.g. FLASH20)', isDense: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: discCtrl,
                decoration: const InputDecoration(labelText: 'Discount Description (e.g. 20% OFF)', isDense: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (codeCtrl.text.isNotEmpty && discCtrl.text.isNotEmpty) {
                  controller.addNewVoucher(codeCtrl.text.trim(), discCtrl.text.trim());
                  codeCtrl.clear();
                  discCtrl.clear();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51B5), foregroundColor: Colors.white),
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}
