import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:test_cli/app/data/model/surah.dart';

class SearchSurahController extends GetxController {
  RxBool isDark = false.obs;
  var isLoading = false.obs;

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse("https://equran.id/api/v2/surat");
    var res = await http.get(url);

    List data = (json.decode(res.body) as Map<String, dynamic>)["data"];
    if (data.isEmpty) {
      return [];
    } else {
      return data.map((e) => Surah.fromJson(e)).toList();
    }
  }
}
