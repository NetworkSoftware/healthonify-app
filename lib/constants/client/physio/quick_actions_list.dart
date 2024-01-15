import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/body_measurements/body_measurements.dart';
import 'package:healthonify_mobile/screens/client_screens/health_locker/health_locker.dart';
import 'package:healthonify_mobile/screens/client_screens/my_therapies.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/browse_physio_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/subscriptions/physio_viewall_subscriptions.dart';

List<Map<String, dynamic>> physioQuickActions = [
  {
    "title": 'My Therapies',
    "onClick": (context) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MyTherapiesScreen(),
      ));

    },
    "icon": 'assets/icons/diet.png',
  },
  {
    "title": 'View Plans',
    "onClick": (context) {
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => const PackagesScreen(),
      // ));
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BrowsePhysioPlans(),
      ));
    },
    "icon": 'assets/icons/track_diet.png',
  },
  {
    "title": 'Subscriptions',
    "onClick": (context) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PhysioViewAllSubscriptions(),
      ));
    },
    "icon": 'assets/icons/log_weight.png',
  },
  {
    "title": 'My Health Locker',
    "onClick": (context) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HealthLockerScreen(),
      ));
    },
    "icon": 'assets/icons/weekly_analysis.png',
  },
  {
    "title": 'Measurements',
    "onClick": (context) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BodyMeasurementsScreen(),
      ));
    },
    "icon": 'assets/icons/measure.png',
  },
];
