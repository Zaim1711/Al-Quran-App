import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/data/model/surah.dart';
import 'package:test_cli/app/modules/search_surah/controllers/search_surah_controller.dart';
import 'package:test_cli/app/routes/app_pages.dart';

class SearchSurahView extends StatefulWidget {
  @override
  _SearchSurahViewState createState() => _SearchSurahViewState();
}

class _SearchSurahViewState extends State<SearchSurahView> {
  final SearchSurahController controller = Get.find();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SURAH',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appWhite,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: appWhite,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  hintText: 'Cari Nama Surah...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  filterSurah(value);
                },
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (filteredSurah.isEmpty) {
          return const Center(
            child: Text("Tidak ada data"),
          );
        }
        return ListView.builder(
          itemCount: filteredSurah.length,
          itemBuilder: (context, index) {
            Surah surah = filteredSurah[index];
            return Card(
              color: controller.isDark.value ? Colors.grey[800] : Colors.white,
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                onTap: () async {
                  controller.isLoading(true);
                  await Get.toNamed(
                    Routes.DETAIL_SURAH,
                    arguments: {'surahNumber': surah.nomor},
                  );
                  controller.isLoading(false);
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: controller.isDark.isTrue
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  "${surah.namaLatin ?? 'Error..'}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        controller.isDark.value ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  "${surah.arti ?? 'Error..'} - ${surah.jumlahAyat ?? 'Error..'} Ayat ",
                  style: TextStyle(
                    color: controller.isDark.value
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
                trailing: Text(
                  "${surah.nama ?? 'Error..'}",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: controller.isDark.value
                        ? Colors.grey[400]
                        : Colors.grey[700],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
