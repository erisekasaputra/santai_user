import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:santai/app/services/secure_storage_service.dart';

class FCMService extends GetxService {
  final SecureStorageService _secureStorage = SecureStorageService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  Future<FCMService> init() async {
    await Firebase.initializeApp();
    await _requestPermissions();
    await _setupNotificationChannels();
    await _setupNotificationHandlers();
    await _initializeLocalNotifications();
    await _setupForegroundNotificationPresentation();
    await _saveToken();
    return this;
  }

  Future<void> _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _setupNotificationChannels() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _setupNotificationHandlers() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  Future<void> _setupForegroundNotificationPresentation() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _saveToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _secureStorage.writeSecureData('fcm_token', token);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _showLocalNotification(message);
    _handleMessage(message);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    _handleMessage(message);
  }

  void _handleInitialMessage(RemoteMessage message) {
    _handleMessage(message);
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    if (data['orderId'] != null) {
      // dynamic orderId = data['orderId'];
      // Navigate to the order details screen
      // Get.toNamed('/order-details', arguments: data['orderId']);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final data = message.data;

 

    if (data.isNotEmpty) {
      List<AndroidNotificationAction>? actions;
      if (data['actions'] is String) {
        actions = (json.decode(data['actions']) as List).map((action) {

          return AndroidNotificationAction(
            action['action'],
            action['title'],
            showsUserInterface: true,
          );
        }).toList();
      }

      _flutterLocalNotificationsPlugin.show(
        0,
        data['title'] ?? 'Default title', // Provide a default title if null
        data['body'] ?? 'Default body', // Provide a default body if null
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            actions: actions,
          ),
        ),
        payload: data['orderId'],
      );
    } 
  }

void _onDidReceiveNotificationResponse(NotificationResponse response) {

    if (response.payload != null) {
      // final notificationData = json.decode(response.payload!);

      if (response.actionId != null) {
        switch (response.actionId) {
          case 'accept_action':
           
            break;
          case 'decline_action':
         
            break;
          default:
           
        }
      } else {
        // Navigate to order details screen
        // Get.toNamed('/order-details', arguments: notificationData['orderId']);
      }
    }
  }
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final fcmService = FCMService();
  await fcmService._initializeLocalNotifications();
  fcmService._showLocalNotification(message);
}
