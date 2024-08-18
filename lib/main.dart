import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/controllers/permission_controller.dart';
import 'package:santai/app/services/location_service.dart';
import 'package:santai/app/services/timezone_service.dart';
import 'app/routes/app_pages.dart';
import 'app/controllers/device_info_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final timezoneService = TimezoneService();
  await timezoneService.initializeTimeZones();
  
  // Map<String, String> timezoneInfo = await timezoneService.getDetailedDeviceTimezone();

  String timezone = await timezoneService.getDeviceTimezone();
  await timezoneService.saveTimezone(timezone);
  print('Updated device timezone: $timezone');

  Get.put(LocationService());
  Get.put(TimezoneService());
  Get.put(PermissionController());


  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
        fontFamily: 'Saira',
      ),


      // initialRoute: Routes.SETTINGS,
      initialRoute: Routes.LOGIN,


      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(DeviceInfoController());
      }),
    ),
  );
}