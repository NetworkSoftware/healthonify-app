import 'dart:developer';
import 'dart:io';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/func/update_profile.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class UploadProfileImage extends StatefulWidget {
  const UploadProfileImage({Key? key}) : super(key: key);

  @override
  State<UploadProfileImage> createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  File? image;
  var dio = Dio();
  var isLoading = false;

  Future imagePicker(ImageSource imgSource) async {
    setState(() {
      isLoading = true;
    });
    try {
      final galleryimage = await ImagePicker().pickImage(
        source: imgSource,
        imageQuality: 20,
      );

      print("image : ${galleryimage!.name}");
      print("image length: ${galleryimage.length()}");
      if (galleryimage == null) {
        return;
      }
      final permanentImage = await savePermanentImage(galleryimage.path);
      setState(() {
        image = permanentImage;
      });

      log(image!.path.toString());
      await uploadImage(image!);
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to choose image!');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadImage(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);

      var responseData = response.data;
      String url = responseData["data"]["location"];
      await UpdateProfile.updateProfile(
        this.context,
        {
          "set": {"imageUrl": url}
        },
        onSuccess: () => Navigator.of(this.context).pop(true),
      );

      log(responseData.toString());
      log('Image uploaded');
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload image");
    }
  }

  Future<File> savePermanentImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Upload Profile Image'),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: CircleAvatar(
              backgroundColor: const Color(0xFFff7f3f),
              radius: 68,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 64,
                child: image != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(
                          image!,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : null,
                      )
                    : userData.imageUrl == null || userData.imageUrl!.isEmpty
                        ? const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/icons/pfp_placeholder.jpg',
                            ),
                            radius: 60,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(userData.imageUrl!),
                            radius: 60,
                          ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GradientButton(
              gradient: blueGradient,
              func: () {
                imagePicker(ImageSource.gallery);
              },
              title: 'Choose from gallery',
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GradientButton(
              gradient: blueGradient,
              func: () {
                imagePicker(ImageSource.camera);
              },
              title: 'Choose from camera',
            ),
          ),
        ],
      ),
    );
  }
}
