import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/providers/community_provider/community_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AddNewPostScreen extends StatefulWidget {
  const AddNewPostScreen({Key? key}) : super(key: key);

  @override
  State<AddNewPostScreen> createState() => _AddNewPostScreenState();
}

class _AddNewPostScreenState extends State<AddNewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  bool? isMp4;
  bool isVideoLink = false;
  File? pickedImage;
  CroppedFile? cropFile;
  File? croppedImage;

  Future _getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickMedia(
          // source: source,
          // maxDuration: const Duration(minutes: 10),
          // maxWidth: 1800,
          // maxHeight: 1800,
          );
      if (image == null) return;
      final tempImg = File(image.path);
      print("PAth : $tempImg");
      setState(() {
        pickedImage = tempImg;
      });
      if (image.path.contains("mp4")) {
        print("Video1234567890");
        isMp4 = true;
      } else {
        print("Image1234567890");
        isMp4 = false;
        _cropImage(pickedImage!.path);
      }
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to pick image!');
    }
  }

  Future<void> _cropImage(String imgPath) async {
    if (pickedImage != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgPath,
      );
      if (croppedFile != null) {
        setState(() {
          cropFile = croppedFile;
          croppedImage = File(cropFile!.path);
        });
      }
    }
  }

  var dio = Dio();
  bool isLoading = true;

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
      await newPost(url);
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Not able to upload image");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String description = "";
  String? videoLink;
  TextEditingController videoController = TextEditingController();
  Map<String, dynamic> postData = {
    "userId": "",
    "mediaLink": "",
    "description": "",
    "date": "",
    "userType": "",
    "isActive": true,
  };

  void popFunc() {
    Navigator.pop(context);
  }

  Future<void> newPost(String url) async {
    try {
      if (url.isEmpty) {
        Fluttertoast.showToast(msg: 'Please select an image');
        return;
      }

      var userId = Provider.of<UserData>(context, listen: false).userData.id!;

      postData["userId"] = userId;
      postData["mediaLink"] = url;

      log(url);

      postData["userType"] = "user";
      postData["description"] = description;

      log("this is the text field data ===> ${postData["description"]}");

      postData["date"] = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await Provider.of<CommunityProvider>(context, listen: false)
          .addPost(postData);

      if (isVideoLink == true) {
        popFunc.call();
      } else {
        popFunc.call();
        popFunc.call();
      }
      showPopUp();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload your post");
    } catch (e) {
      log("Error add post $e");
      Fluttertoast.showToast(msg: "Unable to upload your post");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add a new post'),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            videoLink != null && isVideoLink == true
                ? GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(videoLink!),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Image.asset(
                        "assets/images/play.png",
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                      ),

                      // Container(

                      //   //height: MediaQuery.of(context).size.height * 0.3,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     image: const DecorationImage(
                      //       image: AssetImage(
                      //         "assets/images/play.png",
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                  )
                : isMp4 == true
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/video_player.png",
                              ),
                            ),
                          ),
                        ),
                      )
                    : pickedImage != null
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      title: 'Camera',
                      func: () {
                        setState(() {
                          isVideoLink = false;
                        });
                        _getImage(ImageSource.camera);
                      },
                      gradient: orangeGradient,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GradientButton(
                      title: 'Gallery',
                      func: () {
                        setState(() {
                          isVideoLink = false;
                        });
                        _getImage(ImageSource.gallery);
                      },
                      gradient: blueGradient,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GradientButton(
                      title: 'Video Link',
                      func: () {
                        setState(() {
                          if (videoLink != null) {
                            videoController.text = videoLink!;
                          }
                          isVideoLink = !isVideoLink;
                        });
                      },
                      gradient: purpleGradient,
                    ),
                  ),
                ],
              ),
            ),
            isVideoLink == true
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      controller: videoController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 2,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).canvasColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFff7f3f),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Enter video link',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {
                        videoLink = value;
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please enter a description for your post';
                      //   }
                      //   return null;
                      // },
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 5,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFff7f3f),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: 'Enter a caption for your post',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'OpenSans',
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  description = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description for your post';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GradientButton(
                title: 'POST',
                func: croppedImage == null && isMp4 == false
                    ? () {
                        Fluttertoast.showToast(msg: 'Please choose an image');
                      }
                    : () {
                        if (description.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please enter a description for your post');
                          return;
                        }
                        if (isVideoLink == true) {
                          newPost(videoLink!);
                        } else if (isMp4 == false) {
                          uploadImage(croppedImage!);
                        } else {
                          uploadImage(pickedImage!);
                        }
                      },
                gradient: blueGradient,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void showPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Post submitted',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Your post has been submitted for review!',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GradientButton(
                  title: 'CONTINUE',
                  func: () {
                    Navigator.pop(context);
                  },
                  gradient: blueGradient,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
