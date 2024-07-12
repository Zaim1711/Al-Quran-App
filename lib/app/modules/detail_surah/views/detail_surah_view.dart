import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/data/model/detailSurah.dart'; // Adjust path as per your project structure
import 'package:test_cli/app/modules/surah/controllers/surah_controller.dart';
import 'package:test_cli/app/routes/app_pages.dart';

import '../controllers/detail_surah_controller.dart'; // Adjust path as per your project structure

class DetailSurahView extends GetView<DetailSurahController> {
  final SurahC = Get.find<SurahController>();
  Map<String, dynamic>? bookmark;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (controller.surahDetails.value == null) {
            return const Text('');
          }
          return Text(
            "SURAH ${controller.surahDetails.value!.namaLatin!.toString().toUpperCase()}",
            style: TextStyle(
              color: Colors.white,
            ),
          );
        }),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: appWhite,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (controller.surahDetails.value == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (Get.arguments["bookmark"] != null) {
          bookmark = Get.arguments["bookmark"];
          print("INDEX AYAT : ${bookmark!["index_ayat"] + 2}");
          controller.scrollC.scrollToIndex(
            bookmark!["index_ayat"] + 2,
            preferPosition: AutoScrollPosition.begin,
          );
        }
        print(bookmark);

        DetailSurah surah = controller.surahDetails.value!;

        List<Widget> allAyat = List.generate(surah.ayat?.length ?? 0, (index) {
          final Ayat? ayat = surah.ayat![index];
          final ayatNumber = ayat!.nomorAyat! + 0;

          return AutoScrollTag(
            key: ValueKey(index + 2),
            index: index + 2,
            controller: controller.scrollC,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appGreenLight.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Get.isDarkMode
                                  ? "assets/images/octagonwhite_list.png"
                                  : "assets/images/octagon_list.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "${ayatNumber}",
                            ),
                          ),
                        ),
                        GetBuilder<DetailSurahController>(
                          builder: (c) => Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "BOOKMARK",
                                    middleText: "Pilih jenis bookmark",
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await c.addBookmark(
                                              true, surah, ayat, index);
                                          SurahC.update();
                                        },
                                        child: Text(
                                          "Last Read",
                                          style: TextStyle(color: appWhite),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: appGreen),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          c.addBookmark(
                                              false, surah, ayat, index);
                                        },
                                        child: Text(
                                          "Bookmark",
                                          style: TextStyle(color: appWhite),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: appGreen),
                                      )
                                    ],
                                  );
                                },
                                icon: const Icon(Icons.bookmark_add_outlined),
                              ),
                              (ayat.kondisiAudio == "stop")
                                  ? IconButton(
                                      onPressed: () {
                                        c.playAudio(ayat);
                                      },
                                      icon: const Icon(Icons.play_arrow),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (ayat.kondisiAudio == "playing")
                                            ? IconButton(
                                                onPressed: () {
                                                  c.pauseAudio(ayat);
                                                },
                                                icon: const Icon(Icons.pause),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  c.resumeAudio(ayat);
                                                },
                                                icon: const Icon(
                                                    Icons.play_arrow),
                                              ),
                                        IconButton(
                                          onPressed: () {
                                            c.stopAudio(ayat);
                                          },
                                          icon: const Icon(Icons.stop),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  ayat.teksArab!,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ayat.teksLatin!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  ayat.teksIndonesia!,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        });

        return Scrollbar(
          thumbVisibility: true, // Tampilkan scrollbar selalu
          controller:
              _scrollController, // Gunakan ScrollController yang disediakan
          child: ListView(
            controller:
                _scrollController, // Gunakan ScrollController yang disediakan
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.TAFSIR,
                      arguments: {'surahNumber': surah.nomor});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                        colors: [appGreenLight, appGreenDark]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${surah.namaLatin?.toUpperCase() ?? 'Error...'} - ${surah.nama?.toUpperCase() ?? 'Error..'}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: appWhite),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${surah.arti ?? 'Error..'} | ${surah.jumlahAyat ?? 'Error..'} Ayat | ${surah.tempatTurun}",
                            style:
                                const TextStyle(fontSize: 16, color: appWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...allAyat,
            ],
          ),
        );
      }),
    );
  }
}
