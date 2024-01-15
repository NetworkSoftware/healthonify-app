import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthonify_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/screens/video_call_1.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

var initializationSettingsAndroid =
    const AndroidInitializationSettings('mipmap/launcher_icon');
var initializationSettingsIOS = const DarwinInitializationSettings(
  defaultPresentAlert: true,
  defaultPresentBadge: true,
  defaultPresentSound: true,
  requestAlertPermission: true,
  requestBadgePermission: false,
  requestSoundPermission: false,
);
var initializationSettings = InitializationSettings(
  iOS: initializationSettingsIOS,
  android: initializationSettingsAndroid,
);

class FirebaseNotif {
  /// Create a [AndroidNotificationChannel] for heads up notifications
  static AndroidNotificationChannel? _channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  /// Initialize the [_firebaseMessaging] instance
  static FirebaseMessaging? _firebaseMessaging;

  /// [handleFCMData] method what action will be taken while user gets notification
  static void Function(RemoteMessage)? handleFCMData;

  /// the [init] method initializes the Firebase and Firebase messaging services
  static Future<FirebaseApp> init() async {
    // initialize firebase
    var firebase = await Firebase.initializeApp();

    // on background message
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    /// init [_firebaseMessaging]
    _firebaseMessaging = FirebaseMessaging.instance;

    /// init [_channel]
    _channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        // description
        importance: Importance.high);

    // init local notification plugin
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await _flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel!);

    // set messaging options
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    return firebase;
  }

  /// method [_handleBackgroundMessage] handles messages received in background
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    if (handleFCMData != null) {
      handleFCMData!(message);
    }
  }

  // method to get fcm token
  static Future<String?> getFcmToken() async {
    // assert initialization of this class
    assert(
    _flutterLocalNotificationsPlugin != null &&
        _channel != null &&
        _firebaseMessaging != null,
    'Make sure you have called init() method');

    // subscribe to all topics
    await _firebaseMessaging!.subscribeToTopic('all');
    return await _firebaseMessaging!.getToken();
  }

  static Future<void> createNotifChannel() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void registerNotification() async {
    var messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted notifications permission");
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!${message.data}');
        log('$message');
        // showNotification(message);
      });
    } else {
      log("Permission declined by user");
    }

    bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    log("requested ios notifications $result");
  }

  static void showNotification(RemoteMessage message) async {
    if (message.notification != null) {
      // showSimpleNotification(
      //   Text(message.notification!.title!),
      //   leading: const Text("Hoiii "),
      //   subtitle: Text(message.notification!.body!),
      //   duration: const Duration(seconds: 2),
      // );

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (details) =>
            log("payload $details"),
      );

      flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title!,
          message.notification!.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: 'mipmap/launcher_icon',
                priority: Priority.high,
                importance: Importance.high,
                channelShowBadge: true,
                enableVibration: true,
              ),
              iOS: const DarwinNotificationDetails(
                subtitle: "Hello",
              )));
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log(message.notification!.title!);
    log("Handling a background message: ${message.messageId}");
    showNotification(message);
  }

  NotificationDetails initNotif() {
    const DarwinNotificationDetails details = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
     AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description', icon: "mipmap/launcher_icon",sound: RawResourceAndroidNotificationSound('water_drop'),);
     NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: details);

    return notificationDetails;
  }

  void scheduledNotification({
    required int id,
    required int hour,
    required int minute,
    String title = "Healthonify",
    String desc = "This is a reminder",
  }) async {
    log("id $id");

    NotificationDetails notificationDetails = initNotif();

    // await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
    //     'repeating body', RepeatInterval.everyMinute, notificationDetails,
    //     androidAllowWhileIdle: true);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      desc,
      _scheduleDaily(Time(hour, minute)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    log("scheduled");
  }

  tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    log("time zone $now");
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    log("time zone scheduled $scheduledDate");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    log("returned time $scheduledDate");
    return scheduledDate;
  }

  void scheduledDayNotification(
      {required int id,
      required DateTime dateTime,
      String title = "Healthonify",
      String desc = "This is a reminder"}) async {
    log("id $id");
    NotificationDetails notificationDetails = initNotif();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      desc,
      tz.TZDateTime(tz.local, dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    log("Notif scheduled on  ${dateTime.hour}:${dateTime.minute}  ${dateTime.day}/${dateTime.month}/${dateTime.year}  }");
  }

  void cancelNotif(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    log("notif cancelled");
  }

  void getPending() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var element in pendingNotificationRequests) {
      log(element.toString());
      log("body ${element.body}");
      log("title ${element.title}");
      log("klsf ${element.id}");
    }
  }
}

class FirebaseNotifClickHandler {
  BuildContext context;
  FirebaseNotifClickHandler({required this.context});

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const MyApp()));

    // {screen: videoCall, date: 2022-11-29,
    // consultationId: r4AE9QCNpJ,
    //  meetingLink: r4AE9QCNpJ,
    //   sessionName: Ruchi, time: 16:47}

    if (message.data.isNotEmpty) {
      var data = message.data;
      if (data["screen"] == "videoCall") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoCall1(
                  onVideoCallEnds: () {},
                  meetingId: data["consultationId"],
                )));
        return;
      }
      if (data["screen"] == "payment") {
        launchUrl(
          Uri.parse(data["paymentLink"]),
        );
        return;
      }
    }

    log("On click notif");
    log("$message");
    log("${message.data}");
    log("${message.notification!.body}");
  }
}
