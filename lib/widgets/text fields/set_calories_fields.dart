import 'dart:developer';
import 'package:flutter/material.dart';

class HeightTextField extends StatefulWidget {
  final Function(String)? convertedHeight;
  const HeightTextField({this.convertedHeight, Key? key}) : super(key: key);

  @override
  State<HeightTextField> createState() => _HeightTextFieldState();
}

class _HeightTextFieldState extends State<HeightTextField> {
  bool isHeightCm = false;
  String? heightCm;
  String? heightFt;
  String? heightInches;
  double? feetToCm;

  void convFeetToCm() {
    var feet = double.parse(heightFt!) * 30.48;
    var inches = double.parse(heightInches!) * 2.54;
    feetToCm = feet + inches;
    log("$feet ft $inches inches to Cm ===> $feetToCm");
  }

  void getCm(String val) => heightCm = val;
  void getFt(String val) => heightFt = val;
  void getInches(String val) => heightInches = val;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFC3CAD9),
                      ),
                    ),
                    hintText: isHeightCm ? 'Height in Cm' : 'Height in Feet',
                    hintStyle: const TextStyle(
                      color: Color(0xFF959EAD),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onSaved: (value) {
                    if (isHeightCm == true) {
                      getCm(value!);
                      heightCm = value;
                      log("height in cm => ${heightCm!}");
                      setState(() {
                        widget.convertedHeight!(heightCm!);
                      });
                    } else {
                      getFt(value!);
                      convFeetToCm();
                      setState(() {
                        widget.convertedHeight!(feetToCm.toString());
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                ),
              ),
              isHeightCm ? const SizedBox() : const SizedBox(width: 16),
              isHeightCm
                  ? const SizedBox()
                  : Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFC3CAD9),
                            ),
                          ),
                          hintText:
                              isHeightCm ? 'Height in Cm' : 'Height in Inches',
                          hintStyle: const TextStyle(
                            color: Color(0xFF959EAD),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        // onChanged: (value) {
                        //   getInches(value);
                        //   convFeetToCm();
                        // },
                        onSaved: (value) {
                          if (value!.isEmpty) {
                            heightInches = '0.0';
                          }
                          getInches(value);
                          convFeetToCm();
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                isHeightCm = !isHeightCm;
              });
            },
            child: Text(
              isHeightCm ? 'change to ft' : 'change to cm',
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     isHeightCm
          //         ? log('height in cm ===> ' + heightCm.toString() + 'cm')
          //         : log(
          //             "height in feet & inches ===> " +
          //                 heightFt.toString() +
          //                 'ft ' +
          //                 heightInches.toString() +
          //                 'inches',
          //           );
          //     convFeetToCm();
          //   },
          //   child: const Text('calculate'),
          // ),
        ],
      ),
    );
  }
}

// class WeightTextField extends StatefulWidget {
//   final Function(String)? textFieldWeight;
//   const WeightTextField({this.textFieldWeight, Key? key}) : super(key: key);

//   @override
//   State<WeightTextField> createState() => _WeightTextFieldState();
// }

// class _WeightTextFieldState extends State<WeightTextField> {
//   String? weiight;

//   // void getWeight(String val) => weiight = val;
//   void getWeight(String val) {
//     weiight = val;
//     log('text field value of weight' + weiight!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: TextFormField(
//         keyboardType: TextInputType.phone,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(
//               color: Color(0xFFC3CAD9),
//             ),
//           ),
//           hintText: 'Current Weight in Kgs',
//           hintStyle: const TextStyle(
//             color: Color(0xFF959EAD),
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//         onChanged: (value) {
//           getWeight(value);
//         },
//         validator: (value) {
//           return null;
//         },
//       ),
//     );
//   }
// }

// class TargetWeightTextField extends StatefulWidget {
//   final Function(String)? textFieldTargetWeight;
//   const TargetWeightTextField({this.textFieldTargetWeight, Key? key})
//       : super(key: key);

//   @override
//   State<TargetWeightTextField> createState() => _TargetWeightTextFieldState();
// }

// class _TargetWeightTextFieldState extends State<TargetWeightTextField> {
//   String? targettWeight;

//   // void getTargettWeight(String val) => targettWeight = val;

//   void getTargettWeight(String val) {
//     targettWeight = val;
//     log('text field value of target weight' + targettWeight!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: TextFormField(
//         keyboardType: TextInputType.phone,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(
//               color: Color(0xFFC3CAD9),
//             ),
//           ),
//           hintText: 'Target Weight in Kgs',
//           hintStyle: const TextStyle(
//             color: Color(0xFF959EAD),
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//         onChanged: (value) {
//           getTargettWeight(value);
//         },
//         validator: (value) {
//           return null;
//         },
//       ),
//     );
//   }
// }

// class AgeTextField extends StatefulWidget {
//   final Function(String)? textFieldAge;
//   const AgeTextField({this.textFieldAge, Key? key}) : super(key: key);

//   @override
//   State<AgeTextField> createState() => _AgeTextFieldState();
// }

// class _AgeTextFieldState extends State<AgeTextField> {
//   String? agee;

//   // void getAgee(String val) => agee = val;

//   void getAgee(String val) {
//     agee = val;
//     log('text field value of age' + agee!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: TextFormField(
//         keyboardType: TextInputType.phone,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(
//               color: Color(0xFFC3CAD9),
//             ),
//           ),
//           hintText: 'Age in years',
//           hintStyle: const TextStyle(
//             color: Color(0xFF959EAD),
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//         onChanged: (value) {
//           getAgee(value);
//         },
//         validator: (value) {
//           return null;
//         },
//       ),
//     );
//   }
// }

class CaloriesTextField extends StatelessWidget {
  const CaloriesTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          hintText: 'Calories',
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        onSaved: (value) {},
        validator: (value) {
          return null;
        },
      ),
    );
  }
}
