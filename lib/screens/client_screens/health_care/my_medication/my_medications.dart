import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/providers/my_medication/medication_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
//import 'package:sendbird_sdk/request/feature/group_channel_read_request.dart';

class MyMedicationsScreen extends StatefulWidget {
  const MyMedicationsScreen({Key? key}) : super(key: key);

  @override
  State<MyMedicationsScreen> createState() => _MyMedicationsScreenState();
}

class _MyMedicationsScreenState extends State<MyMedicationsScreen> {
  PlatformFile? pickedFile;
  File? croppedImage;
  bool isPicked = false;
  bool isLoading = true;
  final TextEditingController _prescriptionName = TextEditingController();
  bool isSubmittingPrescription = false;
  Map<String, String> payload = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserPrescription();
  }

  void chooseFile() async {
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
        });
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

  String dateText = 'Choose date';
  String sendingDateText = 'Choose date';
  String uploadText = 'Attach Prescription';

  void getName(String value) => payload["name"] = value;

  Future<void> uploadFile(PlatformFile file, BuildContext context) async {
    var dio = Dio();
    final focusNode = FocusScope.of(context);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;

    setState(() {
      isSubmittingPrescription = true;
    });
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
      });

      var response = await dio.post("${ApiUrl.url}upload", data: formData);
      var responseData = response.data;

      print("response data... : $responseData");
      String url = responseData["data"]["location"];

      print("Url... : $url");

      payload = {
        'userId': userId,
        'mediaLink': url,
        'date': sendingDateText,
        'name': _prescriptionName.text
      };

      await Provider.of<MedicationData>(context, listen: false)
          .postPrescription(payload);
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "File size too big");
    } finally {
      getUserPrescription();
      setState(() {
        isSubmittingPrescription = false;
        uploadText = 'Upload Prescription';
        dateText = 'Choose date';
        _prescriptionName.clear();
      });
    }
  }

  Future<void> getUserPrescription() async {
    //log(currentPage.toString());
    setState(() {
      _isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<MedicationData>(context, listen: false)
          .getAllUploadedPrescription(userId);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting userPrescription $e");
      Fluttertoast.showToast(msg: "Unable to fetch userPrescription");
    } finally {
      // setState(() {
      //   _isPaginationLoading = false;
      // });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Medications'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Latest Prescriptions',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: Text(
              //     'Prescription name',
              //     style: Theme.of(context).textTheme.bodyMedium,
              //   ),
              // ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _prescriptionName,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Enter prescription name',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  labelText: 'Prescription name',
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    //  when the TextFormField in unfocused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    //  when the TextFormField in focused
                  ),
                ),
              ),
              // TextFormField(
              //   controller: _prescriptionName,
              //   decoration: const InputDecoration(
              //       labelText: 'Prescription name',
              //       hintText: 'Enter prescription name',
              //       hintStyle: TextStyle(
              //         color: Color(0xFF959EAD),
              //         fontSize: 8,
              //         fontWeight: FontWeight.w500,
              //         fontFamily: 'OpenSans',
              //       ),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.grey),
              //         //  when the TextFormField in unfocused
              //       ),
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.blue),
              //         //  when the TextFormField in focused
              //       ),
              //       border: UnderlineInputBorder()),
              //   keyboardType: TextInputType.text,
              //   textCapitalization: TextCapitalization.words,
              // ),
              // ListTile(
              //   title: Text(
              //     'Prescription name',
              //     style: Theme.of(context).textTheme.bodyMedium,
              //   ),
              //   trailing: Text(
              //     '12/09/2022',
              //     style: Theme.of(context)
              //         .textTheme
              //         .bodySmall!
              //         .copyWith(color: Colors.grey),
              //   ),
              // ),
              //const Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListTile(
                  onTap: () {
                    chooseFile();
                  },
                  title: Text(
                    uploadText,
                    style:  Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: orange),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        builder: (context, child) {
                          return Theme(
                            data: MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? datePickerDarkTheme
                                : datePickerLightTheme,
                            child: child!,
                          );
                        },
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1800),
                        lastDate: DateTime(2200),
                      ).then((value) {
                        if (value == null) {
                          return;
                        } else {
                          setState(() {
                            sendingDateText =
                                DateFormat('yyyy-MM-dd').format(value);
                            print(sendingDateText);
                            dateText = DateFormat('dd/MM/yyyy').format(value);
                          });
                        }
                      });
                    },
                    child: Text(
                      dateText,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: orange),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isSubmittingPrescription == false
                      ? ElevatedButton(
                          onPressed: () {
                            if (_prescriptionName.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter prescription name");
                            } else if (uploadText == 'Upload Prescription') {
                              Fluttertoast.showToast(
                                  msg: "Please select prescription");
                            } else if (dateText == 'Choose date') {
                              Fluttertoast.showToast(msg: "Please choose date");
                            } else {
                              uploadFile(pickedFile!, context);
                            }
                          },
                          child: Text(
                            'Upload Prescription',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: whiteColor),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Prescription History',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              _isLoading == false
                  ? Consumer<MedicationData>(
                      builder: (context, value, child) => ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.userPrescriptionList.length,
                        itemBuilder: (context, index) {
                          DateTime tempDate =
                              DateFormat("MM/dd/yyyy").parse(
                                  value.userPrescriptionList[index].date!);
                          String prescriptionDate =
                              DateFormat('dd/MM/yyyy').format(tempDate);
                          return InkWell(
                            onTap: (){
                              _showAttachment(value.userPrescriptionList[index].mediaLink!);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        value.userPrescriptionList[index].name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Text(
                                        prescriptionDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: (){
                                        _showAttachment(value.userPrescriptionList[index].mediaLink!);
                                      },
                                      child: const Icon(Icons.remove_red_eye),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(color: Colors.grey);
                        },
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttachment(String image) {
    showCupertinoDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Attachment",
          style: TextStyle(height: 1.2),
        ),
        content: Image.network(image),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close"
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
