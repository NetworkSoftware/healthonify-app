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

class BodyFatScreen extends StatefulWidget {
  const BodyFatScreen({Key? key}) : super(key: key);

  @override
  State<BodyFatScreen> createState() => _BodyFatScreenState();
}

class _BodyFatScreenState extends State<BodyFatScreen> {
  bool _isLoading = false;
  bool _showHips = false;
  String _unit = "cm";

  final BMIModel bmiData = BMIModel(
    weight: "0",
    age: "18",
    gender: "",
    height: "0",
    tool: "bfp",
    neck: "0",
    waist: "0",
    hips: "0",
  );

  void calculateBMI(BuildContext context) {
    if (bmiData.gender!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a gender");
      return;
    }
    if (bmiData.gender == 'female') {
      if (bmiData.hips == '0' || bmiData.hips == "0.0") {
        Fluttertoast.showToast(msg: 'Please enter your hip measurement');
        return;
      }
    }
    if (bmiData.height == "0" || bmiData.height == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your height');
      return;
    }
    if (bmiData.weight == "0" || bmiData.weight == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your weight');
      return;
    }
    if (bmiData.neck == "0" || bmiData.neck == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your neck measurement');
      return;
    }
    if (bmiData.waist == "0" || bmiData.waist == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your waist measurement');
      return;
    }
    if (bmiData.age == "0" || bmiData.age == "0.0") {
      Fluttertoast.showToast(msg: 'Please enter your age');
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
    if (double.parse(bmiData.waist!) > 200) {
      Fluttertoast.showToast(msg: 'Please enter a valid waist measurement');
      return;
    }
    if (double.parse(bmiData.neck!) > 92) {
      Fluttertoast.showToast(msg: 'Please enter a valid neck measurement');
      return;
    }
    if (double.parse(bmiData.age!) > 130) {
      Fluttertoast.showToast(msg: 'Please enter a valid age');
      return;
    }

    // log('gender -> ${bmiData.gender}');
    // log('height -> ${bmiData.height}');
    // log('weight -> ${bmiData.weight}');
    // log('age -> ${bmiData.age}');
    // log('neck -> ${bmiData.neck}');
    // log('waist -> ${bmiData.waist}');
    // bmiData.gender == 'female' ? log('hips -> ${bmiData.hips}') : null;

    calulate(context, (Map<String, dynamic> data) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return BmiResults(
          data: data,
          from: "bfp",
        );
      }));
    });
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
      String urlData;
      if (_showHips == true) {
        urlData =
            "weight=${bmiData.weight}&height=${bmiData.height}&age=${bmiData.age}&gender=${bmiData.gender}&neck=${bmiData.neck}&waist=${bmiData.waist}&tool=bfp&hip=${bmiData.hips}";
      } else {
        urlData =
            "weight=${bmiData.weight}&height=${bmiData.height}&age=${bmiData.age}&gender=${bmiData.gender}&neck=${bmiData.neck}&waist=${bmiData.waist}&tool=bfp";
      }
      var data = await Provider.of<FitnessToolsData>(context, listen: false)
          .calculateTool(urlData);
      onSuccess.call(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to get calculate body fat");
    } catch (e) {
      log("Error not able to calculate body fat $e");
      Fluttertoast.showToast(msg: "Unable to get calculate body fat");
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
        appBar: const CustomAppBar(appBarTitle: 'Body Fat Calculator'),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 6),
                GenderToggle(getGender: (value) {
                  bmiData.gender = value;
                  if (value == "male") {
                    setState(() {
                      _showHips = false;
                    });
                  } else {
                    setState(() {
                      _showHips = true;
                    });
                  }
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BmiHeightCard(
                        getHeight: (value) => {bmiData.height = value},
                        getUnit: (value) {
                          _unit = value;
                          // log(_unit);
                        },
                      ),
                    ],
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
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: NeckWaistCard(
                    cardName: 'Neck',
                    getValue: (value) => {bmiData.neck = value},
                    size: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: NeckWaistCard(
                    cardName: 'Waist',
                    getValue: (value) => {bmiData.waist = value},
                    size: 0,
                  ),
                ),
                if (_showHips)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: NeckWaistCard(
                      cardName: 'Hips in cm',
                      getValue: (value) => {bmiData.hips = value},
                      size: 40,
                    ),
                  ),
                const SizedBox(height: 6),
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
                      '''The Body Fat Calculator can be used to estimate your total body fat based on specific measurements by the American Council on Exercise Body Fat Categorization.''',
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

