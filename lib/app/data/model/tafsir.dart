// tafsir.dart
class Tafsir {
  final int ayat;
  final String teks;

  Tafsir({required this.ayat, required this.teks});

  factory Tafsir.fromJson(Map<String, dynamic> json) {
    return Tafsir(
      ayat: json['ayat'],
      teks: json['teks'],
    );
  }
}

class Tafsirfull {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final List<Tafsir> tafsir;

  Tafsirfull({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.tafsir,
  });

  factory Tafsirfull.fromJson(Map<String, dynamic> json) {
    var tafsirList = json['tafsir'] as List;
    List<Tafsir> tafsirData =
        tafsirList.map((i) => Tafsir.fromJson(i)).toList();

    return Tafsirfull(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      tafsir: tafsirData,
    );
  }
}
