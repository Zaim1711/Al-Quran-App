import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_cli/app/component/bottom_navigator.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HomeView',
          style: TextStyle(
            color: appWhite,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HomeView Testing',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.SURAH),
              child: const Text("Baca Al-Quran"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: controller
            .currentIndex, // Assuming currentIndex is managed in HomeController
        onTap: controller.changeTabIndex,
      ),
    );
  }
}
