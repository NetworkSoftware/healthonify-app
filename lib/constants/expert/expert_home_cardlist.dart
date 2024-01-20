import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/custom_ex/add_custom_exercise.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/health_care/expert_view_hc_consultations.dart';
import 'package:healthonify_mobile/screens/expert_screens/body_parts/expert_body_parts_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/earnings/expert_earnings.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_availability.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/client_details/expert_connected_clients.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_personal_clients.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/ex_templates/ex_template_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercises_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/hep_list_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/view_appoinments.dart';
import 'package:provider/provider.dart';

import '../../models/blogs_model/blogs_model.dart';
import '../../providers/blogs_provider/blogs_provider.dart';
import '../../screens/client_screens/blogs/blogs_screen.dart';
import '../../screens/client_screens/physio/physio_conditions.dart';

List<Map<String, dynamic>> physioCardDetails = [
  {
    "title": 'Conditions',
    "subtitle": 'Exercise based on conditions',
    "icon": 'assets/icons/vitals.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const PhysioConditionsScreen(
            isFromExpertProfile: true,
          ),
        ),
      );
    },
  },
  {
    "title": 'Templates',
    "subtitle": 'Exercise Templates',
    "icon": 'assets/icons/web-design.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExTemplateScreen(),
        ),
      );
    },
  },
  {
    "title": 'My Therapy',
    "subtitle": 'Home Exercise Program',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const HepListScreen(title: "My Therapy"),
        ),
      );
    },
  },

  {
    "title": 'New Exercise',
    "subtitle": 'Create and view your ex',
    "icon": 'assets/icons/dumbbell.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const AddCustomExercise(),
        ),
      );
    },
  },
  // {
  //   "title": 'My orders',
  //   "subtitle": 'Check your orders',
  //   "icon": 'assets/icons/subscription.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => OrdersScreen(),
  //       ),
  //     );
  //   },
  // },
  // {
  //   "title": 'My Personal Clients',
  //   "subtitle": 'Dietician Clients',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => MyPersonalClients(),
  //       ),
  //     );
  //   },
  // },
  // {
  //   "title": 'Consultations',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsConsultationsScreen(),
  //       ),
  //     );
  //   },
  // },
  // {
  //   "title": 'My Patients',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsPatientsScreen(),
  //       ),
  //     );
  //   },
  // },
  // {
  //   "title": 'Manage Calendar',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ManageCalendarScreen(),
  //       ),
  //     );
  //   },
  // },
  // {
  //   "title": 'Earnings',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertEarningsScreen(),
  //       ),
  //     );
  //   },
  // },
];

List<Map<String, dynamic>> dietCardDetails = [
  // {
  //   "title": 'Conditions',
  //   "subtitle": 'Exercise based on conditions',
  //   "icon": 'assets/icons/vitals.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ConditionsScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'My Clients',
    "subtitle": 'Dietician Clients',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(builder: (context) => const ExpertConnectedClients()),
      );
    },
  },

  {
    "title": 'My Appointments',
    "subtitle": '......',
    "icon": 'assets/icons/subscription.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ViewAppointmentScreen(),
        ),
      );
    },
  },

  // {
  //   "title": 'Templates',
  //   "subtitle": 'Exercise Templates',
  //   "icon": 'assets/icons/web-design.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExTemplateScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'Exercise Program',
    "subtitle": 'Home Exercise Program',
    "icon": 'assets/icons/dumbbell.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) =>
              const HepListScreen(title: "Exercise training program"),
        ),
      );
    },
  },
  // {
  //   "title": 'My orders',
  //   "subtitle": 'Check your orders',
  //   "icon": 'assets/icons/subscription.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => OrdersScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'My Diet Plans',
    "subtitle": 'Create and view your diet plans',
    "icon": 'assets/icons/apple.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const MyDietPlans(),
        ),
      );
    },
  },
];

List<Map<String, dynamic>> fitnessCardDetails = [
  {
    "title": 'My Clients',
    "subtitle": '......',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      // Navigator.of(context, /*rootnavigator: true*/).push(
      //   MaterialPageRoute(
      //     builder: (context) => const ConditionsScreen(),
      //   ),
      // );
    },
  },
  {
    "title": 'My Appointments',
    "subtitle": '......',
    "icon": 'assets/icons/subscription.png',
    "onClick": (context) {
      // Navigator.of(context, /*rootnavigator: true*/).push(
      //   MaterialPageRoute(
      //     builder: (context) => const ConditionsScreen(),
      //   ),
      // );
    },
  },
  {
    "title": 'My Workout Plans',
    "subtitle": 'Home Exercise Program',
    "icon": 'assets/icons/dumbbell.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const HepListScreen(title: "My Workout Plans"),
        ),
      );
    },
  },
  {
    "title": 'My Diet Plans',
    "subtitle": 'Create and view your diet plans',
    "icon": 'assets/icons/apple.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const MyDietPlans(),
        ),
      );
    },
  },
];

