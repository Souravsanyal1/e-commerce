import 'package:get/get.dart';

class SplashController extends GetxController {
  final isLogoVisible = false.obs;
  final isTextVisible = false.obs;
  final isTaglineVisible = false.obs;
  final isLoaderVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    isLogoVisible.value = true;

    await Future.delayed(const Duration(milliseconds: 500));
    isTextVisible.value = true;

    await Future.delayed(const Duration(milliseconds: 400));
    isTaglineVisible.value = true;

    await Future.delayed(const Duration(milliseconds: 300));
    isLoaderVisible.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));
    _navigateToHome();
  }

  void _navigateToHome() {
    Get.offNamed('/home');
  }
}
