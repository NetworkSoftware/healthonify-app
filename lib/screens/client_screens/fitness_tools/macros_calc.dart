import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/fitness_tools_models/fitness_tools_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/fitness_tools/macro_calc_provider.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MacrosCalculatorScreen extends StatefulWidget {
  const MacrosCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<MacrosCalculatorScreen> createState() => _MacrosCalculatorScreenState();
}

class _MacrosCalculatorScreenState extends State<MacrosCalculatorScreen> {
  TextEditingController calorieController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchDietTypes(context);
  }

  final List _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
  ];
  final List _titles = [
    'Protein',
    'Carbs',
    'Fats',
  ];
  String? dropDownDietId;
  String? dietId;

  String proteinValue = '0.0';
  String carbValue = '0.0';
  String fatValue = '0.0';

  List<DietType> dietTypeData = [];
  List<MacroCalculator> macroDetails = [];

  Future<void> fetchDietTypes(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      dietTypeData =
          await Provider.of<MacroCalculatorProvider>(context, listen: false)
              .getDietTypes();
      log('fetched diet types');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting diet types $e");
      Fluttertoast.showToast(msg: "Unable to fetch diet types");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String calories;
  void getCalories(String value) => calories = value;

  Future<void> calculateMacroData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      macroDetails =
          await Provider.of<MacroCalculatorProvider>(context, listen: false)
              .calculateMacros(dropDownDietId!, calories);

      log('macros calculated');
      log('proteins : ${macroDetails[0].proteinInGrams}');
      log('carbs : ${macroDetails[0].carbInGrams}');
      log('fats : ${macroDetails[0].fatInGrams}');

      setState(() {
        proteinValue = macroDetails[0].proteinInGrams!;
        carbValue = macroDetails[0].carbInGrams!;
        fatValue = macroDetails[0].fatInGrams!;
      });
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error calculating macros $e");
      Fluttertoast.showToast(msg: "Unable to calculate macros");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    calculateMacroData(context);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: const CustomAppBar(appBarTitle: 'Macro Calculator'),
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '$proteinValue gm',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CircleAvatar(
                                                radius: 8,
                                                backgroundColor: _colors[0],
                                              ),
                                              Text(
                                                _titles[0],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '$carbValue gm',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CircleAvatar(
                                                radius: 8,
                                                backgroundColor: _colors[1],
                                              ),
                                              Text(
                                                _titles[1],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '$fatValue gm',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CircleAvatar(
                                                radius: 8,
                                                backgroundColor: _colors[2],
                                              ),
                                              Text(
                                                _titles[2],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              'Diet Type',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: DropdownButtonFormField(
                              items: dietTypeData
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.dietId,
                                  child: Text(value.dietTypeName!),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  log(newValue!);
                                  dropDownDietId = newValue;
                                });
                              },
                              value: dropDownDietId,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.25,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey,
                              ),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(13),
                              elevation: 1,
                              hint: Text(
                                'Select',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                              onSaved: (value) {},
                              validator: (value) {
                                if (value == null) {
                                  return 'Please choose your diet type';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: calorieController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'Enter Calories',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              onChanged: (val) {
                                getCalories(val);
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter the calorie amount';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GradientButton(
                                func: () {
                                  onSubmit();
                                },
                                title: 'Calculate your total calories',
                                gradient: orangeGradient,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RichText(
                              text: TextSpan(
                                text: '',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
