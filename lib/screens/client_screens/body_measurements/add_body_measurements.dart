import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/body_measurements_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_details.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmr_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBodyMeasurementsScreen extends StatefulWidget {
  const AddBodyMeasurementsScreen({super.key});

  @override
  State<AddBodyMeasurementsScreen> createState() =>
      _AddBodyMeasurementsScreenState();
}

class _AddBodyMeasurementsScreenState extends State<AddBodyMeasurementsScreen> {
  final formKey = GlobalKey<FormState>();
  bool? isloading;

  TextEditingController dateController = TextEditingController();
  TextEditingController bmiCotroller = TextEditingController();
  TextEditingController bmrCotroller = TextEditingController();
  String? note;
  String? feetHeight;
  String? inchesHeight;
  int? weightKg;
  int? heartRate;
  int? bodyFat;
  String? bloodPressure;
  int? bmi;
  int? bmr;
  int? visceralFat;
  int? subCutaneous;
  int? bodyMetabolicAge;
  int? muscleMass;
  int? bust;
  int? chest;
  int? waist;
  int? hips;
  int? midway;
  int? thighs;
  int? knees;
  int? calves;
  int? upperArms;
  int? foreArms;
  int? neck;
  int? shoulder;
  int? wrist;
  int? upperAbdomen;
  int? lowerAbdomen;

  int? totalHeight;

  late String userId;
  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  Map<String, dynamic> bodyMeasurementData = {
    "measurements": {
      "measurementUnits": "centimeters",
    }
  };

  Future<void> postBodyMeasurements(BuildContext context) async {
    setState(() {
      isloading = true;
    });
    try {
      await Provider.of<BodyMeasurementsProvider>(context, listen: false)
          .updateBodyMeasurements(bodyMeasurementData);
      popFunction();
      Fluttertoast.showToast(msg: 'Body Measurements updated');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to update body measurements');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  void onSubmit(context) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    if (frontImage == null || sideImage == null || backImage == null) {
      if (frontImage == null) {
        Fluttertoast.showToast(msg: 'Please upload front image');
      }
      if (sideImage == null) {
        Fluttertoast.showToast(msg: 'Please upload side image');
      }
      if (backImage == null) {
        Fluttertoast.showToast(msg: 'Please upload back image');
      }
    } else {
      double feetCms = int.parse(feetHeight ?? "0") * 30.48;
      double inchesCms = int.parse(inchesHeight ?? "0") * 2.54;

      double tHeight = feetCms + inchesCms;
      totalHeight = tHeight.round();
      // log('total height in cms: $totalHeight');

      bodyMeasurementData['userId'] = userId;
      bodyMeasurementData['date'] = ymdFormat;
      bodyMeasurementData['mediaLinks'] = imageData;
      bodyMeasurementData['note'] = note;
      bodyMeasurementData['totalheight'] = totalHeight;
      bodyMeasurementData['weightInKg'] = weightKg;
      bodyMeasurementData['heartRate'] = heartRate;
      bodyMeasurementData['bodyFat'] = bodyFat;
      bodyMeasurementData['bloodPressure'] = bloodPressure;
      bodyMeasurementData['bmi'] = bmi ?? bmiCotroller;
      bodyMeasurementData['bmr'] = bmr ?? bmrCotroller;
      bodyMeasurementData['visceralFat'] = visceralFat;
      bodyMeasurementData['subCutaneous'] = subCutaneous;
      bodyMeasurementData['bodyMetabolicAge'] = bodyMetabolicAge;
      bodyMeasurementData['muscleMass'] = muscleMass;
      if (isAdditionalDetails == true) {
        bodyMeasurementData['measurements'] = {};
        if (bodyMeasurementData['measurements'] != null ||
            bodyMeasurementData['measurements'] != {}) {
          bodyMeasurementData['measurements']['measurementUnits'] =
              measuringUnit == 'cm' ? 'centimeters' : 'inches';
          if (bust == null) {
            bodyMeasurementData['measurements']['bust'] = bust;
          }
          if (chest == null) {
            bodyMeasurementData['measurements']['chest'] = chest;
          }
          if (waist == null) {
            bodyMeasurementData['measurements']['waist'] = waist;
          }
          if (hips == null) {
            bodyMeasurementData['measurements']['hips'] = hips;
          }
          if (midway == null) {
            bodyMeasurementData['measurements']['midway'] = midway;
          }
          if (thighs == null) {
            bodyMeasurementData['measurements']['thighs'] = thighs;
          }
          if (knees == null) {
            bodyMeasurementData['measurements']['knees'] = knees;
          }
          if (calves == null) {
            bodyMeasurementData['measurements']['calves'] = calves;
          }
          if (upperArms == null) {
            bodyMeasurementData['measurements']['upperArms'] = upperArms;
          }
          if (foreArms == null) {
            bodyMeasurementData['measurements']['foreArms'] = foreArms;
          }
          if (neck == null) {
            bodyMeasurementData['measurements']['neck'] = neck;
          }
          if (shoulder == null) {
            bodyMeasurementData['measurements']['shoulder'] = shoulder;
          }
          if (wrist == null) {
            bodyMeasurementData['measurements']['wrist'] = wrist;
          }
          if (upperAbdomen == null) {
            bodyMeasurementData['measurements']['upperAbdomen'] = upperAbdomen;
          }
          if (lowerAbdomen == null) {
            bodyMeasurementData['measurements']['lowerAbdomen'] = lowerAbdomen;
          }
        }
      }

      log(bodyMeasurementData.toString());
      postBodyMeasurements(context);
    }
  }

