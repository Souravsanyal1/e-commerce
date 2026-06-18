import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Obx(
                        () => AnimatedOpacity(
                          opacity: controller.isLogoVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF5A36), Color(0xFFFF8A65)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5A36).withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              size: 52,
                              color: Colors.white,
                            )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.15, 1.15), duration: 1000.ms, curve: Curves.easeInOut)
                                .shimmer(delay: 500.ms, duration: 1500.ms),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // App name
                      Obx(
                        () => AnimatedOpacity(
                          opacity: controller.isTextVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 700),
                          child: const Text(
                            'BazaarBD',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Tagline
                      Obx(
                        () => AnimatedOpacity(
                          opacity: controller.isTaglineVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Your Premium Shopping Destination',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Loading indicator
                      Obx(
                        () => AnimatedOpacity(
                          opacity: controller.isLoaderVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Color(0xFFFF5A36),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
