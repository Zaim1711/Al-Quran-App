import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/routes/app_pages.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "NGAJI",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Text(
              "Sesibuk itukah kamu sampai belum membaca alquran ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 70),
          Container(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/lotties/animasi_quran.json',
              )),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Get.offAllNamed(Routes.SURAH),
            child: Text(
              "GET STARTED",
              style: TextStyle(
                color: Get.isDarkMode ? appGreen : appWhite,
              ),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode ? appWhite : appGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ) // Use primary for background color
                ),
          )
        ],
      ),
    ));
  }
}
