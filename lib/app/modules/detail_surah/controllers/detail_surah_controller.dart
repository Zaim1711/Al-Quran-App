import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:test_cli/app/data/model/detailSurah.dart';

class DetailSurahController extends GetxController {
  var surahDetails = Rxn<DetailSurah>();

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
