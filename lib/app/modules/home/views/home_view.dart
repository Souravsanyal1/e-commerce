import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      // ── Custom AppBar ──
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Obx(
          () => AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            titleSpacing: 16,
            title: Row(
              children: [
                // Brand / Location Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1EE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFFF5A36),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                // Location Selector
                GestureDetector(
                  onTap: () => _showLocationSelector(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Deliver to',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 12,
                            color: Color(0xFFFF5A36),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        controller.deliveryAddress.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Wishlist Dialog Button
              IconButton(
                onPressed: () => _showWishlistDialog(context),
                icon: const Icon(Icons.favorite_border_rounded),
                color: const Color(0xFF1E293B),
                tooltip: 'Wishlist',
              ),
              // Cart Shortcut
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () => controller.changeTab(2), // Go to Cart Tab
                    icon: const Icon(Icons.shopping_bag_outlined),
                    color: const Color(0xFF1E293B),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Obx(
                      () => controller.cartItemCount > 0
                          ? Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF5A36),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${controller.cartItemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ).animate(key: ValueKey(controller.cartItemCount)).scale(duration: 300.ms, curve: Curves.elasticOut)
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),

      // ── Body Tabs ──
      body: Obx(() {
        switch (controller.currentTab.value) {
          case 0:
            return const _HomeTab();
          case 1:
            return const _CategoriesTab();
          case 2:
            return const _CartTab();
          case 3:
            return const _ProfileTab();
          default:
            return const _HomeTab();
        }
      }),

      // ── Bottom Navigation Bar ──
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentTab.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFFF5A36),
          unselectedItemColor: const Color(0xFF64748B),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          elevation: 10,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              activeIcon: Icon(Icons.home_rounded, size: 22),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined, size: 22),
              activeIcon: Icon(Icons.grid_view_rounded, size: 22),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 22),
                  if (controller.cartItemCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5A36),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 13,
                          minHeight: 13,
                        ),
                        child: Text(
                          '${controller.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate(key: ValueKey(controller.cartItemCount)).scale(duration: 250.ms, curve: Curves.easeOutBack),
                    ),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_rounded, size: 22),
                  if (controller.cartItemCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5A36),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 13,
                          minHeight: 13,
                        ),
                        child: Text(
                          '${controller.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate(key: ValueKey(controller.cartItemCount)).scale(duration: 250.ms, curve: Curves.easeOutBack),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded, size: 22),
              activeIcon: Icon(Icons.person_rounded, size: 22),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Location selector sheet
  void _showLocationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Delivery Area',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Delivery fees and addresses depend on the location.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Color(0xFFFF5A36)),
                ),
                title: const Text('Inside Dhaka', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Flat Delivery Rate: ৳৬০ • Delivery in 24-48 Hours'),
                trailing: Obx(
                  () => controller.deliveryLocation.value == 'Dhaka'
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFFFF5A36))
                      : const SizedBox.shrink(),
                ),
                onTap: () {
                  controller.updateDeliveryLocation('Dhaka');
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Color(0xFFFF5A36)),
                ),
                title: const Text('Outside Dhaka (Chattogram etc.)', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Flat Delivery Rate: ৳১২০ • Delivery in 3-5 Days'),
                trailing: Obx(
                  () => controller.deliveryLocation.value != 'Dhaka'
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFFFF5A36))
                      : const SizedBox.shrink(),
                ),
                onTap: () {
                  controller.updateDeliveryLocation('Outside Dhaka');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Wishlist Dialog
  void _showWishlistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Obx(() {
          final wishlisted = controller.products.where((p) => controller.wishlist.contains(p.id)).toList();

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                const Text('My Wishlist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
            content: wishlisted.isEmpty
                ? SizedBox(
                    width: 280,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border_rounded, size: 36, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('Your wishlist is empty', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : SizedBox(
                    width: 320,
                    height: 300,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: wishlisted.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, idx) {
                        final product = wishlisted[idx];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey.shade100),
                            ),
                          ),
                          title: Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '৳${product.activePrice.toStringAsFixed(0)}',
                            style: const TextStyle(color: Color(0xFFFF5A36), fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                                color: const Color(0xFFFF5A36),
                                onPressed: () {
                                  controller.addToCart(product);
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                onPressed: () => controller.toggleWishlist(product.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          );
        });
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Tab 0: Home Page redone
// ═══════════════════════════════════════════════════════════════
class _HomeTab extends GetView<HomeController> {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.isLoading.value = true;
        await Future.delayed(const Duration(milliseconds: 800));
        controller.isLoading.value = false;
      },
      color: const Color(0xFFFF5A36),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar & Filter Row
            const SizedBox(height: 12),
            const _HomeSearchBar(),
            const SizedBox(height: 12),

            // Campaign Carousel
            const _CampaignSlider(),
            const SizedBox(height: 16),

            // Categories Section
            const _CategoriesRow(),
            const SizedBox(height: 20),

            // Flash Sale Section
            const _FlashSaleSection(),
            const SizedBox(height: 20),

            // Featured Products Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Product Grid
            const _ProductsGridView(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Custom Search Bar ──
class _HomeSearchBar extends GetView<HomeController> {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search organic rice, fashion, watch...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const VerticalDivider(width: 20, thickness: 1, indent: 8, endIndent: 8),
            GestureDetector(
              onTap: () {
                Get.snackbar('Filter', 'Advanced filtering option coming soon!', snackPosition: SnackPosition.BOTTOM);
              },
              child: const Icon(Icons.tune_rounded, color: Color(0xFFFF5A36), size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Campaign Image Slider ──
class _CampaignSlider extends StatefulWidget {
  const _CampaignSlider();

  @override
  State<_CampaignSlider> createState() => _CampaignSliderState();
}

class _CampaignSliderState extends State<_CampaignSlider> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'EID SPECIAL SALE',
      'subtitle': 'Up to 70% off on premium Punjabis, Sarees & more!',
      'tag': 'FREE DELIVERY',
      'colors': [Color(0xFFE64A19), Color(0xFFFF8A65)],
    },
    {
      'title': 'bKash Instant Cashbacks',
      'subtitle': 'Pay with bKash and get 15% instant cashback on checkout.',
      'tag': '15% CASHBACK',
      'colors': [Color(0xFFC2185B), Color(0xFFEC407A)],
    },
    {
      'title': 'Fresh Groceries Daily',
      'subtitle': 'Original cold pressed mustard oil, organic Chinigura rice.',
      'tag': '100% PURE',
      'colors': [Color(0xFF00796B), Color(0xFF4DB6AC)],
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            itemBuilder: (context, idx) {
              final banner = _banners[idx];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: banner['colors'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (banner['colors'][0] as Color).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              banner['tag'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner['title'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            banner['subtitle'] as String,
                            style: const TextStyle(color: Colors.white70, fontSize: 10, height: 1.2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Simulated bag/box graphics
                    const Expanded(
                      flex: 1,
                      child: Center(
                        child: Icon(
                          Icons.local_mall_rounded,
                          size: 60,
                          color: Colors.white24,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _banners.length,
            effect: ExpandingDotsEffect(
              dotWidth: 6,
              dotHeight: 6,
              activeDotColor: const Color(0xFFFF5A36),
              dotColor: Colors.grey.shade300,
            ),
          ),
        )
      ],
    );
  }
}

// ── Horizontal Categories Row ──
class _CategoriesRow extends GetView<HomeController> {
  const _CategoriesRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 76,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, idx) {
              final cat = controller.categories[idx];
              final name = cat['name']!;
              final icon = cat['icon']!;

              return Obx(() {
                final isSelected = controller.selectedCategory.value == name;
                return GestureDetector(
                  onTap: () {
                    controller.selectedCategory.value = name;
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF5A36) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF5A36) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF5A36).withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(icon, style: const TextStyle(fontSize: 20))
                            .animate(key: ValueKey(isSelected))
                            .scale(duration: 250.ms, curve: Curves.easeOutBack)
                            .shake(hz: 3, duration: 250.ms),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}

// ── Flash Sale Row with Timer ──
class _FlashSaleSection extends GetView<HomeController> {
  const _FlashSaleSection();

  @override
  Widget build(BuildContext context) {
    final flashProducts = controller.flashSaleProducts;
    if (flashProducts.isEmpty) return const SizedBox.shrink();

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF7F5),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Timer badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5A36),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt_rounded, color: Colors.white, size: 14)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.3, 1.3), duration: 600.ms)
                            .tint(color: Colors.yellow),
                        const SizedBox(width: 2),
                        const Text(
                          'FLASH SALE',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Timer ticking
                  Obx(
                    () => Text(
                      controller.flashSaleTimerText.value,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFFFF5A36),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.selectedCategory.value = 'All';
                      Get.snackbar('Flash Sale', 'Showing all ongoing flash sale items.', snackPosition: SnackPosition.BOTTOM);
                    },
                    child: const Row(
                      children: [
                        Text('See All', style: TextStyle(color: Color(0xFFFF5A36), fontSize: 11, fontWeight: FontWeight.bold)),
                        Icon(Icons.keyboard_arrow_right_rounded, color: Color(0xFFFF5A36), size: 14),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: flashProducts.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, idx) {
                  final p = flashProducts[idx];
                  return GestureDetector(
                    onTap: () => _showProductDetailsSheet(context, p),
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: CachedNetworkImage(
                                    imageUrl: p.imageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(color: Colors.grey.shade100),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF5A36),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '-${p.discountPercentage}%',
                                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      '৳${p.discountPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFFF5A36)),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '৳${p.price.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 9,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
  }
}

// ── Product Grid View ──
class _ProductsGridView extends GetView<HomeController> {
  const _ProductsGridView();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.filteredProducts;

      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 10),
                Text(
                  'No products found matching filters',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.76,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, idx) {
          final p = items[idx];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.015),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Product Image
                      GestureDetector(
                        onTap: () => _showProductDetailsSheet(context, p),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: p.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                            ),
                          ),
                        ),
                      ),
                      // Rating Badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                              const SizedBox(width: 2),
                              Text(
                                '${p.rating}',
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Wishlist heart button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Obx(
                          () {
                            final isWishlisted = controller.wishlist.contains(p.id);
                            return GestureDetector(
                              onTap: () => controller.toggleWishlist(p.id),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isWishlisted ? Colors.red : Colors.grey.shade500,
                                  size: 14,
                                )
                                    .animate(key: ValueKey(isWishlisted))
                                    .scale(duration: 250.ms, curve: Curves.easeOutBack),
                              ),
                            );
                          },
                        ),
                      ),
                      // Discount Badge
                      if (p.hasDiscount)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5A36),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${p.discountPercentage}% OFF',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.category,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 9, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () => _showProductDetailsSheet(context, p),
                        child: Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '৳${p.activePrice.toStringAsFixed(0)}',
                                style: const TextStyle(color: Color(0xFFFF5A36), fontWeight: FontWeight.w900, fontSize: 13),
                              ),
                              if (p.hasDiscount)
                                Text(
                                  '৳${p.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                    height: 1.0,
                                  ),
                                ),
                            ],
                          ),
                          // Plus Icon to add to Cart
                          GestureDetector(
                            onTap: () => controller.addToCart(p),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF5A36),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add_rounded, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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
// Tab 1: Categories Tab
// ═══════════════════════════════════════════════════════════════
class _CategoriesTab extends GetView<HomeController> {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context) {
    // Left side panel categories, right side subcategories/products
    final categoryList = controller.categories.where((cat) => cat['name'] != 'All').toList();
    final activeTabCategory = 'Groceries'.obs;

    return Row(
      children: [
        // Left Column: Category navigation sidebar
        Container(
          width: 90,
          color: const Color(0xFFF1F5F9),
          child: Obx(
            () {
              final selected = activeTabCategory.value;
              return ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, idx) {
                  final cat = categoryList[idx];
                  final name = cat['name']!;
                  final isSelected = selected == name;

                  return GestureDetector(
                    onTap: () {
                      activeTabCategory.value = name;
                    },
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        border: isSelected
                            ? const Border(
                                left: BorderSide(
                                  color: Color(0xFFFF5A36),
                                  width: 4,
                                ),
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat['icon']!, style: const TextStyle(fontSize: 22))
                              .animate(key: ValueKey(isSelected))
                              .scale(duration: 200.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? const Color(0xFFFF5A36) : const Color(0xFF64748B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Right Column: Products/Grid details
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Obx(() {
              final catName = activeTabCategory.value;
              final matchingProducts = controller.products.where((p) => p.category == catName).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$catName Collections',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.selectedCategory.value = catName;
                          controller.changeTab(0);
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(fontSize: 11, color: Color(0xFFFF5A36), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: matchingProducts.isEmpty
                        ? Center(
                            child: Text(
                              'No products in this category',
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                            ),
                          )
                        : GridView.builder(
                            itemCount: matchingProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.78,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, idx) {
                              final p = matchingProducts[idx];
                              return GestureDetector(
                                onTap: () => _showProductDetailsSheet(context, p),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: CachedNetworkImage(
                                            imageUrl: p.imageUrl,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(color: Colors.grey.shade100),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.title,
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '৳${p.activePrice.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFFFF5A36),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Tab 2: Cart Tab Layout
// ═══════════════════════════════════════════════════════════════
class _CartTab extends GetView<HomeController> {
  const _CartTab();

  @override
  Widget build(BuildContext context) {
    final promoInputController = TextEditingController();

    return Obx(() {
      if (controller.cart.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Color(0xFFFF5A36),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Shopping Cart is Empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find amazing products, exclusive coupons, and discounts.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.changeTab(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A36),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Start Shopping', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: [
          // List of Items
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: controller.cart.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final entry = controller.cart.entries.toList()[idx];
                final product = entry.key;
                final qty = entry.value;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.grey.shade100),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title & Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              product.category,
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '৳${product.activePrice.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFFF5A36), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      // Quantity selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => controller.removeFromCart(product),
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.updateQuantity(product, qty - 1),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Icon(Icons.remove, size: 14),
                                  ),
                                ),
                                Text(
                                  '$qty',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () => controller.updateQuantity(product, qty + 1),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Icon(Icons.add, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          // Coupon Code Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Obx(
              () => controller.appliedPromoCode.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFC8E6C9)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Coupon "${controller.appliedPromoCode.value}" Applied!',
                            style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => controller.removePromoCode(),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Remove', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: promoInputController,
                              decoration: InputDecoration(
                                hintText: 'Enter Promo Code (BAZAAR10 / EID50)',
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (promoInputController.text.isNotEmpty) {
                              final applied = controller.applyPromoCode(promoInputController.text);
                              if (applied) {
                                promoInputController.clear();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5A36),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Apply', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
            ),
          ),

          // Order Checkout Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    Text('৳${controller.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Delivery Fee', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          '(${controller.deliveryLocation.value})',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                        ),
                      ],
                    ),
                    Text('৳${controller.deliveryFee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                if (controller.promoDiscountAmount.value > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Coupon Discount', style: const TextStyle(color: Colors.green, fontSize: 12)),
                      Text('-৳${controller.promoDiscountAmount.value.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                    Text(
                      '৳${controller.total.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFFFF5A36)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _simulateCheckout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5A36),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }

  // Checkout Dialog simulation
  void _simulateCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.stars, color: Color(0xFFFF5A36)),
              SizedBox(width: 8),
              Text('Order Confirmed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56).animate().scale(duration: const Duration(milliseconds: 500)),
              const SizedBox(height: 16),
              const Text(
                'Thank you for your order!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Your order was placed successfully. Delivery partner will contact you shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  controller.clearCart();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A36),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Tab 3: Profile & Settings Tab Layout
// ═══════════════════════════════════════════════════════════════
class _ProfileTab extends GetView<HomeController> {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final languageEn = true.obs;
    final notificationsOn = true.obs;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Banner card profile info
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFFFF1EE),
                  child: const Text(
                    'SS',
                    style: TextStyle(color: Color(0xFFFF5A36), fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sourav Sanyal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  '+880 1712-345678 • sourav@example.com',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 16),

                // Quick stats dashboard
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Text('12', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            SizedBox(height: 2),
                            Text('My Orders', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(
                          () => Column(
                            children: [
                              Text('${controller.wishlist.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              const SizedBox(height: 2),
                              const Text('Wishlist', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Text('৳১৫০', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            SizedBox(height: 2),
                            Text('Refund Balance', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Menu list settings
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payment, color: Color(0xFFFF5A36), size: 20),
                  title: const Text('Saved Payment Methods', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('bKash, Nagad, Visa, Mastercard'),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 18),
                  onTap: () {
                    Get.snackbar('Payments', 'Payments dashboard coming soon.', snackPosition: SnackPosition.BOTTOM);
                  },
                ),
                const Divider(indent: 50, height: 1),
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFFFF5A36), size: 20),
                  title: const Text('Admin Panel Dashboard', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Manage catalog, stock & active orders'),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 18),
                  onTap: () {
                    Get.toNamed('/admin');
                  },
                ),
                const Divider(indent: 50, height: 1),
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.location_on_outlined, color: Color(0xFFFF5A36), size: 20),
                    title: const Text('Shipping Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text(controller.deliveryAddress.value),
                    trailing: const Icon(Icons.keyboard_arrow_right, size: 18),
                    onTap: () {
                      Get.snackbar('Shipping', 'Modify default address in location selector.', snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                ),
                const Divider(indent: 50, height: 1),
                // Toggle English/Bangla
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.language_rounded, color: Color(0xFFFF5A36), size: 20),
                    title: const Text('Language (ভাষা)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: Switch(
                      value: languageEn.value,
                      onChanged: (val) {
                        languageEn.value = val;
                        Get.snackbar('Language Changer', val ? 'Changed to English' : 'বাংলা সিলেক্ট করা হয়েছে', snackPosition: SnackPosition.BOTTOM);
                      },
                      activeThumbColor: const Color(0xFFFF5A36),
                    ),
                  ),
                ),
                const Divider(indent: 50, height: 1),
                // Toggle notifications
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFFFF5A36), size: 20),
                    title: const Text('Push Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: Switch(
                      value: notificationsOn.value,
                      onChanged: (val) {
                        notificationsOn.value = val;
                      },
                      activeThumbColor: const Color(0xFFFF5A36),
                    ),
                  ),
                ),
                const Divider(indent: 50, height: 1),
                ListTile(
                  leading: const Icon(Icons.support_agent_rounded, color: Color(0xFFFF5A36), size: 20),
                  title: const Text('Help Center & Support', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Call: 16244 • Email: support@bazaarbd.com'),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 18),
                  onTap: () {
                    Get.snackbar('Support', 'Initiating live chat support...', snackPosition: SnackPosition.BOTTOM);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('App Version 1.0.0 (BazaarBD)', style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Details Modal Bottom Sheet
// ═══════════════════════════════════════════════════════════════
void _showProductDetailsSheet(BuildContext context, Product p) {
  final controller = Get.find<HomeController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header drag handle & Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: CachedNetworkImage(
                        imageUrl: p.imageUrl,
                        width: double.infinity,
                        height: 280,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey.shade100),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag & Category
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1EE),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              p.category.toUpperCase(),
                              style: const TextStyle(color: Color(0xFFFF5A36), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                          const Spacer(),
                          // Star rating
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            '${p.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${p.reviews} reviews)',
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Title
                      Text(
                        p.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 10),

                      // Prices
                      Row(
                        children: [
                          Text(
                            '৳${p.activePrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFFF5A36)),
                          ),
                          if (p.hasDiscount) ...[
                            const SizedBox(width: 8),
                            Text(
                              '৳${p.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${p.discountPercentage}% OFF',
                                style: const TextStyle(color: Color(0xFFFF5A36), fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Stock status
                      Row(
                        children: [
                          Icon(
                            p.stock > 10 ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
                            color: p.stock > 10 ? Colors.green : Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            p.stock > 10 ? 'In Stock (${p.stock} units)' : 'Only ${p.stock} units left in stock!',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: p.stock > 10 ? Colors.green : Colors.amber.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'Product Details',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // Bottom purchase section
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.addToCart(p);
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFFF5A36)),
                                  foregroundColor: const Color(0xFFFF5A36),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.addToCart(p);
                                  Navigator.pop(context);
                                  controller.changeTab(2); // Go to Cart
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5A36),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
