import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/data/db/bookmark.dart';
import 'package:test_cli/app/data/model/detailSurah.dart';
import 'package:test_cli/app/data/model/surah.dart';
import 'package:test_cli/app/routes/app_pages.dart';

class SurahController extends GetxController {
  RxBool isDark = false.obs;

  DatabaseManager database = DatabaseManager.instance;

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allbookmark = await db.query(
      "bookmark",
      where: "last_read = 0",
    );
    return allbookmark;
  }

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(appLight) : Get.changeTheme(appDark);
    isDark.toggle();

    final box = GetStorage();

    if (Get.isDarkMode) {
      //dark -> light
      box.remove("appDark");
    } else {
      box.write("appDark", true);
    }
  }

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

  var surahDetails = Rxn<DetailSurah>();

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

  final AudioPlayer player = AudioPlayer();
  Surah? lastAyat;

  void playAudio(Surah? surah) async {
    if (surah?.audioFull != null && surah!.audioFull!.isNotEmpty) {
      try {
        lastAyat ??= surah;
        lastAyat!.kondisiAudio = "stop";
        lastAyat = surah;
        lastAyat!.kondisiAudio = "stop";
        await player.stop();
        String audioUrl = surah.audioFull!.values.first;
        await player.setUrl(audioUrl);
        surah.kondisiAudio = "playing";
        update(['audioState']); // Specific update id
        await player.play();
        surah.kondisiAudio = "stop";
        await player.stop();
        update(['audioState']); // Specific update id
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Tidak dapat memutar Audio: ${e.toString()}",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "URL Audio tidak ada / tidak dapat diakses",
      );
    }
  }

  void pauseAudio(Surah? surah) async {
    if (surah != null) {
      try {
        await player.pause();
        surah.kondisiAudio = "paused";
        update(['audioState']); // Specific update id
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Tidak dapat pause Audio: ${e.toString()}",
        );
      }
    }
  }

  void resumeAudio(Surah? surah) async {
    if (surah != null) {
      try {
        surah.kondisiAudio = "playing";
        update(['audioState']);
        await player.play();
        update(['audioState']); // Specific update id
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Tidak dapat melanjutkan Audio: ${e.toString()}",
        );
      }
    }
  }

  void stopAudio(Surah? surah) async {
    if (surah != null) {
      await player.stop();
      surah.kondisiAudio = "stop";
      update(['audioState']); // Specific update id
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
