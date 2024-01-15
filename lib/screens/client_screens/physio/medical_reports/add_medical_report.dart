import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicalReport extends StatefulWidget {
  const AddMedicalReport({Key? key}) : super(key: key);

  @override
  State<AddMedicalReport> createState() => _AddMedicalReportState();
}

class _AddMedicalReportState extends State<AddMedicalReport> {
  File? pickedImage;
  CroppedFile? cropFile;
  List<XFile>? multipleImages = [];
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

  Future getMultiImage() async {
    try {
      final List<XFile> multiImages = await ImagePicker().pickMultiImage(
        maxHeight: 1800,
        maxWidth: 1800,
      );
      setState(() {
        multipleImages!.addAll(multiImages);
      });
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
        });
      }
    }
  }

  void clearAllImages() {
    setState(() {
      pickedImage = null;
      multipleImages = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? dropDownValue;
    List<String> dropDownOptions = [
      'Option 1',
      'Option 2',
      'Option 3',
      'Option 4',
      'Option 5',
      'Option 6',
      'Option 7',
      'Option 8',
      'Option 9',
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Medical Report'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'UPLOAD MEDICAL REPORTS',
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    hint: const Text('Select'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 125,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: multipleImages == null && pickedImage == null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/images.png'),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            if (pickedImage != null)
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Image.file(
                                  File(pickedImage!.path),
                                ),
                              ),
                            if (multipleImages != null)
                              ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: multipleImages!.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Image.file(
                                        File(multipleImages![index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
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
                        getMultiImage();
                      },
                      child: const Text('UPLOAD'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      clearAllImages();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CANCEL',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CONFIRM'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
