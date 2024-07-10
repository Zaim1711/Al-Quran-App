import 'package:get/get.dart';
import 'package:test_cli/app/routes/app_pages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  RxInt currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed(Routes.SURAH); // Navigate to SurahView
        break;
      case 1:
        Get.toNamed(Routes.INTRODUCTION); // Navigate to ProfilePage
        break;
      case 2:
        Get.offAllNamed(Routes.HOME); // Navigate to HomeView
        break;
      default:
        break;
    }
  }
}

class PROFILE {}
