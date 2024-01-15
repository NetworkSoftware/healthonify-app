import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/providers/diet_plans/diet_plans_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditRecipe extends StatefulWidget {
  final String title;
  const EditRecipe({Key? key, this.title = "Edit Recipe"}) : super(key: key);

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  final formKey = GlobalKey<FormState>();
  File? pickedImage;
  CroppedFile? cropFile;
  File? croppedImage;
  Future _getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (image == null) return;
      final tempImg = File(image.path);
      setState(() {
        pickedImage = tempImg;
      });
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to pick image!');
    }
    uploadImage(pickedImage!);
  }

  var dio = Dio();

  Future<void> uploadImage(File file) async {
    LoadingDialog().onLoadingDialog("Uploading...", context);
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);

      var responseData = response.data;
      String url = responseData["data"]["location"];
      addRecipeMap['mediaLink'].add(url);

      log(url);
      popFunction();
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Not able to upload image");
    }
  }

  Future<void> addRecipies(BuildContext context) async {
    try {
      await Provider.of<DietPlansProvider>(context, listen: false)
          .addRecipe(addRecipeMap);

      Fluttertoast.showToast(msg: 'Added recipe');
      popFunction();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to update body measurements');
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  Map<String, dynamic> addRecipeMap = {
    "name": "",
    "userId": "",
    "mediaLink": [],
    "description": {
      "ingredients": "",
      "method": "",
    },
    "calories": 0,
    "durationInMinutes": 0,
    "isActive": false,
    "nutrition": [
      {"carbs": 0.0},
      {"fats": 0.0},
      {"fiber": 0.0},
      {"proteins": 0.0},
    ],
  };

  String? recipeName;
  late String userId;
  String? ingredients;
  String? method;
  double? calories;
  double? durationInMins;
  double? carbs;
  double? fats;
  double? fiber;
  double? proteins;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    addRecipeMap['name'] = recipeName;
    addRecipeMap['userId'] = userId;
    addRecipeMap['description']['ingredients'] = ingredients;
    addRecipeMap['description']['method'] = method;
    addRecipeMap['calories'] = calories;
    addRecipeMap['durationInMinutes'] = durationInMins;
    addRecipeMap['nutrition'][0]['carbs'] = carbs;
    addRecipeMap['nutrition'][0]['fats'] = fats;
    addRecipeMap['nutrition'][0]['fiber'] = fiber;
    addRecipeMap['nutrition'][0]['proteins'] = proteins;

    log(addRecipeMap.toString());
    addRecipies(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.title),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          pickedImage != null
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(
                          pickedImage!,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  color: Colors.grey,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/icons/add_post.png'),
                ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GradientButton(
                    title: 'Camera',
                    func: () {
                      _getImage(ImageSource.camera);
                    },
                    gradient: orangeGradient,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GradientButton(
                    title: 'Gallery',
                    func: () {
                      _getImage(ImageSource.gallery);
                    },
                    gradient: blueGradient,
                  ),
                ),
              ),
            ],
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hint: 'Recipe Name',
                    hintBorderColor: Colors.grey,
                    onSaved: (value) {
                      setState(() {
                        recipeName = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the recipe name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          keyboard: TextInputType.phone,
                          hint: 'Protiens in gms',
                          hintBorderColor: Colors.grey,
                          onSaved: (value) {
                            setState(() {
                              proteins = double.parse(value!);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter proteins count';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          keyboard: TextInputType.phone,
                          hint: 'Carbs in gms',
                          hintBorderColor: Colors.grey,
                          onSaved: (value) {
                            setState(() {
                              carbs = double.parse(value!);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter carbs count';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          keyboard: TextInputType.phone,
                          hint: 'Fats in gms',
                          hintBorderColor: Colors.grey,
                          onSaved: (value) {
                            setState(() {
                              fats = double.parse(value!);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter fats count';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextField(
                          keyboard: TextInputType.phone,
                          hint: 'Fibers in gms',
                          hintBorderColor: Colors.grey,
                          onSaved: (value) {
                            setState(() {
                              fiber = double.parse(value!);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter fibers count';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    keyboard: TextInputType.phone,
                    hint: 'Calories in gms',
                    hintBorderColor: Colors.grey,
                    onSaved: (value) {
                      setState(() {
                        calories = double.parse(value!);
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter calories count';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    keyboard: TextInputType.phone,
                    hint: 'Preparation time in mins',
                    hintBorderColor: Colors.grey,
                    onSaved: (value) {
                      setState(() {
                        durationInMins = double.parse(value!);
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter preparation time in mins';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    hint: 'Ingredients',
                    hintBorderColor: Colors.grey,
                    onSaved: (value) {
                      setState(() {
                        ingredients = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the ingredients';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    hint: 'Method',
                    hintBorderColor: Colors.grey,
                    onSaved: (value) {
                      method = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the recipe method';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: pickedImage == null
                          ? () {
                              Fluttertoast.showToast(
                                  msg: 'Please select an image for the recipe');
                              return;
                            }
                          : () {
                              onSubmit();
                            },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
