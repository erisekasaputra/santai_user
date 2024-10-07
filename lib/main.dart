import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/controllers/permission_controller.dart';
import 'package:santai/app/controllers/theme_controller.dart';

import 'package:santai/app/services/location_service.dart';
import 'package:santai/app/services/notification_service.dart';
import 'package:santai/app/services/signal_r_service.dart';
import 'package:santai/app/services/timezone_service.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/controllers/device_info_controller.dart';

import 'package:santai/app/services/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final timezoneService = TimezoneService();
  await timezoneService.initializeTimeZones();

  final notificationService = NotificationService();
  await notificationService.initNotification();
  
  // Map<String, String> timezoneInfo = await timezoneService.getDetailedDeviceTimezone();

  // String timezone = await timezoneService.getDeviceTimezone();
  // await timezoneService.saveTimezone(timezone);

  Get.put(LocationService());
  Get.put(TimezoneService());
  Get.put(PermissionController());
  Get.put(ThemeController());
  Get.put(SignalRService());

  // await Get.putAsync(() => FCMService().init());

  await Get.putAsync(() => FCMService().init());

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: AppTheme.lightTheme,


      initialRoute: Routes.SPLASH_SCREEN,


      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(DeviceInfoController());
      }),
    ),
  );
}