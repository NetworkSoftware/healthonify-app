import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/fitness_tools_models/fitness_tools_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_tools_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_details.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_results.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_age_card.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_height_card.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_weight_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class BMRScreen extends StatefulWidget {
  final bool? isFromMeasurementScreen;
  const BMRScreen({Key? key, this.isFromMeasurementScreen}) : super(key: key);

  @override
  State<BMRScreen> createState() => _BMRScreenState();
}

class _BMRScreenState extends State<BMRScreen> {
  bool _isLoading = false;
  final BMIModel bmiData =
      BMIModel(weight: "0", age: "18", gender: "", height: "0");
  String _unit = "cm";

  void calculateBMR(BuildContext context) {
    if (bmiData.gender!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a gender");
      return;
    }
    if (bmiData.height == "0" || bmiData.height == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your height');
      return;
    }
    if (bmiData.weight == "0" || bmiData.weight == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your weight');
      return;
    }
    if (double.parse(bmiData.height!) > 250) {
      Fluttertoast.showToast(msg: 'Please enter a valid height');
      return;
    }
    if (double.parse(bmiData.weight!) > 200) {
      Fluttertoast.showToast(msg: 'Please enter a valid weight');
      return;
    }
    if (double.parse(bmiData.age!) > 130) {
      Fluttertoast.showToast(msg: 'Please enter a valid age');
      return;
    }

    calulate(context, (Map<String, dynamic> data) {
      if (widget.isFromMeasurementScreen == true) {
        Navigator.pop(context, data);
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BmiResults(
                  data: data,
                  from: "bmr",
                )));
      }
    });
  }

  Future<void> calulate(BuildContext context,
      Function(Map<String, dynamic> data) onSuccess) async {
    setState(() {
      _isLoading = true;
    });
    if (_unit == "ft") {
      bmiData.height = (double.parse(bmiData.height!) * 30.48).toString();
    }
    try {
      var data = await Provider.of<FitnessToolsData>(context, listen: false)
          .calculateTool(
        "weight=${bmiData.weight}&height=${bmiData.height}&age=${bmiData.age}&gender=${bmiData.gender}&tool=bmr",
      );
      onSuccess.call(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to get calculate bmr");
    } catch (e) {
      log("Error not able to calculate bmr $e");
      Fluttertoast.showToast(msg: "Unable to get calculate bmr");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const CustomAppBar(appBarTitle: 'BMR Calculator'),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: GenderToggle(
                        getGender: (value) => {bmiData.gender = value})),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: BmiHeightCard(
                      getHeight: (value) => {bmiData.height = value},
                      getUnit: (value) {
                        _unit = value;
                        // log(_unit);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: BmiWeightCard(
                    getWeight: (value) => {bmiData.weight = value},
                    getUnit: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: BmiAgeCard(
                    getAge: (value) => {bmiData.age = value},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // NextButton1(),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GradientButton(
                              title: "Calculate",
                              func: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                calculateBMR(context);
                              },
                              gradient: orangeGradient)
                    ],
                  ),
                ),
                const FitnessToolDescCard(
                  description:
                      '''The Basal Metabolic Rate (BMR) Calculator estimates your basal metabolic rate—the amount of energy expended while at rest in a neutrally temperate environment, and in a post-absorptive state (meaning that the digestive system is inactive, which requires about 12 hours of fasting).''',
                  // table: SizedBox(),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
