import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/providers/experts/upload_certificates_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_availability.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UploadCertificatesScreen extends StatefulWidget {
  const UploadCertificatesScreen({super.key});

  @override
  State<UploadCertificatesScreen> createState() =>
      _UploadCertificatesScreenState();
}

class _UploadCertificatesScreenState extends State<UploadCertificatesScreen> {
  PlatformFile? pickedFile;
  File? croppedImage;
  bool isPicked = false;
  bool isLoading = true;

  String uploadText = 'Add Report';
  String dateText = 'Choose date';
  void chooseFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'heif', 'pdf', 'doc'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          pickedFile = file;
          uploadText = pickedFile!.path!;

          certificateNames.add(uploadText);
        });

        uploadFile(pickedFile!, context);
      } else {
        //! User cancelled the picker
      }
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to choose file!');
    } finally {
      setState(() {
        croppedImage = null;
        isLoading = false;
      });
    }
  }

  bool isSubmittingCertificate = false;

  Future<void> uploadFile(PlatformFile file, BuildContext context) async {
    var dio = Dio();

    setState(() {
      isSubmittingCertificate = true;
    });
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
      });

      var response = await dio.post("${ApiUrl.wm}upload", data: formData);
      var responseData = response.data;
      String url = responseData["data"]["location"];

      // log(url);
      certificateUrls.add(url);
      log(certificateUrls.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "File size too big");
    } finally {
      setState(() {
        isSubmittingCertificate = false;
      });
    }
  }

  void popFunction(BuildContext context) {
    Navigator.pop(context);
  }

  List<String> certificateNames = [];
  List<String> certificateUrls = [];

  Future<void> postCertificates(BuildContext context) async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<UploadCertificatesAndAvailabilityProvider>(context,
              listen: false)
          .uploadCertificatesAndAvailability(
        {
          "set": {"certificates": certificateUrls}
        },
        userId,
      );
      Fluttertoast.showToast(msg: 'Certificates uploaded');
      nextPage(context);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to upload certificates');
    }
  }

  void nextPage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const ExpertAvailabilityScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Upload Certificates'),
      body: isSubmittingCertificate
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Please upload your certificates below',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            certificateNames = [];
                            certificateUrls = [];
                          });

                          log(certificateUrls.toString());
                        },
                        child: const Text('Clear'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          chooseFile(context);
                        },
                        child: const Text('Add Certificate'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                certificateNames.isEmpty
                    ? const Text('No certificates added')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: certificateNames.length,
                        itemBuilder: (context, index) {
                          File file = File(certificateNames[index]);
                          String basename = basenameWithoutExtension(file.path);
                          return ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(
                              basename,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  certificateNames.removeWhere((value) {
                                    return value
                                        .contains(certificateNames[index]);
                                  });
                                });
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 26,
                              ),
                              splashRadius: 20,
                            ),
                          );
                        },
                      ),
              ],
            ),
      bottomNavigationBar: Container(
        height: 56,
        color: orange,
        child: InkWell(
          onTap: certificateUrls.isNotEmpty
              ? () {
                  postCertificates(context);
                  popFunction(context);
                }
              : () {
                  Fluttertoast.showToast(msg: 'Please upload certificates');
                  return;
                },
          child: Center(
            child: Text(
              'Upload',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}
