import 'dart:developer';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/firebase_options.dart';
import 'package:healthonify_mobile/models/fiirebase_notifications.dart';
import 'package:healthonify_mobile/providers/multi_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/experts_list_screen.dart';
import 'package:healthonify_mobile/screens/splash/splash_screen.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:zego_zimkit/zego_zimkit.dart';

import 'service/back_service.dart';

/// Instance/Object of shared pref to store data
late SharedPreferences preferences;
late Stream<StepCount> _stepCountStream;
int _steps = 0;

fireAlarm() async {
  String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now());
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('TodayDate', formattedDate);
  initPlatformState();
}

Future<void> onStepCount(StepCount event) async {
  _steps = event.steps;
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove('Step');
  preferences.setInt('Step', _steps);
  var startTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  var currentTime = DateTime.now();
  var diff = currentTime.difference(startTime).inMinutes;
  try {
    if (!preferences.containsKey("totalCountVal") ||
        !preferences.containsKey('updateDate') ||
        preferences.getInt("totalCountVal") == null ||
        preferences.getInt("totalCountVal") == 0) {
      preferences.setInt("totalCountVal", event.steps);
      preferences.setString(
          "updateDate", DateFormat("MM/dd/yyyy").format(DateTime.now()));
      preferences.setInt("todayCountVal",
          (event.steps - (preferences.getInt("totalCountVal") ?? 0)));

      debugPrint(
          "111111TODAY_CC=======${event.steps - (preferences.getInt("totalCountVal") ?? 0)}");
    } else {
      if ((preferences.getString('updateDate').toString() !=
              DateFormat("MM/dd/yyyy").format(DateTime.now())) ||
          (diff > 0 && diff < 10)) {
        preferences.setInt("todayCountVal", 0);
        preferences.setInt("totalCountVal", event.steps);
        preferences.setString(
            "updateDate", DateFormat("MM/dd/yyyy").format(DateTime.now()));
      } else {
        debugPrint(
            "1112222TODAY_CC=======${event.steps - (preferences.getInt("totalCountVal") ?? 0)}");
        preferences.setInt("todayCountVal",
            (event.steps - (preferences.getInt("totalCountVal") ?? 0)));
        preferences.setString(
            "updateDate", DateFormat("MM/dd/yyyy").format(DateTime.now()));
      }
    }
  } catch (e) {
    //
  }
}

void onStepCountError(error) {
  _steps = 0;
}

void initPlatformState() {
  _stepCountStream = Pedometer.stepCountStream;
  _stepCountStream.listen(onStepCount).onError(onStepCountError);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await initializeService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseNotif.init();

  FirebaseMessaging.onBackgroundMessage(
      FirebaseNotif.firebaseMessagingBackgroundHandler);
  // ignore: unused_local_variable
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  //ios configuration

  await FirebaseNotif.createNotifChannel();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FirebaseNotif.registerNotification();
  _configureLocalTimeZone().then((value) {
    // getLocationAccess();
  });
  preferences = await SharedPreferences.getInstance();

  ZIMKit().init(
    appID: 2035107149, // your appid
    appSign:
        "bb7969f743c64b31c89db3bd1291db584eb89cbb3bf5fa11a1f3e3cffd6b55cc", // your appSign
  );
  runApp(const MyApp());
  var now = DateTime.now();
  AndroidAlarmManager.oneShotAt(
      DateTime(now.year, now.month, now.day, 14, 40), 1, fireAlarm);
}

PermissionStatus? permissionStatus;
void getLocationAccess() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  permissionStatus = permissionGranted;
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();
  log("location :LONG- ${locationData.longitude} LAT- ${locationData.latitude} ");
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZone = await FlutterTimezone.getLocalTimezone();
  // log(timeZone);
  tz.setLocalLocation(tz.getLocation(timeZone));
  log("Time zone init");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: orange,
      //statusBarBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: MultiProv.providersArray,
      child: MaterialApp(
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        themeMode: ThemeMode.system,
        title: 'Healthonify',
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        routes: {
          ExpertsList.routeName: (ctx) => const ExpertsList(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool session = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => log(value!));
    FirebaseNotifClickHandler(context: context).setupInteractedMessage().then(
      (value) {
        permissionStatus == PermissionStatus.denied
            ? locationDisclosure()
            : null;
      },
    );

    // getSession();
  }

  // void getSession() async {
  //   setState(() {
  //     isLoading == true;
  //   });
  //   SharedPrefManager pref = SharedPrefManager();
  //   session = await pref.getSession();
  //   setState(() {
  //     isLoading == false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }

  void locationDisclosure() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Use your location",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Healthonify collects location data to enable fitness tracking even when the app is closed or not in use.",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                "assets/icons/maps.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Collected location data will be used to detect laboratories around your location. Please grant access to continue.",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  getLocationAccess();
                  Navigator.pop(context);
                },
                child: const Text('Continue'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
