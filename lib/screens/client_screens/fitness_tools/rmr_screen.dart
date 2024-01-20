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

class RMRscreen extends StatefulWidget {
  const RMRscreen({Key? key}) : super(key: key);

  @override
  State<RMRscreen> createState() => _RMRscreenState();
}

class _RMRscreenState extends State<RMRscreen> {
  bool _isLoading = false;
  String _unit = "cm";

  final BMIModel bmiData =
      BMIModel(weight: "0", age: "18", gender: "", height: "0", tool: "rmr");

  void calculateRMR(BuildContext context) {
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

    calulate(
        context,
        (Map<String, dynamic> data) =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BmiResults(
                      data: data,
                      from: "rmr",
                    ))));
  }

  Future<void> calulate(
      BuildContext context, Function(Map<String, dynamic>) onSuccess) async {
    setState(() {
      _isLoading = true;
    });

    if (_unit == "ft") {
      bmiData.height = (double.parse(bmiData.height!) * 30.48).toString();
    }

    try {
      var data = await Provider.of<FitnessToolsData>(context, listen: false)
          .calculateTool(
              "weight=${bmiData.weight}&height=${bmiData.height}&age=${bmiData.age}&gender=${bmiData.gender}&tool=rmr");
      onSuccess.call(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to get calculate rmr");
    } catch (e) {
      log("Error not able to calculate rmr $e");
      Fluttertoast.showToast(msg: "Unable to get calculate rmr");
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
        appBar: const CustomAppBar(appBarTitle: 'RMR Caculator'),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Text(
                //   'RMR Calculator',
                //   style: Theme.of(context).textTheme.displayLarge,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: GenderToggle(
                      getGender: (value) => {bmiData.gender = value}),
                ),
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
                                calculateRMR(context);
                              },
                              gradient: orangeGradient)
                    ],
                  ),
                ),
                const FitnessToolDescCard(
                  description:
                      '''RMR is the abbreviation of resting metabolic rate. This parameter tells how many calories are required by your body to perform the most basic functions (to keep itself alive) while resting. These essential functions are e.g., breathing, heart beating, blood circulation, food digestion, functioning of vital organs etc.

Multiply RMR result by scale factor for activity level:
Sedentary *1.2
Lightly active *1.375
Moderately active *1.55
Active *1.725
Very active *1.9


To lose weight, try to eat slightly more than your RMR. This is the minimum calories you need per day to survive, so your body will get the rest from its stored energy sources, e.g. fat. However please consult your doctor before beginning any serious diet change, and stop if you begin to feel any pain.
                      ''',
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

// class GenderToggle extends StatefulWidget {
//   const GenderToggle({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<GenderToggle> createState() => _GenderToggleState();
// }

// class _GenderToggleState extends State<GenderToggle> {
//   bool maleCheck = false, femCheck = false;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         maleCard(),
//         femaleCard(),
//       ],
//     );
//   }

//   Widget maleCard() => SizedBox(
//         height: 184,
//         width: MediaQuery.of(context).size.width * 0.45,
//         child: Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(13),
//           ),
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 maleCheck = true;
//                 femCheck = false;
//               });
//               // toggle();
//               // setState(() {
//               //   // widget.maleBool = true;
//               //   widget.maleBool
//               // ? widget.iconColor = Colors.orange
//               // : widget.iconColor = Colors.black;
//               // });
//               // widget.gToggle(true, false);
//             },
//             borderRadius: BorderRadius.circular(13),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _maleIcon(),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Male',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//   Widget _maleIcon() {
//     return Icon(
//       Icons.male,
//       size: 74,
//       color: maleCheck ? Colors.orange : Colors.black,
//     );
//   }

//   Widget femaleCard() => SizedBox(
//         height: 184,
//         width: MediaQuery.of(context).size.width * 0.45,
//         child: Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(13),
//           ),
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 femCheck = true;

//                 maleCheck = false;
//               });
//               // toggle();
//               // setState(() {
//               //   // widget.femBool = true;
//               //   widget.femBool
//               //       ? widget.iconColor = Colors.orange
//               //       : widget.iconColor = Colors.black;
//               // });
//               // widget.gToggle(false, true);
//             },
//             borderRadius: BorderRadius.circular(13),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _femaleColor(),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Female',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 )
//               ],
//             ),
//           ),
//         ),
//       );

//   Widget _femaleColor() {
//     return Icon(
//       Icons.female,
//       color: femCheck ? Colors.orange : Colors.black,
//       size: 74,
//     );
//   }
// }
