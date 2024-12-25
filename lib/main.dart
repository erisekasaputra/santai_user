import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

  await Get.putAsync(() => FCMService().init());

  final timezoneService = TimezoneService();
  await timezoneService.initializeTimeZones();

  final notificationService = NotificationService();
  await notificationService.initNotification();

  // Registrasi layanan lainnya
  Get.put(LocationService());
  Get.put(TimezoneService());
  Get.put(PermissionController());
  Get.put(ThemeController());

  final chatService = Get.put(SignalRService());
  await chatService.initializeConnection();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
