import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/corporate/corporate.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda_doctor_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/browse_ayurveda_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/browse_hc_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/doctor_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/hc_my_subscription.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/no_connection.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTopList {
  final Image? image;
  final String? title;
  final Gradient? gradient;
  final Function? function;

  const HomeTopList(
      {required this.title,
      required this.gradient,
      required this.function,
      required this.image});
}

List<HomeTopList> clientHomeTopList = [
  HomeTopList(
    title: "Health Care",
    gradient: blueGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return HealthCareScreen(category: 1);
      }));
    },
    image: Image.asset('assets/icons/health_care.png'),
  ),
  HomeTopList(
    title: "Manage Weight",
    gradient: orangeGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return ManageWeightScreen(category: 2);
      }));
    },
    image: Image.asset('assets/icons/weigh_machine.png'),
  ),
  HomeTopList(
    image: Image.asset('assets/icons/weight.png'),
    title: "Fitness",
    gradient: blueGradient,
    function: (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return FitnessScreen(category: 3);
      }));
    },
  ),
  HomeTopList(
    title: "Physiotherapy",
    gradient: orangeGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return PhysiotherapyScreen(category: 4);
      }));
    },
    image: Image.asset('assets/icons/physio.png'),
  ),
  HomeTopList(
    title: "Consult Experts",
    gradient: blueGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return ConsultExpertsScreen(category: 5);
      }));
    },
    image: Image.asset('assets/icons/badge.png'),
  ),
  HomeTopList(
    title: "Live Well",
    gradient: orangeGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return LiveWellScreen(category: 6);
      }));
    },
    image: Image.asset('assets/icons/live_well.png'),
  ),
  HomeTopList(
    title: "Shop",
    gradient: blueGradient,
    function: (BuildContext context) {
      // Navigator.of(
      //   context, /*rootnavigator: true*/
      // ).push(MaterialPageRoute(builder: (context) {
      //   return
      // }));
      launchUrl(Uri.parse("https://healthonify.com/Shop"));
    },
    image: Image.asset('assets/icons/shop.png'),
  ),
];

List<HomeTopList> corporateHomeTopList = [
  HomeTopList(
    title: "Health Care",
    gradient: blueGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return HealthCareScreen(category: 1);
      }));
    },
    image: Image.asset('assets/icons/health_care.png'),
  ),
  HomeTopList(
    title: "Manage Weight",
    gradient: orangeGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return ManageWeightScreen(category: 2);
      }));
    },
    image: Image.asset('assets/icons/weigh_machine.png'),
  ),
  HomeTopList(
    image: Image.asset('assets/icons/weight.png'),
    title: "Fitness",
    gradient: blueGradient,
    function: (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return FitnessScreen(category: 3);
      }));
    },
  ),
  HomeTopList(
    title: "Physiotherapy",
    gradient: orangeGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return PhysiotherapyScreen(category: 4);
      }));
    },
    image: Image.asset('assets/icons/physio.png'),
  ),
  HomeTopList(
    title: "Consult Experts",
    gradient: blueGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return ConsultExpertsScreen(category: 5);
      }));
    },
    image: Image.asset('assets/icons/badge.png'),
  ),
  HomeTopList(
    title: "Corporate",
    gradient: orangeGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const CorporateScreen();
      }));
    },
    image: Image.asset('assets/icons/handshake.png'),
  ),
  HomeTopList(
    title: "Live Well",
    gradient: blueGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return LiveWellScreen(category: 6);
      }));
    },
    image: Image.asset('assets/icons/live_well.png'),
  ),
  HomeTopList(
    title: "Shop",
    gradient: orangeGradient,
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return const NoConnectionScreen();
      }));
    },
    image: Image.asset('assets/icons/shop.png'),
  ),
];

class HealthcareTopList {
  final Image? image;
  final String? title;
  final Gradient? gradient;
  final Function? function;

  const HealthcareTopList(
      {required this.title,
      required this.gradient,
      required this.function,
      required this.image});
}

List<HealthcareTopList> healthcareTopList = [
  HealthcareTopList(
      image: Image.asset('assets/icons/heal.png'),
      title: "Consult Doctor",
      gradient: blueGradient,
      function: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const DoctorConsultationScreen();
            },
          ),
        );
      }),
  HealthcareTopList(
    title: 'Health Care Packages',
    gradient: purpleGradient,
    function: (BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BrowseHealthCarePlans(),
        ),
      );
    },
    image: Image.asset('assets/icons/browse_plans.png'),
  ),
  HealthcareTopList(
    title: "Subscribed Packages",
    gradient: blueGradient,
    function: (BuildContext context) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return const MyCarePlanScreen();
      //     },
      //   ),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MyHCSubscriptions();
          },
        ),
      );
    },
    image: Image.asset('assets/icons/my_care.png'),
  ),
  // HealthcareTopList(
  //   title: "Ayurveda",
  //   gradient: orangeGradient,
  //   function: (BuildContext context) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return AyurvedaScreen();
  //         },
  //       ),
  //     );
  //   },
  //   image: Image.asset('assets/icons/ayurveda.png'),
  // ),

  // HealthcareTopList(
  //   title: "Medical History",
  //   gradient: orangeGradient,
  //   function: (BuildContext context) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return const MedicalHistoryScreen();
  //     }));
  //   },
  //   image: Image.asset('assets/icons/health_care.png'),
  // ),

];

class AyurvedaTopList {
  final Image? image;
  final String? title;
  final Gradient? gradient;
  final Function? function;

  const AyurvedaTopList(
      {required this.title,
      required this.gradient,
      required this.function,
      required this.image});
}

List<AyurvedaTopList> ayurvedaTopList = [
  AyurvedaTopList(
    image: Image.asset('assets/icons/heal.png'),
    title: "Consult Ayurveda Doctor",
    gradient: blueGradient,
    function: (context) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const AyurvedaDoctorConsultation();
      }));
    },
  ),
  AyurvedaTopList(
    title: "My Care Plans",
    gradient: orangeGradient,
    function: (BuildContext context) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return const MyCarePlanScreen();
      // }));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return  MyHCSubscriptions();
      }));
    },
    image: Image.asset('assets/icons/my_care.png'),
  ),
  AyurvedaTopList(
    title: "View Plans",
    gradient: blueGradient,
    function: (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BrowseAyurvedaPlans();
      }));
    },
    image: Image.asset('assets/icons/browse_plans.png'),
  ),
  // AyurvedaTopList(
  //   title: "Shop",
  //   gradient: orangeGradient,
  //   function: (BuildContext context) {},
  //   image: Image.asset('assets/icons/shop.png'),
  // ),
];
