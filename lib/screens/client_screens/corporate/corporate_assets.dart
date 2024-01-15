import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/doctor_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/personal_trainer_screen.dart';
import '../../expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import '../../my_diary/my_diary.dart';
import '../calories_details.dart';
import '../consult_dietician.dart';
import '../fitness_tools/bmi_details.dart';
import '../fitness_tools/bmr_screen.dart';
import '../fitness_tools/body_fat_screen.dart';
import '../fitness_tools/ideal_weight_screen.dart';
import '../health_care/ayurveda/ayurveda.dart';
import '../health_locker/health_locker.dart';
import '../health_meter/HRA/hra_screen.dart';
import '../my_workout/current_workout_plan.dart';
import '../physio/physiotherapy_screen.dart';
import '../trackers/sleep/sleep_screen.dart';
import '../trackers/step_tracker/steps_screen.dart';
import '../trackers/watertracker/water_screen.dart';
import '../weight_management/meal_plans_screen.dart';
import '../weight_screen.dart';
import '../workout_analysis/workout_analysis.dart';

List fitnessTools = [
  {
    'title': 'My workout plan',
    'icon': 'assets/icons/workout.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CurrentWorkoutPlan();
      }));
    },
  },
  {
    'title': 'Workout Analysis',
    'icon': 'assets/icons/workout_analysis.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const WorkoutAnalysisScreen();
      }));
    },
  },
  {
    'title': 'Log Weight',
    'icon': 'assets/icons/log_weight.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const WeightScreen();
      }));
    },
  },
  {
    'title': 'BMI',
    'icon': 'assets/icons/bmi.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return  BmiDetailsScreen();
      }));
    },
  },
  {
    'title': 'BMR',
    'icon': 'assets/icons/bmr.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const BMRScreen();
      }));
    },
  },
  {
    'title': 'Ideal Weight Calculator',
    'icon': 'assets/icons/calculator.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const IdealWeightScreen();
      }));
    },
  },
  {
    'title': 'Body Fat',
    'icon': 'assets/icons/body_fat.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const BodyFatScreen();
      }));
    },
  },
  {
    'title': 'Steps',
    'icon': 'assets/icons/steps.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const StepsScreen();
      }));
    },
  },
];
List nutritionTools = [
  {
    'title': 'My Diet Plan',
    'icon': 'assets/icons/diet.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyDietPlans();
      }));
    },
  },
  {
    'title': 'Diet Analysis',
    'icon': 'assets/icons/dietician.png',
    'route': (context) {},
  },
  {
    'title': 'Track my diet',
    'icon': 'assets/icons/fruits.png',
    'route': (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const MealPlansScreen();
      }));
    },
  },
  {
    'title': 'Calorie Calculator',
    'icon': 'assets/icons/calories.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const CalorieDetailScreen();
      }));
    },
  },
  {
    'title': 'My Diary',
    'icon': 'assets/icons/diary.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyDiary();
      }));
    },
  },
  {
    'title': 'Calorie Balance',
    'icon': 'assets/icons/carbs.png',
    'route': (context) {},
  },
  {
    'title': 'Water',
    'icon': 'assets/icons/water.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const WaterTrackerScreen();
      }));
    },
  },
];

List healthItems = [
  {
    'title': 'My Health',
    'icon': 'assets/icons/heal.png',
    'route': (context) {},
  },
  {
    'title': 'HRA',
    'icon': 'assets/icons/health_insurance.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HraScreen(hraData: []);
      }));
    },
  },
  {
    'title': 'Health Locker',
    'icon': 'assets/icons/health_meter.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HealthLockerScreen();
      }));
    },
  },
  {
    'title': 'Sleep',
    'icon': 'assets/icons/sleep_tracker.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SleepScreen();
      }));
    },
  },
];

List miboso = [
  {
    'title': 'Meditation',
    'icon': '',
    'route': (context) {},
  },
  {
    'title': 'Sleep',
    'icon': '',
    'route': (context) {},
  },
  {
    'title': 'Stress & Anxiety',
    'icon': '',
    'route': (context) {},
  },
  {
    'title': 'Sound Therapy',
    'icon': '',
    'route': (context) {},
  },
];

List consultExperts = [
  {
    'title': 'Doctors',
    'icon': 'assets/icons/consult_expert.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const DoctorConsultationScreen();
      }));
    },
  },
  {
    'title': 'Ayurveda',
    'icon': 'assets/icons/ayurveda.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AyurvedaScreen();
      }));
    },
  },
  {
    'title': 'Physiotherapy',
    'icon': 'assets/icons/physio.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PhysiotherapyScreen(category: 4);
      }));
    },
  },
  {
    'title': 'Dieticians',
    'icon': 'assets/icons/dietician.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const ConsultDieticianExpert();
      }));
    },
  },
  {
    'title': 'Physical Trainer',
    'icon': 'assets/icons/trainer.png',
    'route': (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const PersonalTrainer();
      }));
    },
  },
  {
    'title': 'Mind Experts',
    'icon': 'assets/icons/brain.png',
    'route': (context) {},
  },
  {
    'title': 'Manage Stress',
    'icon': 'assets/icons/stress.png',
    'route': (context) {},
  },
  {
    'title': 'Others',
    'icon': 'assets/icons/others.png',
    'route': (context) {},
  },
];
