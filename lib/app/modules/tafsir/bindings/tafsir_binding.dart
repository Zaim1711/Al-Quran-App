import 'package:get/get.dart';

import '../controllers/tafsir_controller.dart';

class TafsirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TafsirController>(
      () => TafsirController(),
    );
  }
}
