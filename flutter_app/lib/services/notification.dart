// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/pb/empty_request.pb.dart';
import 'package:flutter_app/pb/rpc_notifications.pb.dart';
import 'package:flutter_app/services/grpc_services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  static String notificationChannelId = 'user-notification-channel';
  static int notificationId = 888;
  static String notificationService = "notification-service";
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      notificationService,
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: false,

        notificationChannelId:
            notificationChannelId, // this must match with notification channel you created above.
        //  initialNotificationTitle: 'AWESOME SERVICE',
        //initialNotificationContent: 'Initializing',
        // foregroundServiceNotificationId: notificationId,

        autoStartOnBoot: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on("stop_service").listen((event) async {
      await service.stopSelf();
    });

    // bring to foreground

    if (service is AndroidServiceInstance) {
      final res = getNotification();
      res.listen((event) {
        log(event.title.toString(), name: 'notification-service');
        flutterLocalNotificationsPlugin.show(
          notificationId,
          event.title,
          event.description,
          NotificationDetails(
            android: AndroidNotificationDetails(
                notificationChannelId, notificationService,
                icon: 'ic_bg_service_small', ongoing: false, autoCancel: true),
          ),
        );
      });
    }
  }

  static Stream<NotificationMessage> getNotification() async* {
    final request = EmptyRequest();
    final responseStream = GrpcService.client.getNotifications(request);
    await for (var notification in responseStream) {
      // Handle each NotificationMessage received from the stream.
      yield notification;
    }
  }
}