Widget bodyFatTable(context) {
  var tableTextStyle = Theme.of(context).textTheme.bodySmall;
  return Column(
    children: [
      Table(
        border: TableBorder.all(
          color: Theme.of(context).textTheme.bodySmall!.color!,
        ),
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Description', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Women', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Men', style: tableTextStyle),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Essential Fat', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('10-13%', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('2-5%', style: tableTextStyle),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Atheletes', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('14-20%', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('6-13%', style: tableTextStyle),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Fitness', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('21-24%', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('14-17%', style: tableTextStyle),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Average', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('25-31%', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('18-24%', style: tableTextStyle),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Obese', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('32% +', style: tableTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('25% +', style: tableTextStyle),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class NeckWaistCard extends StatefulWidget {
  final Function? getValue;
  final String? cardName;
  final double? size;
  const NeckWaistCard(
      {required this.cardName,
      Key? key,
      required this.getValue,
      required this.size})
      : super(key: key);

  @override
  State<NeckWaistCard> createState() => _NeckWaistCardState();
}

class _NeckWaistCardState extends State<NeckWaistCard> {
  TextEditingController wieghtController = TextEditingController();
  double size = 35;
  @override
  void initState() {
    super.initState();
    size = widget.size!;
  }

  final List<bool> _selections = [
    true,
    false,
  ];
  String _selected = "cm";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.cardName!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ToggleButtons(
                      isSelected: _selections,
                      constraints: const BoxConstraints(
                        minWidth: 46,
                        maxWidth: 56,
                        maxHeight: 64,
                        minHeight: 28,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      fillColor: const Color(0xFFff7f3f),
                      color: Colors.teal,
                      onPressed: (int index) {
                        wieghtController.text = "";
                        wieghtController.selection = TextSelection.collapsed(
                            offset: wieghtController.text.length);

                        // widget.getWeight('0');
                        if (index == 0) {
                          _selected = "cm";
                        } else {
                          _selected = "inch";
                        }

                        log(_selected);
                        // widget.getUnit!("kgs");

                        setState(
                          () {
                            for (int buttonIndex = 0;
                                buttonIndex < _selections.length;
                                buttonIndex++) {
                              _selections[buttonIndex] = buttonIndex == index;
                            }
                          },
                        );
                      },
                      children: const [
                        Text(
                          'Cm',
                        ),
                        Text(
                          'Inch',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: wieghtController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  filled: true,
                  hintText: '0',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none),
              style: Theme.of(context).textTheme.titleMedium,
              onChanged: (value) {
                if (value.isEmpty) {
                  widget.getValue!("0.0");
                  size = double.parse("0");
                  return;
                }
                if (_selected == 'cm') {
                  // widget.getValue!(value);
                  size = double.parse(value);
                  widget.getValue!(size.toString());
                  log('value in cms -> $size');
                }
                if (_selected == 'inch') {
                  // widget.getValue!(value);
                  size = double.parse(value) * 2.54;
                  widget.getValue!(size.toString());
                  log('value from inches to cms -> $size');
                }
                // widget.getValue!(value);
                // size = double.parse(value);
              },
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         if (size <= 0) {
            //           return;
            //         }
            //         setState(() {
            //           size--;
            //         });
            //         widget.getValue!(size.toString());
            //         wieghtController.value = TextEditingValue(text: '$size');
            //       },
            //       child: const Icon(
            //         Icons.remove_circle,
            //         size: 42,
            //         color: Color(0xFF717579),
            //       ),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     const SizedBox(width: 25),
            //     InkWell(
            //       onTap: () {
            //         setState(() {
            //           size++;
            //         });
            //         widget.getValue!(size.toString());
            //         wieghtController.value = TextEditingValue(text: '$size');
            //       },
            //       child: const Icon(
            //         Icons.add_circle,
            //         size: 42,
            //         color: Color(0xFF717579),
            //       ),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
