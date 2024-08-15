import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: Routes.REG_USER_PROFILE,
      // initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}
