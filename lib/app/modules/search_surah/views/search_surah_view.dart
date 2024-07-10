import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_cli/app/data/model/surah.dart';
import 'package:test_cli/app/modules/search_surah/controllers/search_surah_controller.dart';
import 'package:test_cli/app/routes/app_pages.dart';

class SearchSurahView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchSurahView> {
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
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari Nama Surah...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterSurah(value);
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: LinearProgressIndicator(),
          );
        }
        if (filteredSurah.isEmpty) {
          return Center(
            child: Text("Tidak ada data"),
          );
        }
        return ListView.builder(
          itemCount: filteredSurah.length,
          itemBuilder: (context, index) {
            Surah surah = filteredSurah[index];
            return ListTile(
              onTap: () async {
                controller.isLoading(true);
                await Get.toNamed(
                  Routes.DETAIL_SURAH,
                  arguments: {'surahNumber': surah.nomor},
                );
                controller.isLoading(false);
              },
              leading: CircleAvatar(
                child: Text("${surah.nomor ?? 'Error..'}"),
              ),
              title: Text("${surah.namaLatin ?? 'Error..'}"),
              subtitle: Text(
                "${surah.arti ?? 'Error..'} - ${surah.jumlahAyat ?? 'Error..'} Ayat ",
              ),
              trailing: Text("${surah.nama ?? 'Error..'}"),
            );
          },
        );
      }),
    );
  }
}
