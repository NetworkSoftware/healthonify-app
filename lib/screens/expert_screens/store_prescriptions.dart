import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/store_prescription_provider.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StorePrescriptionScreen extends StatefulWidget {
  final String expertId;
  final String consultationId;
  final String userId;
  final String ticketNumber;
  const StorePrescriptionScreen({
    required this.consultationId,
    required this.expertId,
    required this.userId,
    required this.ticketNumber,
    super.key,
  });

  @override
  State<StorePrescriptionScreen> createState() =>
      _StorePrescriptionScreenState();
}

class _StorePrescriptionScreenState extends State<StorePrescriptionScreen> {
  final formKey = GlobalKey<FormState>();

  String? gender;
  List genders = [
    'Male',
    'Female',
    'Others',
  ];

  String? clientName;
  String? clientAge;
  String? referredBy;
  String? address;
  String? weight;
  String? height;
  String? bloodPressure;
  String? complaints;
  String? findings;
  String? notes;
  String? procedures;
  String? advices;

  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  bool isAddMedicine = false;

  List<String> investigations = [];
  List<String> knownHistory = [];
  List<String> diagnosis = [];

  String? investigation;
  String? history;
  String? diagnose;

  List medicines = [];

  Map<String, dynamic> prescriptionData = {
    "isActive": true,
  };

  Future<void> uploadPrescription() async {
    LoadingDialog().onLoadingDialog("Please wait", context);
    try {
      await Provider.of<StorePrescriptionProvider>(context, listen: false)
          .storePrescription(prescriptionData);

      Fluttertoast.showToast(msg: 'Prescription added succesfully');
    } on HttpException catch (e) {
      log("Unable to post prescription: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error posting prescription: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      Navigator.pop(context,true);
      Navigator.pop(context,true);
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    prescriptionData['expertId'] = widget.expertId;
    prescriptionData['userId'] = widget.userId;
    prescriptionData['hcConsultationId'] = widget.consultationId;
    prescriptionData['ticketNumber'] = widget.ticketNumber;

    prescriptionData['name'] = clientName;
    prescriptionData['age'] = int.parse(clientAge!);
    prescriptionData['gender'] = gender;
    prescriptionData['referredBy'] = referredBy;
    prescriptionData['address'] = address;
    prescriptionData['weight'] = weight;
    prescriptionData['height'] = height;
    prescriptionData['bloodPressure'] = bloodPressure;
    prescriptionData['date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    prescriptionData['time'] = DateFormat('HH:mm').format(DateTime.now());
    prescriptionData['followUpDate'] =
        DateFormat('yyyy-MM-dd').format(selectedDate!);
    prescriptionData['chiefComplaints'] = complaints;
    prescriptionData['chiefFindings'] = findings;
    if (notes!.isNotEmpty) {
      prescriptionData['notes'] = notes;
    }
    if (procedures!.isNotEmpty) {
      prescriptionData['proceduresConducted'] = procedures;
    }
    prescriptionData['investigations'] = investigations;
    prescriptionData['knownHistory'] = knownHistory;
    prescriptionData['diagnosis'] = diagnosis;
    prescriptionData['advices'] = advices;
    prescriptionData['medicines'] = medicines;
    prescriptionData['reportType'] = "hcPrescription";
    prescriptionData['reportName'] = widget.consultationId;

    log(prescriptionData.toString());
    uploadPrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Store Prescription'),
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
                    clientName = value;
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
                keyboard: TextInputType.phone,
                hint: 'Age',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    clientAge = value;
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
                hint: 'Referred by',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    referredBy = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter referral's name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Address',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    address = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the client's address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Weight',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    weight = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter client's weight";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Height',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    height = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter client's height";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Blood Pressure (Optional)',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    bloodPressure = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => datePicker(),
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: dateController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).canvasColor,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: grey,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: orange,
                          ),
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            datePicker();
                          },
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: orange,
                            size: 28,
                          ),
                        ),
                        hintText: "Choose follow up date",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onSaved: (value) {
                        log(selectedDate.toString());
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose your follow up date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Complaints',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    complaints = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter any complaints";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Findings',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    findings = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the appointment's findings";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Notes (Optional)',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    notes = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Procedures conducted (Optional)',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    procedures = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hint: 'Investigations (Optional)',
                hintBorderColor: Colors.grey,
                suffixIcon: TextButton(
                  onPressed: () {
                    setState(() {
                      investigations.add(investigation!);
                    });
                  },
                  child: const Text('Add'),
                ),
                onChanged: (value) {
                  setState(() {
                    investigation = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              investigations.isNotEmpty
                  ? textBuilder(investigations)
                  : const SizedBox(),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Known History (Optional)',
                hintBorderColor: Colors.grey,
                suffixIcon: TextButton(
                  onPressed: () {
                    setState(() {
                      knownHistory.add(history!);
                    });
                  },
                  child: const Text('Add'),
                ),
                onChanged: (value) {
                  setState(() {
                    history = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              knownHistory.isNotEmpty
                  ? textBuilder(knownHistory)
                  : const SizedBox(),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Diagnosis (Optional)',
                hintBorderColor: Colors.grey,
                suffixIcon: TextButton(
                  onPressed: () {
                    setState(() {
                      diagnosis.add(diagnose!);
                    });
                  },
                  child: const Text('Add'),
                ),
                onChanged: (value) {
                  setState(() {
                    diagnose = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              diagnosis.isNotEmpty ? textBuilder(diagnosis) : const SizedBox(),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Advices',
                hintBorderColor: Colors.grey,
                onSaved: (value) {
                  setState(() {
                    advices = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter advices for the client";
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
                    const Text('Medicines'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isAddMedicine = true;
                        });
                      },
                      child: const Text('Add medicine'),
                    ),
                  ],
                ),
              ),
              isAddMedicine ? medicineCard() : const SizedBox(),
              medicines.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        return addedMedicineCard(medicines[index]);
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 30),
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

  void datePicker() {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        log(value.toString());
        selectedDate = value;
        dateController.text = DateFormat('dd MMMM yyyy').format(selectedDate!);
      });
    });
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

  Widget addedMedicineCard(Map<String, dynamic> medicineData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  medicineData['medicineName'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  "${medicineData['count']} tablets for ${medicineData['duration']}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              medicineData['description'],
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      medicines.remove(medicineData);
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

  String? medicineName;
  String? medicineDosage;
  String? medicineDescription;
  String? medicineDuration;
  String? noOfTablets;

  Widget medicineCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CustomTextField(
              hint: 'Name',
              hintBorderColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  medicineName = value;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: 'Dosage',
              hintBorderColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  medicineDosage = value;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: 'Description',
              hintBorderColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  medicineDescription = value;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: 'Duration',
              hintBorderColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  medicineDuration = value;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              keyboard: TextInputType.phone,
              hint: 'No. of tablets',
              hintBorderColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  noOfTablets = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isAddMedicine = false;
                    });
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      medicines.add(
                        {
                          "medicineName": medicineName,
                          "dosage": medicineDosage,
                          "description": medicineDescription,
                          "duration": medicineDuration,
                          "count": noOfTablets,
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
}
