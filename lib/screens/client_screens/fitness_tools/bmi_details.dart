import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/fitness_tools_models/fitness_tools_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_tools_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_results.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_age_card.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_height_card.dart';
import 'package:healthonify_mobile/widgets/cards/bmi_weight_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BmiDetailsScreen extends StatefulWidget {
  bool? isFromMasurementScreen;
  BmiDetailsScreen({
    this.isFromMasurementScreen,
    Key? key,
  }) : super(key: key);

  @override
  State<BmiDetailsScreen> createState() => _BmiDetailsScreenState();
}

class _BmiDetailsScreenState extends State<BmiDetailsScreen> {
  bool _isLoading = false;
  String _unit = "cm";

  final BMIModel bmiData =
      BMIModel(weight: "0", age: "18", gender: "", height: "0", tool: "bmi");

  void calculateBMI(BuildContext context) {
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
    if (bmiData.weight == "0" || bmiData.weight == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your weight');
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
      if (widget.isFromMasurementScreen == true) {
        Navigator.pop(context, data);
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return BmiResults(
            data: data,
            from: "bmi",
          );
        }));
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
              "weight=${bmiData.weight}&height=${bmiData.height}&age=${bmiData.age}&gender=${bmiData.gender}&tool=bmi");
      onSuccess.call(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to get calculate bmi");
    } catch (e) {
      log("Error not able to calculate bmi $e");
      Fluttertoast.showToast(msg: "Unable to get calculate bmi");
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
        appBar: const CustomAppBar(appBarTitle: 'BMI Calculator'),
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
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: BmiHeightCard(
                      getHeight: (value) {
                        log('bmi height value -> $value');
                        setState(() {
                          bmiData.height = value;
                        });
                      },
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
                                calculateBMI(context);
                              },
                              gradient: orangeGradient)
                    ],
                  ),
                ),
                const FitnessToolDescCard(
                  description:
                      '''Body Mass Index (BMI) is a person’s weight in kilograms (or pounds) divided by the square of height in meters (or feet). It is widely used as a general indicator of whether a person has a healthy body weight for their height.  According to the Centers for Disease Control and Prevention (CDC), overweight and Obesity increases the risk of following:
            - High blood pressure
            - Higher levels of LDL cholesterol, which is widely considered "bad cholesterol," lower levels of HDL cholesterol, considered to be good cholesterol in moderation, and high levels of triglycerides
            - Type II diabetes
            - Coronary heart disease
            - Stroke
            - Gallbladder disease''',
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

class FitnessToolDescCard extends StatefulWidget {
  final String description;
  // final Widget? table;
  const FitnessToolDescCard({required this.description, Key? key})
      : super(key: key);

  @override
  State<FitnessToolDescCard> createState() => _FitnessToolDescCardState();
}

class _FitnessToolDescCardState extends State<FitnessToolDescCard> {
  String? initText;
  String? expandedText;
  bool isMore = false;
  bool showImage = false;

  @override
  void initState() {
    super.initState();
    String descp = widget.description;
    if (descp.length > 50) {
      initText = descp.substring(0, 150);
      expandedText = descp.substring(150, descp.length);
    } else {
      initText = descp;
      expandedText = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                text: TextSpan(
                  text: !isMore ? ("${initText!}...") : (initText! + expandedText!),
                  style: Theme.of(context).textTheme.bodySmall,
                  children: <TextSpan>[
                    TextSpan(
                        text: '\n\nSource',
                        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.red),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(Uri.parse("https://www.calculator.net/bmi-calculator.html"))),
                  ],
                ),
              ),
              // Text(
              //   !isMore ? ("${initText!}...") : (initText! + expandedText!),
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
              const SizedBox(height: 10),
              // showImage ? const SizedBox() : widget.table ?? const SizedBox(),
              // !showImage ? const SizedBox() : widget.table!,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isMore = !isMore;
                        if (isMore == true) {
                          showImage = true;
                        } else {
                          showImage = false;
                        }
                      });
                    },
                    child: Text(
                      !isMore ? "show more" : "show less",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: orange,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenderToggle extends StatefulWidget {
  final Function? getGender;
  const GenderToggle({
    Key? key,
    required this.getGender,
  }) : super(key: key);

  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  bool maleCheck = false, femCheck = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        maleCard(),
        femaleCard(),
      ],
    );
  }

  Widget maleCard() => SizedBox(
        // height: 184,
        width: MediaQuery.of(context).size.width * 0.45,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: InkWell(
            onTap: () {
              widget.getGender!("male");
              setState(() {
                maleCheck = true;
                femCheck = false;
              });
            },
            borderRadius: BorderRadius.circular(13),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _maleIcon(),
                  // const SizedBox(height: 8),
                  Text(
                    'Male',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget _maleIcon() {
    return Icon(
      Icons.male,
      size: 50,
      color: maleCheck ? orange : Theme.of(context).textTheme.bodySmall!.color,
    );
  }

  Widget femaleCard() => SizedBox(
        // height: 184,
        width: MediaQuery.of(context).size.width * 0.45,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: InkWell(
            onTap: () {
              widget.getGender!("female");
              setState(() {
                femCheck = true;
                maleCheck = false;
              });
            },
            borderRadius: BorderRadius.circular(13),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _femaleColor(),
                  // const SizedBox(height: 8),
                  Text(
                    'Female',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget _femaleColor() {
    return Icon(
      Icons.female,
      color: femCheck ? orange : Theme.of(context).textTheme.bodySmall!.color,
      size: 50,
    );
  }
}
