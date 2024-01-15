import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:image_cropper/image_cropper.dart';

class AddRecordDetails extends StatelessWidget {
  final CroppedFile? croppedImg;
  const AddRecordDetails({this.croppedImg, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File? image = File(croppedImg!.path);
    String? dropDownValue1;
    List<String> dropDownOptions1 = [
      'Thyrocare Report',
      'SRL Report',
      'Lab Report',
      'Prescription',
      'HRA',
      'ECG',
      'Hospital Records',
      'Other',
    ];
    String? dropDownValue2;
    List<String> dropDownOptions2 = [
      'Cardiac',
      'Dental',
      'Diabetic',
      'Eye',
      'Gynaecology',
      'Medicine',
      'Pediatric',
      'Skin',
      'Other'
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Upload health record details'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SizedBox(
                height: 125,
                width: 125,
                child: Image.file(image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: textField(context, 'Health record name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Record Type'),
                  StatefulBuilder(
                    builder: (context, newState) => SizedBox(
                      width: 172,
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: dropDownOptions1
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          newState(() {
                            dropDownValue1 = newValue!;
                          });
                        },
                        value: dropDownValue1,
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
                            maxHeight: 36,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Record related to'),
                  StatefulBuilder(
                    builder: (context, newState) => SizedBox(
                      width: 172,
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: dropDownOptions2
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          newState(() {
                            dropDownValue2 = newValue!;
                          });
                        },
                        value: dropDownValue2,
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
                            maxHeight: 36,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Add Records'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(context, String hint) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFC3CAD9),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: 46,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF959EAD),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'OpenSans',
        ),
      ),
      onSaved: (value) {},
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter the $hint';
        }
        return null;
      },
    );
  }
}
