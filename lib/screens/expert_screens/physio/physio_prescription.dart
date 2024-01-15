import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/store_prescription_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class PhysioPrescriptionScreen extends StatefulWidget {
  final String clientId, consultationId;
  const PhysioPrescriptionScreen({
    super.key,
    required this.clientId,
    required this.consultationId,
  });

  @override
  State<PhysioPrescriptionScreen> createState() =>
      _PhysioPrescriptionScreenState();
}

class _PhysioPrescriptionScreenState extends State<PhysioPrescriptionScreen> {
  final formKey = GlobalKey<FormState>();
  String? gender;
  List genders = [
    'Male',
    'Female',
    'Others',
  ];

  String? thermoTherapy;
  List<String> thermoPhotoTherapy = [];
  String? stimulation;
  List<String> electricalStimulation = [];
  String? therapy;
  List<String> manualTherapy = [];
  String? others;
  List<String> otherPrograms = [];

  bool isAddExercise = false;

  String? name;
  String? locality;
  String? age;
  String? mobileNo;
  String? diagnosis;
  String? treatment;
  String? duration;
  String? precaution;

  Map<String, dynamic> physioPrescription = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    physioPrescription["userId"] = widget.clientId;
    physioPrescription["consultationId"] = widget.consultationId;
    physioPrescription["expertId"] =
        Provider.of<UserData>(context, listen: false).userData.id;
    physioPrescription["name"] = name;
    physioPrescription["locality"] = locality;
    physioPrescription["ageOrSex"] = "$age,$gender";
    physioPrescription["mobileNo"] = mobileNo;
    physioPrescription["diagnosis"] = diagnosis;
    physioPrescription["treatment"] = treatment;
    physioPrescription["duration"] = duration;
    physioPrescription["date"] =
        DateFormat("yyyy-MM-dd").format(DateTime.now());
    physioPrescription["time"] = DateFormat("HH:mm").format(DateTime.now());
    physioPrescription["thermoOrPhotoTherapy"] = thermoPhotoTherapy;
    physioPrescription["electricalStimulation"] = electricalStimulation;
    physioPrescription["manualTherapy"] = manualTherapy;
    physioPrescription["otherPrograms"] = otherPrograms;
    physioPrescription["therapueticExercises"] = therapeuticExercises;
    physioPrescription["precautions"] = precaution;

    //! uncomment below function call to call api !//
    uploadPrescription();
  }

  Future<void> uploadPrescription() async {
    LoadingDialog().onLoadingDialog("Please wait", context);
    try {
      await Provider.of<StorePrescriptionProvider>(context, listen: false)
          .storePhysioPrescription(physioPrescription);

      popFunction();
      Fluttertoast.showToast(msg: 'Prescription added succesfully');
    } on HttpException catch (e) {
      log("Unable to post prescription: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error posting prescription: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      Navigator.pop(context);
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Physio Prescription'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Client name',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter client's name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Client mobile number',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    mobileNo = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter client's mobile number";
                  }
                  if (value.length != 10) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Locality',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    locality = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter client's locality";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                keyboard: TextInputType.phone,
                hint: 'Age',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    age = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter client's age";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: genders.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: Theme.of(context).textTheme.bodyMedium),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue!;
                    });
                  },
                  value: gender,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Gender',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please select the client's gender";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Diagnosis',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    diagnosis = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the diagnosis";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Treatment',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    treatment = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the treatment";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Duration in days',
                hintBorderColor: Colors.grey,
                keyboard: TextInputType.number,
                onSaved: (value) {
                  duration = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the treatment duration";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hint: 'Thermo or Photo Therapy (Optional)',
                hintBorderColor: Colors.grey,
                suffixIcon: TextButton(
                  onPressed: () {
                    thermoTherapy!.isNotEmpty
                        ? setState(() {
                            thermoPhotoTherapy.add(thermoTherapy!);
                          })
                        : null;
                  },
                  child: const Text('Add'),
                ),
                onChanged: (value) {
                  setState(() {
                    thermoTherapy = value;
                  });
                },
              ),
              thermoPhotoTherapy.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: textBuilder(thermoPhotoTherapy),
                    )
                  : const SizedBox(),
              const SizedBox(height: 30),
              CustomTextField(
                hint: 'Electrical Stimulation (Optional)',
                hintBorderColor: Colors.grey,
                suffixIcon: TextButton(
                  onPressed: () {
                    stimulation!.isNotEmpty
                        ? setState(() {
                            electricalStimulation.add(stimulation!);
                          })
                        : null;
                  },
                  child: const Text('Add'),
                ),
                onChanged: (value) {
                  setState(() {
                    stimulation = value;
                  });
                },
              ),
              electricalStimulation.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: textBuilder(electricalStimulation),
                    )
                  : const SizedBox(),
              const SizedBox(height: 30),
              CustomTextField(
                hint: 'Manual Therapy (Optional)',
                hintBorderColor: Colors.grey,
                suffixIcon: TextButton(
                  onPressed: () {
                    therapy!.isNotEmpty
                        ? setState(() {
                            manualTherapy.add(therapy!);
                          })
                        : null;
                  },
                  child: const Text('Add'),
                ),
                onChanged: (value) {
                  setState(() {
                    therapy = value;
                  });
                },
              ),
              manualTherapy.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: textBuilder(manualTherapy),
                    )
                  : const SizedBox(),
              const SizedBox(height: 30),
              CustomTextField(
                hint: 'Other Programs (Optional)',
                hintBorderColor: Colors.grey,
                suffixIcon: TextButton(
                  onPressed: () {
                    others!.isNotEmpty
                        ? setState(() {
                            otherPrograms.add(others!);
                          })
                        : null;
                  },
                  child: const Text('Add'),
                ),
                onChanged: (value) {
                  setState(() {
                    others = value;
                  });
                },
              ),
              otherPrograms.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: textBuilder(otherPrograms),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Precautions',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  precaution = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter precautions for the client";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Therapeutic Exercises'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isAddExercise = true;
                        });
                      },
                      child: const Text('Add exercise'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              isAddExercise ? exerciseCard() : const SizedBox(),
              therapeuticExercises.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: therapeuticExercises.length,
                      itemBuilder: (context, index) {
                        return addedExerciseCard(therapeuticExercises[index]);
                      },
                    )
                  : const SizedBox(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onSubmit();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Add Prescription'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget textBuilder(List list) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      list[index],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          list.remove(list[index]);
                        });
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: whiteColor,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List therapeuticExercises = [];
  String? romExercise;
  String? strengthening;

  Widget exerciseCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CustomTextField(
              hint: 'Exercise Name',
              hintBorderColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  romExercise = value;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: 'Strengthening',
              hintBorderColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  strengthening = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isAddExercise = false;
                    });
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      therapeuticExercises.add(
                        {
                          "romExercises": romExercise,
                          "strengthening": strengthening,
                        },
                      );
                    });
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget addedExerciseCard(Map<String, dynamic> medicineData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Exercises : ",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  medicineData['romExercises'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Strengthening : ",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  medicineData['strengthening'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      therapeuticExercises.remove(medicineData);
                    });
                  },
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
