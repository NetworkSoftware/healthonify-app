import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/imagepicker.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/providers/challenges_providers/challenges_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/other/calendar_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LogFoodScreen extends StatefulWidget {
  final ChallengesModel challengeData;
  const LogFoodScreen({Key? key, required this.challengeData})
      : super(key: key);

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  var dio = Dio();
  var path = "";

  File? pickedImage;

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

  bool isLoading = true;
  String? userId;
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

  Map<String, dynamic> uploadFoodMap = {};

  Future<void> putFoodLog() async {
    try {
      await Provider.of<ChallengesProvider>(context, listen: false)
          .uploadFoodImages(uploadFoodMap);
      route();
      Fluttertoast.showToast(msg: "Succesfully uploaded food image");
    } on HttpException catch (e) {
      log("unable to uploaded food image $e");
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("unable to uploaded food image $e");
      Fluttertoast.showToast(msg: "Unable to uploaded food image");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void route() {
    Navigator.pop(context);
  }

  void onSubmit() async {
    await uploadImage(File(path));

    uploadFoodMap['userId'] = userId;
    uploadFoodMap['fitnessChallengeId'] = widget.challengeData.id;
    uploadFoodMap['challengeCategoryId'] =
        widget.challengeData.challengeCategoryId;
    uploadFoodMap['date'] = selectedDate;
    uploadFoodMap['mediaLink'] = mediaLinkUrl;

    log(uploadFoodMap.toString());

    putFoodLog();
  }

  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Theme.of(context).colorScheme.onBackground,
            size: 28,
          ),
          splashRadius: 20,
        ),
        title: Text(
          'Log New Food',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.info_outline_rounded,
        //       color: Theme.of(context).colorScheme.onBackground,
        //       size: 28,
        //     ),
        //     splashRadius: 20,
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: Theme.of(context).colorScheme.onBackground,
        //       size: 28,
        //     ),
        //     splashRadius: 20,
        //   ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizCalendar(
            function: (val) {
              var tempDate = DateFormat('yyyy/MM/dd').parse(val);
              selectedDate = DateFormat('yyyy-MM-dd').format(tempDate);
              log(selectedDate!);
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GradientButton(
                    title: 'Camera',
                    func: () {
                      getImageFromCamera();
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
                      getImageFromGallery();
                    },
                    gradient: blueGradient,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 320,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: pickedImage == null
                  ? const Text("Add image")
                  : const Text(""),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomButtons(),
    );
  }

  Widget bottomButtons() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                ),
                onPressed: path.isEmpty
                    ? null
                    : () {
                        onSubmit();
                      },
                child: Text(
                  'LOG',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
