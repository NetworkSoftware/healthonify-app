import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class ExerciseRecordScreen extends StatefulWidget {
  const ExerciseRecordScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseRecordScreen> createState() => _ExerciseRecordScreenState();
}

class _ExerciseRecordScreenState extends State<ExerciseRecordScreen> {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    // Excercise excercise = Excercise();
    // List<Excercise> excercises = [];
    String? dropdownValue;
    List<String> dropDownOptions = [
      'kgs',
      'lbs',
    ];
    // onSubmit() async {
    //   var formState = _key.currentState;
    //   if (formState!.validate()) {
    //     formState.save();

    //     log(excercise.weight.toString());
    //     log(excercise.unit.toString());
    //     log(excercise.reps.toString());
    //     excercises.add(
    //       Excercise(
    //         reps: excercise.reps,
    //         unit: excercise.unit,
    //         weight: excercise.weight,
    //       ),
    //     );
    //   }
    // }

    // void getWeight(String wght) => excercise.weight = wght;
    // void getUnits(String units) => excercise.unit = units;
    // void getReps(String rep) => excercise.reps = rep;
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.lightBlue[100],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Exercise 1',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Card(
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Set'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Weight'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('unit'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Reps'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('+/-'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  children: [
                                    Text('1.'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        constraints: const BoxConstraints(
                                          maxHeight: 36,
                                          maxWidth: 52,
                                        ),
                                        hintText: '0',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF959EAD),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    DropdownButtonFormField(
                                      isDense: true,
                                      items: dropDownOptions
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Colors.grey,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      value: dropdownValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            width: 1.25,
                                          ),
                                        ),
                                        constraints: const BoxConstraints(
                                          maxHeight: 36,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      hint: Text(
                                        'kgs',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        constraints: const BoxConstraints(
                                          maxHeight: 36,
                                          maxWidth: 52,
                                        ),
                                        hintText: '0',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF959EAD),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        log('tapped');
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 26,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Add set'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientButton(
                      title: 'Save Workout',
                      func: () {},
                      gradient: orangeGradient,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class Excercise {
//   String? weight;
//   String? unit;
//   String? reps;

//   Excercise({this.reps, this.unit, this.weight});
// }
