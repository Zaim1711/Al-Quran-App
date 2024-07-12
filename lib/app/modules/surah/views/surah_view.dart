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
  String selectedQari = "01";

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
            icon: const Icon(Icons.search),
            color: appWhite,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
              GetBuilder<SurahController>(
                builder: (c) => FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
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
                                      "Loading...",
                                      style: TextStyle(
                                        color: appWhite,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "",
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
                      );
                    }

                    Map<String, dynamic>? lastRead = snapshot.data;

                    return Container(
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
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                  title: "Hapus Terakhir dibaca",
                                  middleText:
                                      "Apakah anda yakin untuk menghapus?",
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () => Get.back(),
                                      child: Text("CANCEL"),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          c.deleteBookmark(lastRead['id']);
                                        },
                                        child: Text("DELETE"))
                                  ]);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (lastRead != null) {
                              //diarahkan ke page last read
                              Get.toNamed(
                                Routes.DETAIL_SURAH,
                                arguments: {
                                  "name": lastRead["surah"]
                                      .toString()
                                      .replaceAll("+", "'"),
                                  "surahNumber": lastRead["number_surah"],
                                  "bookmark": lastRead
                                },
                              );
                            }
                          },
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
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
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
                                      const SizedBox(height: 30),
                                      if (lastRead != null)
                                        Text(
                                          "${lastRead['surah'].toString().replaceAll("+", "'")}",
                                          style: const TextStyle(
                                            color: appWhite,
                                            fontSize: 20,
                                          ),
                                        ),
                                      Text(
                                        lastRead == null
                                            ? "Belum ada"
                                            : "Ayat ${lastRead['ayat']}",
                                        style: const TextStyle(
                                          color: appWhite,
                                          fontSize: 16,
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
                    );
                  },
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
                        List<Surah> surahs = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Qori', // Teks di atas dropdown
                                      style: TextStyle(
                                        color: controller.isDark.isTrue
                                            ? appWhite
                                            : appGreenDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ), // Spasi antara teks dan dropdown
                                    InputDecorator(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[
                                            200], // Warna latar belakang sesuai mode tema
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        suffixIcon: Icon(
                                          Icons.arrow_drop_down,
                                          color: controller.isDark.isTrue
                                              ? appGreenDark
                                              : Colors.black,
                                        ), // Icon dropdown
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedQari,
                                          items: const [
                                            DropdownMenuItem(
                                              child: Text("Abdullah Al-Juhany"),
                                              value: "01",
                                            ),
                                            DropdownMenuItem(
                                              child:
                                                  Text("Abdul-Muhsin Al-Qasim"),
                                              value: "02",
                                            ),
                                            DropdownMenuItem(
                                              child:
                                                  Text("Abdurrahman As-Sudais"),
                                              value: "03",
                                            ),
                                            DropdownMenuItem(
                                              child: Text("Ibrahim Al-Dossari"),
                                              value: "04",
                                            ),
                                            DropdownMenuItem(
                                              child: Text(
                                                  "Misyari Rasyid Al-Afasi"),
                                              value: "05",
                                            ),
                                          ],
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              if (newValue == null) {
                                                // Tampilkan Snackbar jika qori tidak dipilih
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Silakan pilih qori terlebih dahulu'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              } else {
                                                // Stop audio untuk semua surah yang sedang diputar sebelum mengubah qori
                                                surahs.forEach((surah) {
                                                  controller.stopAudio(
                                                      surah, selectedQari);
                                                });
                                                selectedQari =
                                                    newValue; // Handle null case
                                              }
                                            });
                                          },
                                          style: TextStyle(
                                            color: appGreenDark,
                                          ),
                                          dropdownColor:
                                              appWhite, // Warna dropdown sesuai mode tema
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          isExpanded: true,
                                          icon: const Icon(
                                              null), // Menggunakan isExpanded agar DropdownButton memenuhi lebar yang tersedia
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: surahs.length,
                                itemBuilder: (context, index) {
                                  Surah surah = surahs[index];

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
                                      id: 'audioState',
                                      builder: (c) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (surah.kondisiAudio == "stop")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.playAudio(
                                                        surah, selectedQari);
                                                  },
                                                  icon: Icon(Icons.play_arrow),
                                                )
                                              : Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    (surah.kondisiAudio ==
                                                            "playing")
                                                        ? IconButton(
                                                            onPressed: () {
                                                              c.pauseAudio(
                                                                  surah,
                                                                  selectedQari);
                                                            },
                                                            icon: Icon(
                                                                Icons.pause),
                                                          )
                                                        : IconButton(
                                                            onPressed: () {
                                                              c.resumeAudio(
                                                                  surah,
                                                                  selectedQari);
                                                            },
                                                            icon: Icon(Icons
                                                                .play_arrow),
                                                          ),
                                                    IconButton(
                                                      onPressed: () {
                                                        c.stopAudio(surah,
                                                            selectedQari);
                                                      },
                                                      icon: Icon(Icons.stop),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    GetBuilder<SurahController>(builder: (c) {
                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: controller.getBookmark(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data?.length == 0) {
                            return const Center(
                              child: Text("Bookmark tidak tersedia"),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.DETAIL_SURAH,
                                    arguments: {
                                      "name": data["surah"]
                                          .toString()
                                          .replaceAll("+", "'"),
                                      "surahNumber": data["number_surah"],
                                      "bookmark": data
                                    },
                                  );
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
                                        "${index + 1}",
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                    "${data['surah'].toString().replaceAll("+", "'")}"),
                                subtitle: Text(
                                  "Ayat ${data['ayat']}",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    c.deleteBookmark(data['id']);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
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
