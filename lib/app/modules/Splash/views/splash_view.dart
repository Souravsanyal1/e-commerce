import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating particles
            const _FloatingParticles(),

            // Glowing orb top-right
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF7643).withValues(alpha: 0.3),
                      const Color(0xFFFF7643).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              )
                  .animate(
                    onPlay: (c) => c.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.2, 1.2),
                    duration: 3000.ms,
                    curve: Curves.easeInOut,
                  ),
            ),

            // Glowing orb bottom-left
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE94560).withValues(alpha: 0.25),
                      const Color(0xFFE94560).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              )
                  .animate(
                    onPlay: (c) => c.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.3, 1.3),
                    duration: 3500.ms,
                    curve: Curves.easeInOut,
                  ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo container with glow
                    Obx(() => AnimatedOpacity(
                          opacity: controller.isLogoVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOut,
                          child: AnimatedSlide(
                            offset: controller.isLogoVisible.value
                                ? Offset.zero
                                : const Offset(0, 0.3),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF7643)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFFF7643)
                                        .withValues(alpha: 0.15),
                                    blurRadius: 80,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/images/ic_launcher_foreground.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )),

                    const SizedBox(height: 32),

                    // App name
                    Obx(() => AnimatedOpacity(
                          opacity: controller.isTextVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOut,
                          child: AnimatedSlide(
                            offset: controller.isTextVisible.value
                                ? Offset.zero
                                : const Offset(0, 0.5),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOutCubic,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFFF7643),
                                  Color(0xFFFF9A76),
                                  Color(0xFFFFD3B6),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'ShopVibe',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ),
                        )),

                    const SizedBox(height: 12),

                    // Tagline
                    Obx(() => AnimatedOpacity(
                          opacity:
                              controller.isTaglineVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          child: AnimatedSlide(
                            offset: controller.isTaglineVisible.value
                                ? Offset.zero
                                : const Offset(0, 0.5),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            child: Text(
                              'Your Style, Delivered',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.6),
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        )),

                    const SizedBox(height: 60),

                    // Loading indicator
                    Obx(() => AnimatedOpacity(
                          opacity: controller.isLoaderVisible.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            width: 160,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                minHeight: 3,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.1),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF7643),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Floating particles background animation
class _FloatingParticles extends StatefulWidget {
  const _FloatingParticles();

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final random = math.Random(42);
    _particles = List.generate(20, (_) {
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: random.nextDouble() * 2.5 + 0.5,
        speed: random.nextDouble() * 0.3 + 0.1,
        opacity: random.nextDouble() * 0.3 + 0.05,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final yOffset = (p.y + progress * p.speed) % 1.0;
      final xWobble =
          math.sin((progress + p.x) * math.pi * 2) * 0.02 + p.x;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: p.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 1.5);

      canvas.drawCircle(
        Offset(xWobble * size.width, (1 - yOffset) * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
