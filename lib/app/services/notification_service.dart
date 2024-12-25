import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    // const DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );

    // const InitializationSettings initializationSettings =
    //     InitializationSettings(
    //   android: initializationSettingsAndroid,
    //   iOS: initializationSettingsIOS,
    // );

    // await notificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (details) {
    //     // Handle notification tap
    //   },
    // );
  }

  // Future<void> showNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  // }) async {
  //   try {
  //     await notificationsPlugin.show(
  //       id,
  //       title,
  //       body,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'your_channel_id',
  //           'Your Channel Name',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //         ),
  //         iOS: DarwinNotificationDetails(),
  //       ),
  //     );
  //   } catch (e) {}
  // }

  // Future<void> scheduleNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required DateTime scheduledDate,
  // }) async {
  //   await notificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     tz.TZDateTime.from(scheduledDate, tz.local),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'your_channel_id',
  //         'Your Channel Name',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //       iOS: DarwinNotificationDetails(),
  //     ),
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }

  // Future<void> cancelNotification(int id) async {
  //   await notificationsPlugin.cancel(id);
  // }

  // Future<void> cancelAllNotifications() async {
  //   await notificationsPlugin.cancelAll();
  // }
}


// class YourController extends GetxController {
//   final NotificationService _notificationService = NotificationService();

//   void showSimpleNotification() {
//     _notificationService.showNotification(
//       id: 0,
//       title: 'Simple Notification',
//       body: 'This is a simple notification',
//     );
//   }

//   void scheduleNotification() {
//     _notificationService.scheduleNotification(
//       id: 1,
//       title: 'Scheduled Notification',
//       body: 'This is a scheduled notification',
//       scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
//     );
//   }

//   void cancelNotification(int id) {
//     _notificationService.cancelNotification(id);
//   }

//   void cancelAllNotifications() {
//     _notificationService.cancelAllNotifications();
//   }
// }