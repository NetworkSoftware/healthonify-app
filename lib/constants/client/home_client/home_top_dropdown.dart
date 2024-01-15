import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Category {
  int id;
  String title;
  Image image;
  final Function? function;

  Category(
      {required this.id,
      required this.title,
      required this.image,
      required this.function});
}

List<Category> homeTopList = [
  Category(
    id: 1,
    title: "Health Care",
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return  HealthCareScreen(category: 1);
      }));
    },
    image: Image.asset('assets/icons/health_care.png',height: 30,width: 30,),
  ),
  Category(
    id: 2,
    title: "Manage Weight",
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return  ManageWeightScreen(category: 2);
      }));
    },
    image: Image.asset('assets/icons/weigh_machine.png',height: 30,width: 30,),
  ),
  Category(
    id: 3,
    image: Image.asset('assets/icons/weight.png',height: 30,width: 30,),
    title: "Fitness",
    function: (context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return  FitnessScreen(category: 3);
      }));
    },
  ),
  Category(
    id: 4,
    title: "Physiotherapy",
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return PhysiotherapyScreen(category: 4);
      }));
    },
    image: Image.asset('assets/icons/physio.png',height: 30,width: 30,),
  ),
  Category(
    id: 5,
    title: "Consult Experts",
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return  ConsultExpertsScreen(category: 5);
      }));
    },
    image: Image.asset('assets/icons/badge.png',height: 30,width: 30,),
  ),
  Category(
    id: 6,
    title: "Live Well",
    function: (BuildContext context) {
      Navigator.of(
        context, /*rootnavigator: true*/
      ).push(MaterialPageRoute(builder: (context) {
        return  LiveWellScreen(category: 6);
      }));
    },
    image: Image.asset('assets/icons/live_well.png',height: 30,width: 30,),
  ),
  Category(
    id: 7,
    title: "Ayurveda",
    function: (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AyurvedaScreen(category: 7);
          },
        ),
      );
    },
    image: Image.asset('assets/icons/ayurveda.png',height: 30,width: 30,),
  ),
  Category(
    id: 8,
    title: "Shop",
    function: (BuildContext context) {
      // Navigator.of(
      //   context, /*rootnavigator: true*/
      // ).push(MaterialPageRoute(builder: (context) {
      //   return
      // }));
      launchUrl(Uri.parse("https://healthonify.com/Shop"));
    },
    image: Image.asset('assets/icons/shop.png',height: 30,width: 30,),
  ),
];
