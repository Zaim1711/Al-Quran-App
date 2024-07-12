import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:test_cli/app/data/model/tafsir.dart';

class TafsirController extends GetxController {
  var tafsir = Rxn<Tafsirfull>(); // Updated to Rxn<Data>
  RxBool isDark = false.obs;
  var isLoading = false.obs;

  Future<void> fetchSurahDetails(int id) async {
    isLoading.value = true;
    Uri url = Uri.parse("https://equran.id/api/v2/tafsir/$id");
    try {
      var res = await http.get(url);

      if (res.statusCode == 200) {
        var data = json.decode(res.body)['data'];
        tafsir.value = Tafsirfull.fromJson(data);
      } else {
        Get.snackbar("Error", "Failed to fetch data");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Failed to connect to the server");
    } finally {
      isLoading.value = false;
    }
  }
}
