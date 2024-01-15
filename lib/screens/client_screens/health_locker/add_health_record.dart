import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/health_records/health_record_provider.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddHealthRecord extends StatefulWidget {
  const AddHealthRecord({Key? key}) : super(key: key);

  @override
  State<AddHealthRecord> createState() => _AddHealthRecordState();
}

class _AddHealthRecordState extends State<AddHealthRecord> {
  File? pickedImage;
  CroppedFile? cropFile;
  File? croppedImage;
  Future _getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 40,
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
        });
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
        // print(file.name);
        // print(file.bytes);
        // print(file.size);
        // print(file.extension);
        // print(file.path);
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
        isLoading = false;
      });
    }
  }

  Future pickFile(Map<String, dynamic> data) async {
    try {
      await Provider.of<HealthRecordProvider>(context, listen: false)
          .uploadHealthRecord(data);
      // log('yes!');
    } on HttpException catch (e) {
      log("Error file upload widget $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error file upload widget $e");
      Fluttertoast.showToast(msg: "Unable to upload your health record");
    }
  }

  Map<String, dynamic> healthdata = {
    "userId": "",
    "mediaLink": "",
    "date": "",
    "time": "",
    "reportName": "",
    "reportType": "ECG",
  };
  String? medLink;

  void getReportName(String value) => healthdata["reportName"] = value;

  void popFunc() {
    Navigator.pop(context);
  }

  bool isSubmitting = true;
  Future<void> uploadFile(PlatformFile file, User userData) async {

    print("File size : ${file.size}");
    if (file.size > 7000000) {
      Fluttertoast.showToast(msg: "File size shouldn't exceed 7 mb");
      return;
    }
    var dio = Dio();
    LoadingDialog().onLoadingDialog("Uploading...", context);
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
      });

      healthdata['userId'] = userData.id;
      healthdata['reportType'] = reportType;
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);
      var responseData = response.data;
      String url = responseData["data"]["location"];
      medLink = url;
      healthdata['mediaLink'] = medLink;
      await pickFile(healthdata);
      // log('Health record upload successful');

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

  Future<void> uploadImage(File file, User userData) async {
    var dio = Dio();
    LoadingDialog().onLoadingDialog("Uploading...", context);
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
        ),
      });

      healthdata['userId'] = userData.id;
      healthdata['reportType'] = reportType;
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);
      var responseData = response.data;
      String url = responseData["data"]["location"];
      medLink = url;
      healthdata['mediaLink'] = medLink;
      await pickFile(healthdata);

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

  final _formKey = GlobalKey<FormState>();

  void onSubmit(context, bool isImageUpload) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    User userData = Provider.of<UserData>(context, listen: false).userData;
    if (healthdata["reportName"].isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a report name");
      return;
    }
    healthdata['date'] = ymdFormat;
    healthdata['time'] = time24hrs;
    log('health data date and time stored');
    if (healthdata["reportType"].isEmpty) {
      Fluttertoast.showToast(msg: "Please choose a report type");
      return;
    }
    if (healthdata["date"].isEmpty) {
      Fluttertoast.showToast(msg: "Please choose a date");
      return;
    }
    if (healthdata["time"].isEmpty) {
      Fluttertoast.showToast(msg: "Please choose a time");
      return;
    }

    print("Is image upload : $isImageUpload");
    isImageUpload
        ? uploadImage(croppedImage!, userData)
        : uploadFile(pickedFile!, userData);
  }

  void cancel() {
    setState(() {
      pickedFile = null;
      pickedImage = null;
      croppedImage = null;
    });
  }

  String? reportType;
  List reportTypes = [
    'Lab Report',
    'Prescription',
    'HRA',
    'ECG',
    'Hospital Records',
    'Other',
  ];

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add new health record'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 25),
                child: Text(
                  'Now you can add your health record by :',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              croppedImage != null
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
                          // width: 100,
                          child: Center(
                            child: Text(pickedFile!.name),
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/images.png'),
                            ),
                          ),
                        ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
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
                        },
                        child: const Text('UPLOAD'),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  cancel();
                },
                child: const Text('CLEAR'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Color(0xFFC3CAD9),
                      ),
                    ),
                    hintText: 'Record Name',
                    hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey[600],
                        ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onSaved: (value) {
                    getReportName(value!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a record name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: reportTypes.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      reportType = newValue!;
                    });
                  },
                  value: reportType,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
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
                    'Report Type',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey[600]),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a report type';
                    }
                    return null;
                  },
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
                        labelText: 'Choose date',
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
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _timePicker(),
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: timeController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: orange,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _timePicker();
                          },
                          icon: const Icon(
                            Icons.schedule_rounded,
                            color: orange,
                            size: 28,
                          ),
                        ),
                        hintText: "Choose time",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onSaved: (value) {
                        log(_selectedDate.toString());
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please choose a time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: InkWell(
          onTap: pickedFile != null
              ? () {
                  onSubmit(context, false);
                }
              : croppedImage != null
                  ? () {
                      onSubmit(context, true);
                      // uploadImage(widget.croppedImg!);
                    }
                  : () {
                      Fluttertoast.showToast(msg: 'Please upload an image');
                    },
          child: Center(
            child: Text(
              'Upload',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: whiteColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;
  String? _selectedTime;
  String? time24hrs;

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
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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

  void _timePicker() {
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
        var selection = value;
        var format24hrTime =
            '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}';
        _selectedTime = selection.format(context);
        time24hrs = format24hrTime;
        log(time24hrs!);
        timeController.text = _selectedTime!;
        log('selected time in 24 hrs -> $format24hrTime');
        log('selected time -> ${_selectedTime!}');
      });
    });
  }
}
