import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_cli/app/constants/color.dart';
import 'package:test_cli/app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();

  box.read("theme") != null;
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: box.read("appDark") == null ? appLight : appDark,
      title: "Application",
      initialRoute: Routes.INTRODUCTION,
      getPages: AppPages.routes,
    ),
  );
}
