import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/current_workout_plan.dart';
import 'package:healthonify_mobile/screens/client_screens/health_locker/health_locker.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/health_meter_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/insurance_locker/insurance_locker.dart';
import 'package:healthonify_mobile/screens/client_screens/my_care_plan/my_care_plan_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/vitals_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/womens_special/women_special_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/workout_analysis/workout_analysis.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:healthonify_mobile/screens/my_diary/my_diary.dart';

List<Map<String, dynamic>> homeQuickActionsList = [
  {
    "title": 'My Workout',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return CurrentWorkoutPlan();
      }));
    },
    "icon": 'assets/icons/workout.png',
  },
  {
    "title": 'Workout Analysis',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const WorkoutAnalysisScreen();
      }));
    },
    "icon": 'assets/icons/workout_analysis.png',
  },
  {
    "title": 'My Diet Plans',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const MyDietPlans();
      }));
    },
    "icon": 'assets/icons/diet.png',
  },
  {
    "title": 'Track my Diet',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const MealPlansScreen();
      }));
    },
    "icon": 'assets/icons/track_diet.png',
  },
  {
    "title": 'Log Weight',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const WeightScreen();
      }));
    },
    "icon": 'assets/icons/log_weight.png',
  },
  {
    "title": 'Health Locker',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const HealthLockerScreen();
      }));
    },
    "icon": 'assets/icons/digi_locker.png',
  },
  {
    "title": 'Health Meter',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const HealthMeterScreen();
      }));
    },
    "icon": 'assets/icons/health_meter.png',
  },
  {
    "title": 'My Care Plan',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const MyCarePlanScreen();
      }));
    },
    "icon": 'assets/icons/my_care.png',
  },
  {
    "title": 'Women Special',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const WomenSpecialScreen();
      }));
    },
    "icon": 'assets/icons/women.png',
  },
  {
    "title": 'Vitals',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return VitalsScreen();
      }));
    },
    "icon": 'assets/icons/vital.png',
  },
  {
    "title": 'Insurance Locker',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const InsuranceLockerScreen();
      }));
    },
    "icon": 'assets/icons/insurance.png',
  },
  {
    "title": 'My Diary',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const MyDiary();
      }));
    },
    "icon": 'assets/icons/diary.png',
  },
];
