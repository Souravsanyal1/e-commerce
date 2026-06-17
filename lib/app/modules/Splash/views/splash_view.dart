import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashController controller = Get.find<SplashController>();
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _dotPressed(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _continuePressed() {
    final nextPage = controller.currentPage.value + 1;

    if (nextPage < controller.splashData.length) {
      _dotPressed(nextPage);
      return;
    }

    controller.finishSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FC),
      body: Stack(
        children: [
          const _AnimatedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final imageHeight = (constraints.maxHeight * 0.38)
                      .clamp(230.0, 310.0)
                      .toDouble();

                  return Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: controller.changePage,
                          itemCount: controller.splashData.length,
                          itemBuilder: (context, index) {
                            final splash = controller.splashData[index];

                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                var delta = 0.0;

                                if (_pageController.hasClients &&
                                    _pageController.position.haveDimensions) {
                                  delta = _pageController.page! - index;
                                }

                                final distance = delta.abs().clamp(0.0, 1.0);

                                return Opacity(
                                  opacity: 1 - (distance * 0.35),
                                  child: Transform.translate(
                                    offset: Offset(delta * -24, 0),
                                    child: Transform.scale(
                                      scale: 1 - (distance * 0.06),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: SplashContent(
                                image: splash['image']!,
                                imageHeight: imageHeight,
                                text: splash['text']!,
                              ),
                            );
                          },
                        ),
                      ),
                      SmoothPageIndicator(
                            controller: _pageController,
                            count: controller.splashData.length,
                            onDotClicked: _dotPressed,
                            effect: const ExpandingDotsEffect(
                              activeDotColor: Color(0xFFFF7643),
                              dotColor: Color(0xFFD8D8D8),
                              dotHeight: 6,
                              dotWidth: 6,
                              expansionFactor: 3.2,
                              spacing: 5,
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 450.ms, duration: 450.ms)
                          .slideY(begin: 0.4, end: 0),
                      const SizedBox(height: 32),
                      _ContinueButton(onPressed: _continuePressed),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    required this.text,
    required this.image,
    required this.imageHeight,
  });

  final String text;
  final String image;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Text(
          'E-commerce Demo',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            color: Color(0xFFFF7643),
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.35, end: 0),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700, height: 1.4),
        ).animate().fadeIn(delay: 120.ms, duration: 450.ms),
        const SizedBox(height: 56),
        CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.contain,
              height: imageHeight,
              width: double.infinity,
              placeholder: (context, url) => SizedBox(
                height: imageHeight,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF7643),
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => SizedBox(
                height: imageHeight,
                child: const Center(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFFFF7643),
                    size: 96,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 220.ms, duration: 650.ms)
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              curve: Curves.easeOutBack,
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              begin: 0,
              end: -10,
              duration: 1300.ms,
              curve: Curves.easeInOut,
            ),
        const Spacer(),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFFFF7643),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        )
        .animate()
        .fadeIn(delay: 550.ms, duration: 450.ms)
        .slideY(begin: 0.45, end: 0, curve: Curves.easeOutCubic)
        .shimmer(delay: 1200.ms, duration: 1200.ms, color: Colors.white24);
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Column(
          children: [
            Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFEFE7), Color(0x00FFF7FC)],
                    ),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fade(begin: 0.55, end: 1, duration: 2200.ms),
            const Spacer(),
            Container(
                  height: 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFFFFEFE7), Color(0x00FFF7FC)],
                    ),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fade(begin: 0.35, end: 0.75, duration: 2600.ms),
          ],
        ),
      ),
    );
  }
}
