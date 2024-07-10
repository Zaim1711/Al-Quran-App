import 'package:get/get.dart';

import '../controllers/search_surah_controller.dart';

class SearchSurahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchSurahController>(
      () => SearchSurahController(),
    );
  }
}
