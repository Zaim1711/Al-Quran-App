import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/data/model/surah.dart';
import 'package:test_cli/app/routes/app_pages.dart';

import '../controllers/surah_controller.dart';

class SurahView extends StatefulWidget {
  @override
  _SurahViewState createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  final SurahController controller = Get.find();
  final TextEditingController searchController = TextEditingController();
  List<Surah> allSurah = [];
  List<Surah> filteredSurah = [];

  @override
  void initState() {
    super.initState();
    controller.getAllSurah().then((surahList) {
      setState(() {
        allSurah = surahList;
        filteredSurah = surahList;
      });
    });
  }

  void filterSurah(String query) {
    List<Surah> filteredList = allSurah.where((surah) {
      return surah.namaLatin!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSurah = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: Get.isDarkMode ? 0 : 4,
        title: const Text(
          'Al-Quran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appWhite,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.SEARCH_SURAH),
            icon: Icon(Icons.search),
            color: appWhite,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Assalamu'allaikum",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      appGreenLight,
                      appGreenDark,
                    ],
                  ),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Get.toNamed(Routes.LAST_READ),
                    child: SizedBox(
                      width: Get.width,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -5,
                            right: 0,
                            child: Opacity(
                              opacity: 0.9,
                              child: SizedBox(
                                width: 150,
                                height: 155,
                                child: Image.asset(
                                  "assets/images/Alquran_images.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book_rounded,
                                      color: appWhite,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Terakhir dibaca",
                                      style: TextStyle(color: appWhite),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "Al-Fatihah",
                                  style: TextStyle(
                                    color: appWhite,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Juz 1 | Ayat 5",
                                  style: TextStyle(
                                    color: appWhite,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Murottal",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak ada data"),
                          );
                        }
                        return ListView.builder(
                          itemCount: filteredSurah.length,
                          itemBuilder: (context, index) {
                            Surah surah = filteredSurah[index];
                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_SURAH,
                                    arguments: {'surahNumber': surah.nomor});
                              },
                              leading: Obx(
                                () => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        controller.isDark.isTrue
                                            ? "assets/images/octagonwhite_list.png"
                                            : "assets/images/octagon_list.png",
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${surah.nomor ?? 'Error..'}",
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                "${surah.namaLatin ?? 'Error..'}",
                              ),
                              subtitle: Text(
                                "${surah.arti ?? 'Error..'} - ${surah.jumlahAyat ?? 'Error..'} Ayat ",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              trailing: Text(
                                "${surah.nama ?? 'Error..'}",
                              ),
                            );
                          },
                        );
                      },
                    ),
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak ada data"),
                          );
                        }
                        return ListView.builder(
                          itemCount: filteredSurah.length,
                          itemBuilder: (context, index) {
                            Surah surah = filteredSurah[index];
                            return ListTile(
                              leading: Obx(
                                () => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        controller.isDark.isTrue
                                            ? "assets/images/octagonwhite_list.png"
                                            : "assets/images/octagon_list.png",
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${surah.nomor ?? 'Error..'}",
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                "${surah.namaLatin ?? 'Error..'}",
                              ),
                              subtitle: Text(
                                "${surah.arti ?? 'Error..'} - ${surah.jumlahAyat ?? 'Error..'} Ayat ",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              trailing: GetBuilder<SurahController>(
                                id: 'audioState', // Specific update id
                                builder: (c) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (surah.kondisiAudio == "stop")
                                        ? IconButton(
                                            onPressed: () {
                                              c.playAudio(surah);
                                            },
                                            icon: const Icon(Icons.play_arrow),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (surah.kondisiAudio == "playing")
                                                  ? IconButton(
                                                      onPressed: () {
                                                        c.pauseAudio(surah);
                                                      },
                                                      icon: const Icon(
                                                          Icons.pause),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        c.resumeAudio(surah);
                                                      },
                                                      icon: const Icon(
                                                          Icons.play_arrow),
                                                    ),
                                              IconButton(
                                                onPressed: () {
                                                  c.stopAudio(surah);
                                                },
                                                icon: const Icon(Icons.stop),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    GetBuilder<SurahController>(builder: (c) {
                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: controller.getBookmark(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data?.length == 0) {
                            return Center(
                              child: Text("Bookmark tidak tersedia"),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  print(data);
                                },
                                leading: CircleAvatar(
                                  child: Text("${index + 1}"),
                                ),
                                title: Text("${data['surah']}"),
                                subtitle: Text("Ayat ${data['ayat']}"),
                              );
                            },
                          );
                        },
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.changeThemeMode(),
        child: Obx(
          () => Icon(
            Icons.color_lens,
            color: controller.isDark.isTrue ? appGreenDark : appWhite,
          ),
        ),
      ),
    );
  }
}
