import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Map<String, String>> newsItems = [
    {
      'description':
          'Serangan Udara Israel di Khan Younis Tewaskan 5 Warga Palestina',
      'url':
          'https://20.detik.com/detikupdate/20240712-240712111/serangan-udara-israel-di-khan-younis-tewaskan-5-warga-palestina',
      'image':
          'https://akcdn.detik.net.id/community/media/visual/2024/04/19/potret-anak-anak-gaza-memandang-sekolah-mereka-yang-hancur-2_43.jpeg?w=300&q=80',
    },
    {
      'description':
          'Serangan Udara Israel Tewaskan 90 Warga Palestina di Gaza',
      'url':
          'https://www.cnbcindonesia.com/news/20240714055528-4-554335/serangan-udara-israel-tewaskan-90-warga-palestina-di-gaza',
      'image':
          'https://akcdn.detik.net.id/visual/2024/07/02/israel-mengusir-warga-hingga-pasien-yang-sedang-dirawat-di-rumah-sakit-di-khan-younis-selatan-jalur-gaza-reutersammar-awad-6_11.jpeg?w=200&q=90',
    },
    // Tambahkan item berita lainnya sesuai kebutuhan
  ];

  int _currentIndex = 0;

  final List<Map<String, String>> boxItems = [
    {
      'title': 'Menulis',
      'image': 'assets/images/menulis_logo.png',
    },
    {'title': 'Hafalan', 'image': 'assets/images/hafalan_logo.png'},
    {'title': 'Mengaji', 'image': ''},
    {'title': 'Afirmasi', 'image': 'assets/images/afirmasi_logo.png'},
    {
      'title': 'Al-Quran & Buku',
      'image': 'assets/images/alquran_logo.png',
      'routes': Routes.SURAH
    },
    {'title': 'Murottal', 'image': 'assets/images/murottal_logo.png'},
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage("assets/images/Foto_Profile.png"),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Administrator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              'Jakarta, Indonesia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 10,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: newsItems.map((news) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          _launchURL(news['url']!);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(news['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              Positioned(
                                bottom: 80,
                                left: 10,
                                right: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      news['description']!,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _launchURL(news['url']!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text(
                                    'Baca Sekarang',
                                    style: TextStyle(color: appWhite),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: newsItems.map((news) {
                  int index = newsItems.indexOf(news);
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _currentIndex == index ? 24.0 : 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                      color: _currentIndex == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              GridView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: boxItems.length,
                itemBuilder: (context, index) {
                  final item = boxItems[index];
                  return GestureDetector(
                    onTap: () {
                      if (item['routes'] != null) {
                        Get.toNamed(item['routes']!);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: appGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['image']!,
                            height: 50,
                            width: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                color: Colors.red,
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item['title']!,
                            style: const TextStyle(color: appWhite),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
