import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/batch_providers/batch_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class CreateBatchScreen extends StatefulWidget {
  const CreateBatchScreen({super.key});

  @override
  State<CreateBatchScreen> createState() => _CreateBatchScreenState();
}

class _CreateBatchScreenState extends State<CreateBatchScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();

  String? fromTime;
  String? toTime;

  String? gender;
  List genders = [
    'Male',
    'Female',
    'Unisex',
  ];

  String? batchName;
  String? capacity;
  String? info;
  String? roomName;
  String? service;

  late String expertId;
  @override
  void initState() {
    super.initState();

    expertId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  Map<String, dynamic> batchMap = {};

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    if (fromTime == null || toTime == null) {
      Fluttertoast.showToast(msg: 'Please select batch timings');
      return;
    }
    batchMap['expertId'] = expertId;
    batchMap['name'] = batchName;
    batchMap['capacity'] = int.parse(capacity!);
    batchMap['gender'] = gender;
    batchMap['info'] = info;
    batchMap['roomName'] = roomName;
    batchMap['service'] = service;
    batchMap['days'] = 15;
    batchMap['startTime'] = fromTime;
    batchMap['endTime'] = toTime;
    batchMap['isActive'] = true;

    log(batchMap.toString());
    createBatches(context);
  }

  Future<void> createBatches(BuildContext context) async {
    try {
      await Provider.of<BatchProvider>(context, listen: false)
          .createBatch(batchMap);
      popFunction();
      Fluttertoast.showToast(msg: 'Batch created');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to create batch');
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Create batch'),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: 'Batch name',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      batchName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter batch name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Capacity',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      capacity = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter batch capacity';
                    }
                    if (int.parse(value) > 100) {
                      return 'Please enter a capacity between 1 and 100';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
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
                      return "Please select the batch gender";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: 'Info',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      info = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter batch information';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: 'Room name',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      roomName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter batch room name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: 'Service',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      service = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter batch service name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            timePicker(fromTimeController, true);
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: fromTimeController,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).canvasColor,
                                filled: true,
                                hintText: 'From',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: const Color(0xFF717579),
                                    ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    timePicker(fromTimeController, true);
                                  },
                                  child: Text(
                                    'PICK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                              cursorColor: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            timePicker(toTimeController, false);
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: toTimeController,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).canvasColor,
                                filled: true,
                                hintText: 'To',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: const Color(0xFF717579),
                                    ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    timePicker(toTimeController, false);
                                  },
                                  child: Text(
                                    'PICK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                              cursorColor: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  onSubmit();
                },
                child: const Text('Create Batch'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void timePicker(TextEditingController controller, bool isStartTime) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        controller.text = value.format(context);

        isStartTime
            ? fromTime = "${value.hour}:${value.minute}"
            : toTime = "${value.hour}:${value.minute}";
      });
    });
  }
}
