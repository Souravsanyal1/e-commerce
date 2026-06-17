import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [const ListTile(title: Text('Demo e-commerce'))],
        ),
      ),
      appBar: AppBar(title: const Text('Demo e-commerce'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offNamed('/splash');
        },
      ),
    );
  }
}
