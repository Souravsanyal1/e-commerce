import 'package:get/get.dart';

class SplashController extends GetxController {
  final currentPage = 0.obs;

  final splashData = const [
    {
      'text': 'Welcome to E-commerce Demo, Let\'s shop!',
      'image': 'https://i.postimg.cc/mhhVywp9/splash-1.png',
    },
    {
      'text':
          'We help people connect with store \naround United State of America',
      'image': 'https://i.postimg.cc/PNcy3w0R/splash-2.png',
    },
    {
      'text': 'We show the easy way to shop. \nJust stay at home with us',
      'image': 'https://i.postimg.cc/wRtVxqR2/splash-3.png',
    },
  ];

  void changePage(int index) {
    currentPage.value = index;
  }

  void finishSplash() {
    Get.offNamed('/home');
  }
}
