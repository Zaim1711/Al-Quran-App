import 'dart:convert';

// Fungsi untuk mengonversi JSON string ke objek DetailSurah
DetailSurah detailSurahFromJson(String str) =>
    DetailSurah.fromJson(json.decode(str));

// Fungsi untuk mengonversi objek DetailSurah ke JSON string
String detailSurahToJson(DetailSurah data) => json.encode(data.toJson());

class DetailSurah {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final Map<String, String>? audioFull;
  final List<Ayat>? ayat;
  final dynamic suratSelanjutnya; // Bisa Map atau bool
  final bool? suratSebelumnya;

  DetailSurah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    required this.ayat,
    required this.suratSelanjutnya,
    required this.suratSebelumnya,
  });

  factory DetailSurah.fromJson(Map<String, dynamic>? json) {
    return DetailSurah(
        nomor: json?["nomor"] as int,
        nama: json?["nama"] as String,
        namaLatin: json?["namaLatin"] as String,
        jumlahAyat: json?["jumlahAyat"] as int,
        tempatTurun: json?["tempatTurun"] as String,
        arti: json?["arti"] as String,
        deskripsi: json?["deskripsi"] as String,
        audioFull: (json?["audioFull"] as Map<String, dynamic>?)
                ?.cast<String, String>() ??
            {},
        ayat: (json?["ayat"] as List<dynamic>?)
                ?.map((e) => Ayat.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        suratSelanjutnya: json?["suratSelanjutnya"] is Map<String, dynamic>
            ? SuratSelanjutnya.fromJson(
                json?["suratSelanjutnya"] as Map<String, dynamic>)
            : json?["suratSelanjutnya"],
        suratSebelumnya: json?["suratSebelumnya"] is bool
            ? json!["suratSebelumnya"] as bool
            : null);
  }

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
        "tempatTurun": tempatTurun,
        "arti": arti,
        "deskripsi": deskripsi,
        "audioFull": audioFull,
        "ayat": ayat == null
            ? null
            : List<dynamic>.from(ayat!.map((x) => x.toJson())),
        "suratSelanjutnya": suratSelanjutnya is SuratSelanjutnya
            ? (suratSelanjutnya as SuratSelanjutnya).toJson()
            : suratSelanjutnya,
        "suratSebelumnya": suratSebelumnya,
      };
}

class Ayat {
  int? nomorAyat;
  String? teksArab;
  String? teksLatin;
  String? teksIndonesia;
  Map<String, String>? audio;
  String kondisiAudio; // Tidak perlu inisialisasi di sini

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
    required this.kondisiAudio, // Perubahan pada konstruktor
  });

  factory Ayat.fromJson(Map<String, dynamic>? json) => Ayat(
        nomorAyat: json?["nomorAyat"],
        teksArab: json?["teksArab"],
        teksLatin: json?["teksLatin"],
        teksIndonesia: json?["teksIndonesia"],
        audio: Map<String, String>.from(json?["audio"] ?? {}),
        kondisiAudio: "stop", // Inisialisasi kondisiAudio dari JSON
      );

  Map<String, dynamic> toJson() => {
        "nomorAyat": nomorAyat,
        "teksArab": teksArab,
        "teksLatin": teksLatin,
        "teksIndonesia": teksIndonesia,
        "audio": audio,
        "kondisiAudio": kondisiAudio,
      };
}

class SuratSelanjutnya {
  int nomor;
  String nama;
  String namaLatin;
  int jumlahAyat;

  SuratSelanjutnya({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
  });

  factory SuratSelanjutnya.fromJson(Map<String, dynamic> json) =>
      SuratSelanjutnya(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
      );

  Map<String, dynamic> toJson() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
      };
}
