import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/data/db/bookmark.dart';
import 'package:test_cli/app/data/model/detailSurah.dart';

class DetailSurahController extends GetxController {
  var surahDetails = Rxn<DetailSurah>();

  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
      bool lastRead, DetailSurah surah, Ayat ayat, int indexAyat) async {
    Database db = await database.db;

    bool flagExist = false;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query(
        "bookmark",
        columns: ["surah", "ayat", "index_ayat", "last_read"],
        where:
            "surah= '${surah.namaLatin?.replaceAll("'", "+")}' and ayat = ${ayat.nomorAyat} and index_ayat = $indexAyat and last_read = 0",
      );
      if (checkData.length != 0) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert("bookmark", {
        "surah": "${surah.namaLatin?.replaceAll("'", "+")}",
        "ayat": "${ayat.nomorAyat}",
        "index_ayat": indexAyat,
        "last_read": lastRead == true ? 1 : 0,
      });

      Get.back();
      update();
      Get.snackbar("Berhasil", "Berhasil menambahkan bookmark",
          colorText: appWhite);
    } else {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Bookmark telah tersedia",
          colorText: appWhite);
    }

    var data = await db.query("bookmark");
    print(data);
  }

  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    int surahNumber = args['surahNumber'];
    getAllDetailSurah(surahNumber);
    print(surahNumber);
  }

  Future<void> getAllDetailSurah(int surahNumber) async {
    try {
      Uri urlSurah = Uri.parse("https://equran.id/api/v2/surat/$surahNumber");
      var responseSurah = await http.get(urlSurah);

      if (responseSurah.statusCode == 200) {
        Map<String, dynamic> dataSurah =
            json.decode(responseSurah.body)["data"];
        surahDetails.value = DetailSurah.fromJson(dataSurah);
      } else {
        print("Gagal mengambil informasi surah: ${responseSurah.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Ayat? lastAyat;
  final AudioPlayer player = AudioPlayer();

  void playAudio(Ayat? ayat) async {
    if (ayat?.audio != null && ayat!.audio!.isNotEmpty) {
      try {
        lastAyat ??= ayat;
        lastAyat!.kondisiAudio = "stop";
        lastAyat = ayat;
        lastAyat!.kondisiAudio = "stop";
        update();
        await player.stop();
        String audioUrl = ayat.audio!.values.first;
        update();
        await player.setUrl(audioUrl);
        ayat.kondisiAudio = "playing";
        update();
        await player.play();
        ayat.kondisiAudio = "stop";
        update();
      } on PlayerException catch (e) {
        Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: e.message.toString(),
        );
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Connection aborted: ${e.message}",
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi kesalahan",
          middleText: "Tidak dapat memutar Audio",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "URL Audio tidak ada / tidak dapat diakses",
      );
    }
  }

  void pauseAudio(Ayat? ayat) async {
    try {
      await player.pause();
      update();
      ayat!.kondisiAudio = "paused";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak dapat pause Audio",
      );
    }
  }

  void resumeAudio(Ayat? ayat) async {
    try {
      ayat!.kondisiAudio = "playing";
      update();
      await player.play();
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak dapat pause Audio",
      );
    }
  }

  void stopAudio(Ayat? ayat) async {
    await player.stop();
    update();
    ayat!.kondisiAudio = "stop";
    update();
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
