import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_cli/app/data/model/tafsir.dart';
import 'package:test_cli/app/modules/tafsir/controllers/tafsir_controller.dart';

class TafsirView extends GetView<TafsirController> {
  @override
  Widget build(BuildContext context) {
    // Menerima nomor surah dari arguments
    int surahId =
        Get.arguments['surahNumber'] ?? 1; // Default to surah 1 if not provided
    controller.fetchSurahDetails(surahId);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (controller.isLoading.value) {
            return const Text('Loading...');
          }
          return Text(controller.tafsir.value?.namaLatin ?? 'Detail Surah');
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Tafsirfull? surah = controller.tafsir.value;
        if (surah == null) {
          return const Center(child: Text('No Data Available'));
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "${surah.namaLatin} (${surah.nama})",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              surah.arti,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Text(surah.deskripsi, textAlign: TextAlign.justify),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: surah.tafsir.length,
              itemBuilder: (context, index) {
                Tafsir tafsir = surah.tafsir[index];
                return Card(
                  child: ListTile(
                    title: Text("Ayat ${tafsir.ayat}"),
                    subtitle: Text(tafsir.teks, textAlign: TextAlign.justify),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}