List<Map<String, dynamic>> healthCareCardDetails = [
  // {
  //   "title": 'Consultations',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsConsultationsScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'My Appointments',
    "subtitle": '......',
    "icon": 'assets/icons/subscription.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertViewHcConsultations(
              clientId: "", isHomeFlow: true, title: "My Appointments"),
        ),
      );
    },
  },

  {
    "title": 'Client’s Subscription',
    "subtitle": 'Dietician Clients',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => MyPersonalClients(),
        ),
      );
    },
  },
  // {
  //   "title": 'My Patients',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsPatientsScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'Manage Calendar',
    "subtitle": 'doctor flow',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertAvailabilityScreen(),
        ),
      );
    },
  },
  {
    "title": 'Earnings',
    "subtitle": 'doctor flow',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) =>
              const ExpertEarningsScreen(topLevelExpertise: "Health Care"),
        ),
      );
    },
  },
];

List<Map<String, dynamic>> manageWeightCardDetails = [
  // {
  //   "title": 'Consultations',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsConsultationsScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'My Appointments',
    "subtitle": '......',
    "icon": 'assets/icons/subscription.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertViewHcConsultations(
              clientId: "", isHomeFlow: true, title: "My Appointments"),
        ),
      );
    },
  },

  {
    "title": 'My Patients',
    "subtitle": 'Dietician Clients',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => MyPersonalClients(),
        ),
      );
    },
  },
  // {
  //   "title": 'My Patients',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsPatientsScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'Manage Calendar',
    "subtitle": 'doctor flow',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertAvailabilityScreen(),
        ),
      );
    },
  },
  {
    "title": 'Earnings',
    "subtitle": 'doctor flow',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) =>
          const ExpertEarningsScreen(topLevelExpertise: "Health Care"),
        ),
      );
    },
  },
];

List<Map<String, dynamic>> liveWellCardDetails = [
  // {
  //   "title": 'Consultations',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsConsultationsScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'My Appointments',
    "subtitle": '......',
    "icon": 'assets/icons/subscription.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertViewHcConsultations(
              clientId: "", isHomeFlow: true, title: "My Appointments"),
        ),
      );
    },
  },

  {
    "title": 'My Patients',
    "subtitle": 'Dietician Clients',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => MyPersonalClients(),
        ),
      );
    },
  },
  // {
  //   "title": 'My Patients',
  //   "subtitle": 'doctor flow',
  //   "icon": 'assets/icons/doctor.png',
  //   "onClick": (context) {
  //     Navigator.of(context, /*rootnavigator: true*/).push(
  //       MaterialPageRoute(
  //         builder: (context) => const ExpertsPatientsScreen(),
  //       ),
  //     );
  //   },
  // },
  {
    "title": 'Manage Calendar',
    "subtitle": 'doctor flow',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertAvailabilityScreen(),
        ),
      );
    },
  },
  {
    "title": 'Earnings',
    "subtitle": 'doctor flow',
    "icon": 'assets/icons/doctor.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) =>
          const ExpertEarningsScreen(topLevelExpertise: "Health Care"),
        ),
      );
    },
  },
];

List<Map<String, dynamic>> homeCircularCardDetails = [
  {
    "title": 'Exercises',
    "icon": 'assets/icons/dumbell.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertExercisesScreen(),
        ),
      );
    },
  },
  {
    "title": 'Body Parts',
    "icon": 'assets/icons/apple.png',
    "onClick": (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(
        MaterialPageRoute(
          builder: (context) => const ExpertBodyPartsScreen(),
        ),
      );
    },
  },
  {
    "title": 'Read',
    "icon": 'assets/icons/dumbell.png',
    "onClick": (context) async {
      List<BlogsModel> blogs = [];

      Future<void> fetchAllBlogs() async {
        try {
          blogs = await Provider.of<BlogsProvider>(context, listen: false)
              .getAllBlogs(data: "?expertiseId=6229a980305897106867f787");
        } on HttpException catch (e) {
          log(e.toString());
        } catch (e) {
          log('Error fetching blogs');
        } finally {}
      }

      await fetchAllBlogs();

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlogsScreen(allBlogs: blogs);
      }));
    },
  },
];
