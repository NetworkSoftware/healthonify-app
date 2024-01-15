import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/fiirebase_notifications.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/insurance_locker/insurance_provider.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddInsuranceScreen extends StatefulWidget {
  final String insuranceType;
  const AddInsuranceScreen({required this.insuranceType, Key? key})
      : super(key: key);

  @override
  State<AddInsuranceScreen> createState() => _AddInsuranceScreenState();
}

class _AddInsuranceScreenState extends State<AddInsuranceScreen> {
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
    _cropImage(pickedImage!.path);
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
          pickedFile = null;
        });
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return AddRecordDetails(croppedImg: cropFile);
        // }));
      }
    }
  }

  PlatformFile? pickedFile;
  bool isPicked = false;
  bool isLoading = true;

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

  bool isSubmitting = true;
  String? medLink;
  Future<void> uploadFile(PlatformFile file, User userData) async {
    var dio = Dio();
    LoadingDialog().onLoadingDialog("Uploading...", context);
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
      medLink = url;
      insuranceData['mediaLink'] = medLink;

      log('media link for file : $medLink');
      await pickFile(insuranceData);

      popFunc();
      popFunc();
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload record");
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void popFunc() {
    Navigator.pop(context);
  }

  Future<void> uploadImage(File file, User userData) async {
    var dio = Dio();
    LoadingDialog().onLoadingDialog("Uploading...", context);
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });

      var response = await dio.post("${ApiUrl.wm}upload", data: formData);
      var responseData = response.data;
      String url = responseData["data"]["location"];
      medLink = url;
      insuranceData['mediaLink'] = medLink;

      log('media link for image : $medLink');
      await pickFile(insuranceData);

      popFunc();
      popFunc();
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload record");
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future pickFile(Map<String, dynamic> data) async {
    try {
      await Provider.of<InsuranceProvider>(context, listen: false)
          .postInsuranceRecord(data);
    } on HttpException catch (e) {
      log("Error file upload widget $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error file upload widget $e");
      Fluttertoast.showToast(msg: "Unable to upload your insurance record");
    }
  }

  String? expiryReminderDate;
  String? insuranceCompanyName;

  void onSubmit(context, bool isImageUpload) async {
    User userData = Provider.of<UserData>(context, listen: false).userData;

    insuranceData['userId'] = userData.id;
    insuranceData['insuranceType'] = widget.insuranceType;
    if (dropDownValue != 'Other') {
      insuranceData['insuranceCompanyName'] = dropDownValue;
    } else {
      insuranceData['insuranceCompanyName'] = insuranceCompanyName;
    }
    insuranceData['expiryDate'] = ymdFormat;
    insuranceData['entryDateTime'] = DateTime.now().toIso8601String();

    log(insuranceData.toString());

    // DateTime temp = DateFormat('yyyy-MM-dd').parse(ymdFormat!);
    // DateTime expReminder = temp.subtract(const Duration(days: 1));
    // expiryReminderDate = DateFormat('yyyy-MM-dd').format(expReminder);
    // if (expiryReminderDate != null) {
    //   FirebaseNotif().scheduledNotification(
    //     id: insuranceExpiryId,
    //     hour: 10,
    //     minute: 00,
    //   );
    // }

    isImageUpload
        ? await uploadImage(croppedImage!, userData)
        : await uploadFile(pickedFile!, userData);

    FirebaseNotif().scheduledDayNotification(
        id: 70,
        dateTime: DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          10,
          0,
          0,
        ));
  }

  @override
  void initState() {
    super.initState();
    pickedImage = null;
    croppedImage = null;
  }

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Map<String, dynamic> insuranceData = {};

  String? dropDownValue;
  List<String> dropDownOptions = [
    'AEGON Life Insurance',
    'Bajaj Life Insurance',
    'Canara HSBC OBC Life Insurance',
    'HSFC Standard Life Insurance',
    'ICICI Prudential Life Insurance',
    'Life Insurance Corporation of India',
    'Max NewYork Life Insurance',
    'PNB Metlife Insurance',
    'Reliance Life Insurance',
    'SBI Life Insurance',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Insurance Record'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'UPLOAD INSURANCE RECORDS',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: DropdownButtonFormField(
                      isDense: true,
                      items: dropDownOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      },
                      value: dropDownValue,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.25,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 50,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      hint: Text(
                        'Insurance Company',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              dropDownValue == 'Other'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTextField(
                        hint: 'Enter insurance company\'s name',
                        hintBorderColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            insuranceCompanyName = value;
                          });
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: croppedImage != null
                        ? Container(
                            height: 125,
                            width: 125,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(croppedImage!),
                              ),
                            ),
                          )
                        : pickedFile != null
                            ? SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(pickedFile!.name),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/icons/images.png'),
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _getImage(ImageSource.camera);
                        },
                        child: const Text('SCAN'),
                      ),
                      VerticalDivider(
                        color: Colors.grey[800],
                      ),
                      TextButton(
                        onPressed: () {
                          chooseFile();
                          // _getImage(ImageSource.gallery);
                        },
                        child: const Text('UPLOAD'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    datePicker(context, dateController);
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Choose expiry date',
                        alignLabelWithHint: true,
                        labelStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Colors.grey[600],
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        suffixIcon: IconButton(
                          onPressed: () {
                            datePicker(context, dateController);
                          },
                          icon: const Icon(
                            Icons.event_rounded,
                            color: orange,
                          ),
                          splashRadius: 20,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please choose a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ElevatedButton(
                  onPressed: pickedFile != null
                      ? dropDownValue == "Other" && insuranceCompanyName == null
                          ? () {
                              Fluttertoast.showToast(
                                  msg:
                                      'Please enter the insurance company\'s name');
                              return;
                            }
                          : () {
                              onSubmit(context, false);
                            }
                      : croppedImage != null
                          ? dropDownValue == "Other" &&
                                  insuranceCompanyName == null
                              ? () {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Please enter the insurance company\'s name');
                                  return;
                                }
                              : () {
                                  onSubmit(context, true);
                                }
                          : null,
                  child: const Text('CONFIRM'),
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

  void datePicker(context, TextEditingController controller) {
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
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        log(value.toString());
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        log(ymdFormat!);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }
}
