import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/update_profile.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/upload_profile_image.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class YourProfileScreen extends StatefulWidget {
  const YourProfileScreen({Key? key}) : super(key: key);

  @override
  State<YourProfileScreen> createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends State<YourProfileScreen> {
  String dateConvertTextFormat(String d) {
    DateTime tempDate = DateFormat("MM/dd/yyyy").parse(d);
    String date = DateFormat("EEE, MMM d ''yy").format(tempDate);
    log(date);

    return date;
  }

  String dateConvertNumberFormat(String d) {
    DateTime tempDate = DateFormat("MM/dd/yyyy").parse(d);
    String date = DateFormat("MM/dd/yyyy").format(tempDate);
    log(date);

    return date;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchUserData(context) async {
    await Provider.of<UserData>(context, listen: false).fetchUserData();
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController consultationCharge = TextEditingController();
  TextEditingController about = TextEditingController();
  TextEditingController expertise = TextEditingController();
  TextEditingController registrationNumber = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController idProf = TextEditingController();
  TextEditingController certificate = TextEditingController();
  String? dropdownValue;
  String? idProfDocumentUrl;
  String? idTypeDropdownValue;
  File? image;
  var dio = Dio();
  List dropDownOptions = [
    'Male',
    'Female',
    'Others',
  ];

  List idTypeDropDownOptions = [
    'Aadhaar Card',
    'Driving License',
    'Voter Id',
  ];

  List<String> certificateList = [];

  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    fetchUserData(context);
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Your Profile',
      ),
      body: Consumer<UserData>(builder: (context, data, child) {
        String date = data.userData.dob != null
            ? dateConvertTextFormat(data.userData.dob!)
            : "";
        if (dob.text == "") {
          dob.text = date;
        }

        dropdownValue = data.userData.gender ?? "select";

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          bool result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const UploadProfileImage();
                          }));

                          if (result == true) {
                            fetchUserData(context);
                          }
                        },
                        borderRadius: BorderRadius.circular(62),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFff7f3f),
                                  radius: 68,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 64,
                                    child: data.userData.imageUrl == null ||
                                            data.userData.imageUrl!.isEmpty
                                        ? const CircleAvatar(
                                            backgroundImage: AssetImage(
                                              'assets/icons/pfp_placeholder.jpg',
                                            ),
                                            radius: 60,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                data.userData.imageUrl!),
                                            radius: 60,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            kSharedPreferences.getString("role") ==
                                    "ROLE_EXPERT"
                                ? const SizedBox()
                                : const Positioned(
                                    top: 100,
                                    left: 95,
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFFff7f3f),
                                      radius: 18,
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  editField(
                      context,
                      "First Name",
                      data.userData.firstName!,
                      'Enter your first name',
                      "Enter your name",
                      firstNameController),
                  const SizedBox(height: 12),
                  editField(
                      context,
                      "Last Name",
                      data.userData.lastName!,
                      "Enter your last name",
                      'Enter your last name',
                      lastNameController),
                  const SizedBox(height: 12),
                  editField(
                      context,
                      "Mobile No.",
                      data.userData.mobile!,
                      "Enter your mobile no.",
                      'Enter your mobile no.',
                      mobileController),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Gender",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField(
                          isDense: true,
                          items: dropDownOptions
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20,fontWeight: FontWeight.w500),
                                // style: const TextStyle(
                                //   color:
                                //   fontSize: 20,
                                //   fontWeight: FontWeight.w500,
                                //   fontFamily: 'OpenSans',
                                // ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          value: dropdownValue,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20,fontWeight: FontWeight.normal),

                          // TextStyle(
                          //   color:
                          //   fontSize: 20,
                          //   fontWeight: FontWeight.w500,
                          //   fontFamily: 'OpenSans',
                          // ),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            constraints: BoxConstraints(
                              maxHeight: 56,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          hint: Text(
                            data.userData.gender ?? "Gender",
                            style : Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20,fontWeight: FontWeight.w500),
                            // style:  TextStyle(
                            //   color:
                            //   fontSize: 20,
                            //   fontWeight: FontWeight.w500,
                            //   fontFamily: 'OpenSans',
                            // ),
                          ),
                          onSaved: (value) {
                            getGenderValue(dropdownValue!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "DOB",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 50,
                          child: TextFormField(
                            controller: dob,
                            onTap: () => dateTap(context, dob),
                            readOnly: true,
                            validator: (newValue) {
                              if (newValue!.isEmpty) {
                                return "Select a date";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              hintText: "Select a date",
                              hintStyle: TextStyle(
                                color: Color(0xFF959EAD),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  editField(context, "Address", data.userData.address ?? "",
                      "Enter your address", "Enter your address", address),
                  const SizedBox(height: 12),
                  editField(context, "City", data.userData.city ?? "",
                      'Enter your city', 'Enter your city', city),
                  const SizedBox(height: 12),
                  editField(context, "State", data.userData.state ?? "",
                      "Enter your State", "Enter your State", state),
                  const SizedBox(height: 12),
                  editField(
                      context,
                      "Pincode",
                      data.userData.pincode.toString() ?? "",
                      "Enter your Pincode",
                      "Enter your Pincode",
                      pinCode),
                  const SizedBox(height: 12),
                  editField(context, "Country", data.userData.country ?? "",
                      "Enter your Country", "Enter your Country", country),
                  const SizedBox(height: 12),
                  if (data.userData.roles![0]["name"] == "expert")
                  Column(
                    children: [
                      editField(context, "About", data.userData.about ?? "",
                          "Enter your About", "Enter your About", about),
                      const SizedBox(height: 12),
                      editField(
                          context,
                          "Consultation Charges",
                          data.userData.consultationCharge ?? "",
                          "Enter your Consultation Charges",
                          "Enter your Consultation Charges",
                          consultationCharge),
                      const SizedBox(height: 12),
                      editField(
                          context,
                          "Expertise",
                          "",
                          "Enter your Expertise",
                          "Enter your Expertise",
                          expertise),
                      const SizedBox(height: 12),
                      editField(
                          context,
                          "Registration Number",
                          "",
                          "Enter your Registration Number",
                          "Enter your Registration Number",
                          registrationNumber),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "Certificate",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                controller: certificate,
                                onTap: () => imagePickerCertificate(ImageSource.gallery),
                                readOnly: true,
                                validator: (newValue) {
                                  if (newValue!.isEmpty) {
                                    return "Upload your Certificate";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  hintText: "Upload your Certificate",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF959EAD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      editField(
                          context,
                          "ID Number",
                          "",
                          "Enter your Id Number",
                          "Enter your Id Number",
                          idNumber),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "ID Type",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField(
                              isDense: true,
                              items: idTypeDropDownOptions
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20,fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  idTypeDropdownValue = newValue!;
                                });
                              },
                              value: idTypeDropdownValue,
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20,fontWeight: FontWeight.w500),
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                constraints: BoxConstraints(
                                  maxHeight: 56,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              hint: Text(
                                data.userData.gender ?? "Gender",
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20,fontWeight: FontWeight.w500),
                              ),
                              onSaved: (value) {
                                getIdTypeValue(idTypeDropdownValue!);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "ID Proof",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                controller: idProf,
                                onTap: () => imagePicker(ImageSource.gallery),
                                readOnly: true,
                                validator: (newValue) {
                                  if (newValue!.isEmpty) {
                                    return "Upload your ID Proof";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal),
                                  ),
                                  hintText: "Upload your ID Proof",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF959EAD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            onSubmit(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                          ),
                          child: Text(
                            'Update',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: whiteColor,
                                ),
                          ),
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  var _isLoading = false;

  void onSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (!_key.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    _key.currentState!.save();

    Map<String, dynamic> data = {
      "set": {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "mobileNo": mobileController.text,
        "gender": dropdownValue,
        "dob": selectedDate,
        "address": address.text,
        "city": city.text,
        "state": state.text,
        "pinCode": pinCode.text,
        "country": country.text,
        "registrationNumber": registrationNumber.text,
        "documentNumber": idNumber.text,
        "documentType": idTypeDropdownValue,
        "documentProof": idProfDocumentUrl,
        "certificates": certificateList,
      }
    };
    await UpdateProfile.updateProfile(context, data, onSuccess: () {
      fetchUserData(context);
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future imagePicker(ImageSource imgSource) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      final galleryimage = await ImagePicker().pickImage(
        source: imgSource,
        imageQuality: 20,
      );

      if (galleryimage == null) {
        return;
      }
      final permanentImage = await savePermanentImage(galleryimage.path);
      setState(() {
        image = permanentImage;
      });

      idProf.text = image!.path.toString();

      log(image!.path.toString());
      await uploadImage(image!);
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to choose image!');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  Future imagePickerCertificate(ImageSource imgSource) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      final galleryimage = await ImagePicker().pickImage(
        source: imgSource,
        imageQuality: 20,
      );

      if (galleryimage == null) {
        return;
      }
      final permanentImage = await savePermanentImage(galleryimage.path);
      setState(() {
        image = permanentImage;
      });

      log(image!.path.toString());
      await uploadImageCertificate(image!);
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Failed to choose image!');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  Future<File> savePermanentImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  Future<void> uploadImageCertificate(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.post("${ApiUrl.wm}upload", data: formData);

      var responseData = response.data;
      String url = responseData["data"]["location"];

      certificateList.add(url);
      certificate.text = certificateList.join(",");
      log(responseData.toString());
      log('Image uploaded');
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload image");
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

      idProfDocumentUrl = url;
      log(responseData.toString());
      log('Image uploaded');
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload image");
    }
  }

  Widget editField(
      BuildContext context,
      String title,
      String? value,
      String hintText,
      String validationText,
      TextEditingController controller) {
    controller.text = value!;
    void getValue(String v) {
      log(v);
      controller.text = v;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Container(
            height: 50,
            child: TextFormField(
              controller: controller,
              //initialValue: initValue,
              onSaved: (newValue) => getValue(newValue!),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return validationText;
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Date Picker
  dateTap(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate = DateFormat("MM/dd/yyyy").format(picked);
      // String formattedDate = DateFormat("MM/dd/yyyy").format(picked);
      // DateTime tempDate = DateFormat("MM/dd/yyyy").parse(picked);
      String date = DateFormat("EEE, MMM d ''yy").format(picked);
      setState(() {
        controller.text = date;
      });
    }
  }

  Widget editFieldDate(
      BuildContext context,
      String title,
      String? value,
      String? originalValue,
      String hintText,
      String validationText,
      TextEditingController controller) {
    controller.text = value!;
    void getDateValue(String v) {
      log("aaa: $v");
      controller.text = v;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Container(
            height: 50,
            child: TextFormField(
              controller: controller,
              onTap: () {
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
                  initialDate: originalValue!.isEmpty
                      ? DateTime.now()
                      : DateFormat("MM/dd/yyyy").parse(originalValue),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    print("value : $value");
                    String date = DateFormat("MM/dd/yyyy").format(value);
                    print("value 1: $date");
                    controller.text = dateConvertTextFormat(date);
                    log(date);
                    //getDateValue(dob.text);
                  });
                });
              },
              readOnly: true,
              onSaved: (newValue) => getDateValue(newValue!),
              validator: (newValue) {
                if (newValue!.isEmpty) {
                  return validationText;
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getGenderValue(String v) {
    log(v);
    dropdownValue = v;
  }

  void getIdTypeValue(String v) {
    log(v);
    idTypeDropdownValue = v;
  }
}
