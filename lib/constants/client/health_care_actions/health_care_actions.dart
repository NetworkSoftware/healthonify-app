import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/lab_reports/lab_appointment_details.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/lab_reports/lab_reports.dart';
import 'package:healthonify_mobile/screens/client_screens/medical_history.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/medical_reports/medical_reports.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/my_medication/my_medications.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/second_opinion/second_opinion.dart';
import 'package:healthonify_mobile/screens/client_screens/health_locker/health_locker.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/sleep/sleep_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/step_tracker/steps_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/watertracker/water_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/vitals_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map<String, dynamic>> healthCareQuickLinks = [
  {
    "title": 'My Vitals',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VitalsScreen();
      }));
    },
    "icon": 'assets/icons/vital.png',
  },
  {
    "title": 'Health Locker',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HealthLockerScreen();
      }));
    },
    "icon": 'assets/icons/digi_locker.png',
  },
  {
    "title": 'Diet Tracker',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MealPlansScreen();
      }));
    },
    "icon": 'assets/icons/track_diet.png',
  },
  {
    "title": 'Steps Tracker',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const StepsScreen();
      }));
    },
    "icon": 'assets/icons/walk.png',
  },
  {
    "title": 'Water Tracker',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const WaterTrackerScreen();
      }));
    },
    "icon": 'assets/icons/water.png',
  },
  {
    "title": 'Sleep Tracker',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SleepScreen();
      }));
    },
    "icon": 'assets/icons/sleep_tracker.png',
  },
  {
    "title": 'Medical Form',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MedicalHistoryScreen();
      }));
    },
    "icon": 'assets/icons/measure.png',
  },
];

List<Map<String, dynamic>> healthCareGridView = [
  {
    "title": 'Lab Tests',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LabReportScreen();
      }));
      //locationDisclosure();
    },
    "icon": 'assets/images/lab_test.png',
  },
  {
    "title": "Your lab Appointments",
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyLabAppointmentScreen();
      }));
    },
    "icon": 'assets/icons/lab_test.png',
  },
  {
    "title": 'Lab Reports',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyReportsScreen();
      }));
    },
    "icon": 'assets/icons/my_reports.png',
  },
  {
    "title": 'Medical History',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MedicalHistoryScreen();
      }));
    },
    "icon": 'assets/icons/history.png',
  },
  {
    "title": 'My Medication',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyMedicationsScreen();
      }));
    },
    "icon": 'assets/icons/medications.png',
  },
  {
    "title": 'Second Opinion',
    "onClick": (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SecondOpinionScreen();
      }));
    },
    "icon": 'assets/icons/opinions.png',
  },
  {
    "title": 'Medical Equipment',
    "onClick": (context) async {
      await launchUrl(Uri.parse("https://healthonify.com/shop"));
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return const MedicalEquipmentScreen();
      // }));
    },
    "icon": 'assets/icons/medical_equipment.png',
  },
  {
    "title": 'Buy Medicines',
    "onClick": (context) {
      launchUrl(Uri.parse("https://healthonify.com/Shop"));
    },
    "icon": 'assets/icons/buy_meds.png',
  },
];

// void locationDisclosure() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: Theme
//             .of(context)
//             .canvasColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Text(
//                   "DISCLAIMER",
//                   style: Theme
//                       .of(context)
//                       .textTheme
//                       .labelLarge,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "Healthonify collects location data to enable fitness tracking even when the app is closed or not in use. Location features will be used to detect laboratories around your location. Please grant access to continue.",
//                 style: Theme
//                     .of(context)
//                     .textTheme
//                     .bodyMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Continue'),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
