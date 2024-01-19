import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/imagepicker.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/health_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCustomExercise extends StatefulWidget {
  const AddCustomExercise({Key? key}) : super(key: key);

  @override
  State<AddCustomExercise> createState() => _AddCustomExerciseState();
}

class _AddCustomExerciseState extends State<AddCustomExercise> {
  File? image;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  var dio = Dio();
  var path = "";

  File? pickedImage;

  bool isBodyPartsLoading = false;

  Future<void> getBodyPartGroupsData() async {
    await Provider.of<HealthData>(context, listen: false).getBodyPartGroups();
  }

  Future<void> getBodyPartsData() async {
    setState(() {
      isBodyPartsLoading = true;
    });
    try {
      await Provider.of<HealthData>(context, listen: false).getBodyParts();
      await getBodyPartGroupsData();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    } finally {
      setState(() {
        isBodyPartsLoading = false;
      });
    }
  }

  Map<String, dynamic> data = {
    "name": "",
    "userId": "",
    "calorieFactor": 0,
    "description": "",
    "minWeight": 0,
    "weightUnit": "",
    "mediaLink": "",
    "bodyPartId": ["629515f11edcbf05cc55a3e8"],
    "bodyPartGroupId": ["6263acca60f1c72b6c17e3a7"]
  };
  Future<void> getImageFromCamera() async {
    try {
      pickedImage = await CustomImagePicker().imagePicker(ImageSource.camera);
      setState(() {
        path = pickedImage!.path;
      });
      log(path);
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to pick image!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image!');
    }
  }

  Future<void> getImageFromGallery() async {
    try {
      pickedImage = await CustomImagePicker().imagePicker(ImageSource.gallery);
      setState(() {
        path = pickedImage!.path;
      });
      // log(path);
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to pick image!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image!');
    }
  }

  String? mediaLinkUrl;

  Future<void> uploadImage(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);

