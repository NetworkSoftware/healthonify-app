import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/fitness_tools_models/fitness_tools_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_tools_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_details.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_results.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_age_card.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_height_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class IdealWeightScreen extends StatefulWidget {
  const IdealWeightScreen({Key? key}) : super(key: key);

  @override
  State<IdealWeightScreen> createState() => _IdealWeightScreenState();
}

class _IdealWeightScreenState extends State<IdealWeightScreen> {
  bool _isLoading = false;
  String _unit = "cm";

  final BMIModel bmiData = BMIModel(
      weight: "0", age: "18", gender: "", height: "0", tool: "idealWeight");

  void calculateIdealWeight(BuildContext context) {
    if (bmiData.gender!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a gender");
      return;
    }
    if (bmiData.height == "0" || bmiData.height == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your height');
      return;
    }
    if (double.parse(bmiData.height!) > 250) {
      Fluttertoast.showToast(msg: 'Please enter a valid height');
      return;
    }
    if (double.parse(bmiData.age!) > 130) {
      Fluttertoast.showToast(msg: 'Please enter a valid age');
      return;
    }
    // if (bmiData.weight == "0" || bmiData.weight == "0.0") {
    //   Fluttertoast.showToast(msg: 'Please enter your weight');
    //   return;
    // }

    calulate(
        context,
        (Map<String, dynamic> data) =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BmiResults(
                      data: data,
                      from: "idealW",
                    ))));
  }

  Future<void> calulate(
      BuildContext context, Function(Map<String, dynamic>) onSuccess) async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    setState(() {
      _isLoading = true;
    });
    if (_unit == "ft") {
      bmiData.height = (double.parse(bmiData.height!) * 30.48).toString();
    }
    try {
      var data = await Provider.of<FitnessToolsData>(context, listen: false)
          .calculateTool(
              "height=${bmiData.height}&age=${bmiData.age}&gender=${bmiData.gender}&tool=idealWeight&userId=$userId");
      onSuccess.call(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to get calculate ideal weight");
    } catch (e) {
      log("Error not able to calculate ideal weight $e");
      Fluttertoast.showToast(msg: "Unable to get calculate ideal weight");
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
        appBar: const CustomAppBar(appBarTitle: 'Ideal Weight Calculator'),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: GenderToggle(
                      getGender: (value) => {bmiData.gender = value}),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
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
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // BmiWeightCard(
                      //   getWeight: (value) => {bmiData.weight = value},
                      // ),
                      BmiAgeCard(
                        getAge: (value) => {bmiData.age = value},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GradientButton(
                              title: "Calculate",
                              func: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                calculateIdealWeight(context);
                              },
                              gradient: orangeGradient)
                    ],
                  ),
                ),
                const FitnessToolDescCard(
                  description:
                      '''The Ideal Weight Calculator computes ideal body weight (IBW) ranges based on height, gender, and age. Knowing your ideal body weight is the first significant step you can take to be healthy. Obesity and being overweight is responsible for the majority of the lifestyle diseases. These include heart disease, stroke, diabetes, obesity, metabolic syndrome, chronic obstructive pulmonary disease, and some types of cancer.''',
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