  bool isAdditionalDetails = false;
  Object group = 0;
  String measuringUnit = 'cm';

  File? frontImage;
  File? sideImage;
  File? backImage;

  Future pickImage(bool isFrontImage, bool isSideImage) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 60,
      );
      if (image == null) return;
      final tempImg = File(image.path);

      if (isFrontImage == true && isSideImage == false) {
        setState(() {
          frontImage = tempImg;
        });
        uploadImage(frontImage!, 'frontImage');
      }
      if (isFrontImage == false && isSideImage == true) {
        setState(() {
          sideImage = tempImg;
        });
        uploadImage(sideImage!, 'sideImage');
      }
      if (isFrontImage == false && isSideImage == false) {
        setState(() {
          backImage = tempImg;
        });
        uploadImage(backImage!, 'backImage');
      }
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to pick image!');
    }
  }

  Map<String, dynamic> imageData = {};
  var dio = Dio();
  Future<void> uploadImage(File file, String image) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);

      var responseData = response.data;
      String url = responseData["data"]["location"];

      // bodyMeasurementData['mediaLinks'] = {};

      log("image upload url: $url");
      if (image == 'frontImage') {
        imageData['frontImage'] = url;
      }
      if (image == 'sideImage') {
        imageData['sideImage'] = url;
      }
      if (image == 'backImage') {
        imageData['backImage'] = url;
      }
      // await newPost(url);
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Not able to upload image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Measurements'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    datePicker(dateController);
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).canvasColor,
                        filled: true,
                        hintText: 'Measurement Date',
                        hintStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: const Color(0xFF717579),
                                ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            datePicker(dateController);
                          },
                          child: const Text('PICK'),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      cursorColor: whiteColor,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please choose a date';
                        } else {}
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Card(
                      child: InkWell(
                        onTap: () {
                          pickImage(true, false);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: frontImage != null
                            ? Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(
                                      frontImage!,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 150,
                                height: 200,
                                child: Center(
                                  child: Text(
                                    'Front Image',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Card(
                      child: InkWell(
                        onTap: () {
                          pickImage(false, true);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: sideImage != null
                            ? Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(
                                      sideImage!,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 150,
                                height: 200,
                                child: Center(
                                  child: Text(
                                    'Side Image',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Card(
                      child: InkWell(
                        onTap: () {
                          pickImage(false, false);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: backImage != null
                            ? Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(
                                      backImage!,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 150,
                                height: 200,
                                child: Center(
                                  child: Text(
                                    'Back Image',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  hint: 'Add note',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      note = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please add a note';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        keyboard: TextInputType.phone,
                        hint: 'Height in feet',
                        hintBorderColor: Colors.grey,
                        onSaved: (value) {
                          setState(() {
                            feetHeight = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Add height in ft';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        keyboard: TextInputType.phone,
                        hint: 'Height in inches',
                        hintBorderColor: Colors.grey,
                        onSaved: (value) {
                          setState(() {
                            inchesHeight = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Add height in inches';
                          }
                          if (int.parse(value) > 11) {
                            return 'Please enter a valid value';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Weight in kg',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      weightKg = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Heart Rate',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      heartRate = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your heart rate';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Body Fat',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      bodyFat = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your body fat';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Blood Pressure (eg. 100/80 in mmHg)',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      bloodPressure = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your blood pressure';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        keyboard: TextInputType.phone,
                        hint: 'BMI',
                        hintBorderColor: Colors.grey,
                        controller: bmiCotroller,
                        onSaved: (value) {
                          setState(() {
                            bmi = int.parse(value!);
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your BMI';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        var result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BmiDetailsScreen(
                            isFromMasurementScreen: true,
                          );
                        }));
                        // print("heello");
                        if (!mounted) return;
                        setState(() {
                          if (result != null) {
                            bmiCotroller.text = result["bmi"];
                          }
                        });
                      },
                      child: const Text('Calculate BMI'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        keyboard: TextInputType.phone,
                        hint: 'BMR',
                        controller: bmrCotroller,
                        hintBorderColor: Colors.grey,
                        onSaved: (value) {
                          setState(() {
                            bmr = int.parse(value!);
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your BMR';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        var result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const BMRScreen(
                            isFromMeasurementScreen: true,
                          );
                        }));
                        if (!mounted) return;
                        setState(() {
                          if (result != null) {
                            bmrCotroller.text = result["bmr"];
                          }
                        });
                      },
                      child: const Text('Calculate BMR'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Visceral Fat',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      visceralFat = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your visceral fat';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Sub Cutaneous',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      subCutaneous = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your sub cutaneous';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Body Metabolic Age',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      bodyMetabolicAge = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your body metabolic age';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  keyboard: TextInputType.phone,
                  hint: 'Muscle Mass',
                  hintBorderColor: Colors.grey,
                  onSaved: (value) {
                    setState(() {
                      muscleMass = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your muscle mass';
                    }
                    return null;
                  },
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    isAdditionalDetails = !isAdditionalDetails;
                  });
                },
                title: Text(
                  'Additional Details',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: isAdditionalDetails
                    ? const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: orange,
                      ),
              ),
              isAdditionalDetails
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Expanded(child: Text('Measurement unit')),
                              Expanded(
                                child: RadioListTile(
                                  value: 0,
                                  groupValue: group,
                                  onChanged: (value) {
                                    setState(() {
                                      group = value!;
                                      measuringUnit = 'cm';
                                    });
                                  },
                                  title: Text(
                                    'cm',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  value: 1,
                                  groupValue: group,
                                  onChanged: (value) {
                                    setState(() {
                                      group = value!;
                                      measuringUnit = 'inch';
                                    });
                                  },
                                  title: Text(
                                    'inch',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Bust in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                bust = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Chest in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                chest = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Waist in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                waist = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Hips in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                hips = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Midway in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                midway = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Thighs in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                thighs = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Knees in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                knees = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Calves in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                calves = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Upper Arms in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                upperArms = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Fore Arms in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                foreArms = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Neck in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              setState(() {
                                neck = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Shoulder in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              shoulder = int.parse(value!);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Wrist in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              wrist = int.parse(value!);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Upper Abdomen in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              upperAbdomen = int.parse(value!);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomTextField(
                            keyboard: TextInputType.phone,
                            hint: 'Lower Abdomen in $measuringUnit',
                            hintBorderColor: Colors.grey,
                            onSaved: (value) {
                              lowerAbdomen = int.parse(value!);
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    onSubmit(context);
                  },
                  child: const Text('Add Measurement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? datePickerDarkTheme
              : datePickerLightTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }
}