      var responseData = response.data;
      String url = responseData["data"]["location"];
      setState(() {
        mediaLinkUrl = url;
      });
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Not able to upload image");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void submit() async {
    setState(() {
      isBodyPartsLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    data["userId"] = Provider.of<UserData>(context, listen: false).userData.id;

    if (path.isEmpty) {
      Fluttertoast.showToast(msg: "Please select an image");
      setState(() {
        isBodyPartsLoading = false;
      });
      return;
    }

    await uploadImage(File(path));
    data["mediaLink"] = mediaLinkUrl;

    log("payload $data");

    await postEx();

    setState(() {
      isBodyPartsLoading = false;
    });
  }

  Future<void> postEx() async {
    try {
      await Provider.of<ExercisesData>(context, listen: false)
          .postExercise(data);
      Fluttertoast.showToast(msg: "Exercise Saved ");
      Navigator.of(context).pop();
    } on HttpException catch (e) {
      log("error http post ex $e");
      Fluttertoast.showToast(msg: "Unable to save your exercise");
    } catch (e) {
      log("Error post ex  $e");
      Fluttertoast.showToast(msg: "Unable to save your exercise");
    }
  }

  String? bodyPart;
  String? bodyPartGroup;
  String? category;
  // List bodyParts = [
  //   'Chest',
  //   'Shoulder',
  //   'Triceps',
  //   'Back',
  //   'Biceps',
  //   'Quadriceps',
  //   'Calves',
  //   'Hamstrings',
  //   'Cardio',
  //   'Abs',
  //   'Obliques',
  // ];

  @override
  void initState() {
    super.initState();
    getBodyPartsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Custom Exercises'),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: isBodyPartsLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showImageDialog(context);
                        },
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: path.isEmpty
                              ? Image.asset('assets/icons/photo.png')
                              : Image.file(File(path)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      customTextField(
                        'Exercise name',
                        (value) {
                          data["name"] = value;
                        },
                        (value) {
                          if (value == null || value.isEmpty) {
                            return "This field cannot be empty";
                          }
                          return null;
                        },
                      ),
                      customTextField('Calories Per Rep', (value) {
                        data["caloriesPerRep"] = value;
                      }, (value) {
                        if (value == null || value.isEmpty) {
                          return "This field cannot be empty";
                        }
                        return null;
                      }, textInputType: TextInputType.number),
                      customTextField('Min Weight', (value) {
                        data["minWeight"] = value;
                      }, (value) {
                        if (value == null || value.isEmpty) {
                          return "This field cannot be empty";
                        }
                        return null;
                      }, textInputType: TextInputType.number),
                      customTextField(
                        'Weight Unit',
                        (value) {
                          data["weightUnit"] = value;
                        },
                        (value) {
                          if (value == null || value.isEmpty) {
                            return "This field cannot be empty";
                          }
                          return null;
                        },
                      ),

                      customTextField(
                        'Youtube link',
                        (value) {
                          // data["mediaLink"] = value;
                        },
                        (value) {
                          return null;
                        },
                      ),

                      customTextField(
                        'Description',
                        (value) {
                          data["description"] = value;
                        },
                        (value) {
                          return null;
                        },
                      ),
                      Consumer<HealthData>(
                        builder: (context, value, child) =>
                            Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Body Part',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: DropdownButtonFormField(
                                isDense: true,
                                items: value.bodyParts
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.name,
                                    child: Text(
                                      "${value.name}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "Please choose a value";
                                  }
                                  return null;
                                },
                                onChanged: (String? newValue) {
                                  // log("$newValue");
                                  for (var element in value.bodyParts) {
                                    if (element.name == newValue) {
                                      // log("${element.id}");
                                      setState(() {
                                        bodyPart = newValue;
                                        data["bodyPartId"] = [element.id];
                                      });
                                    }
                                  }
                                },
                                value: bodyPart,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
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
                                  constraints: const BoxConstraints(),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                hint: Text(
                                  'Primary body part/ Exercise',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Body Part Group',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: DropdownButtonFormField(
                                isDense: true,
                                items: value.bodyPartGroups
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.name,
                                    child: Text(
                                      "${value.name}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "Please choose a value";
                                  }
                                  return null;
                                },
                                onChanged: (String? newValue) {
                                  // log("$newValue");
                                  for (var element in value.bodyPartGroups) {
                                    if (element.name == newValue) {
                                      // log("${element.id}");
                                      setState(() {
                                        bodyPartGroup = newValue!;
                                        data["bodyPartGroupId"] = [element.id];
                                      });
                                    }
                                  }
                                },
                                value: bodyPartGroup,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
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
                                  constraints: const BoxConstraints(),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                hint: Text(
                                  'Primary body part/ Exercise',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8),
                      //   child: Text(
                      //     'Category',
                      //     style: Theme.of(context).textTheme.labelMedium,
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      //   child: DropdownButtonFormField(
                      //     isDense: true,
                      //     items: categories.map<DropdownMenuItem<String>>((value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(
                      //           value,
                      //           style: Theme.of(context).textTheme.bodyMedium,
                      //         ),
                      //       );
                      //     }).toList(),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         category = newValue!;
                      //       });
                      //     },
                      //     value: category,
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //     decoration: InputDecoration(
                      //       enabledBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(8),
                      //         borderSide: const BorderSide(
                      //           color: Colors.grey,
                      //           width: 1.25,
                      //         ),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(8),
                      //         borderSide: const BorderSide(
                      //           color: Colors.grey,
                      //           width: 1.25,
                      //         ),
                      //       ),
                      //       constraints: const BoxConstraints(
                      //         maxHeight: 56,
                      //       ),
                      //       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      //     ),
                      //     icon: const Icon(
                      //       Icons.keyboard_arrow_down_rounded,
                      //       color: Colors.grey,
                      //     ),
                      //     borderRadius: BorderRadius.circular(8),
                      //     hint: Text(
                      //       'Category',
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodySmall!
                      //           .copyWith(color: Colors.grey),
                      //     ),
                      //   ),
                      // ),
                      // customTextField(
                      //   'Add youtube link (Optional)',
                      //   (value) {},
                      //   (value) {
                      //     return null;
                      //   },
                      // ),
                      // customTextField(
                      //   'Add third party video link (Optional)',
                      //   (value) {},
                      //   (value) {
                      //     return null;
                      //   },
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8),
                      //   child: Text(
                      //     'Note: Supported video formats are .mp4 and .mov',
                      //     style: Theme.of(context).textTheme.bodySmall,
                      //   ),
                      // ),
                      // customTextField(
                      //   'Description (Optional)',
                      //   (value) {},
                      //   (value) {
                      //     return null;
                      //   },
                      // ),
                      // customTextField(
                      //   'Tips (Optional)',
                      //   (value) {},
                      //   (value) {
                      //     return null;
                      //   },
                      // ),
                      // customTextField(
                      //   'Instructions (Optional)',
                      //   (value) {},
                      //   (value) {
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          submit();
        },
        child: Container(
          height: 56,
          color: orange,
          child: Center(
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(String hint, void Function(String?)? onSaved,
      String? Function(String?)? validator,
      {TextInputType textInputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: TextFormField(
        keyboardType: textInputType,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFC3CAD9),
            ),
          ),
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF959EAD),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'OpenSans',
          ),
        ),
        style: Theme.of(context).textTheme.bodySmall,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  void showImageDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Pick image from',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getImageFromGallery();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Gallery',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getImageFromCamera();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Camera'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

  // List categories = [
  //   'Weight Training',
  //   'Cardio',
  //   'Crossfit',
  //   'Functional',
  //   'Free Body',
  //   'Care',
  //   'Strength Training',
  //   'Aerobic Training',
  // ];

