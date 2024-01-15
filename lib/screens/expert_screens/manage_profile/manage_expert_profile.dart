import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';

class ManageExpertProfileScreen extends StatefulWidget {
  const ManageExpertProfileScreen({Key? key}) : super(key: key);

  @override
  State<ManageExpertProfileScreen> createState() =>
      _ManageExpertProfileScreenState();
}

class _ManageExpertProfileScreenState extends State<ManageExpertProfileScreen> {
  String? speciality;
  List expertSpeciality = [
    'Speciality 1',
    'Speciality 2',
    'Speciality 3',
    'Speciality 4',
    'Speciality 5',
  ];
  String? educationalQualification;
  List qualification = [
    'SSLC',
    'PUC',
    'Degree',
    'Bachelors',
    'Masters',
    'PhD',
  ];

  Object? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Manage Profile'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child:
                  CustomTextField(hint: 'Name', hintBorderColor: Colors.grey),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child:
                  CustomTextField(hint: 'City', hintBorderColor: Colors.grey),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CustomTextField(
                  hint: 'Location', hintBorderColor: Colors.grey),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                isDense: true,
                items: expertSpeciality.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    speciality = newValue!;
                  });
                },
                value: speciality,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 56,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
                hint: Text(
                  'Speciality',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CustomTextField(
                  hint: 'Contact Number', hintBorderColor: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: Text('Experience')),
                  Expanded(
                    child: CustomTextField(
                        hint: 'years', hintBorderColor: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    value: 0,
                    groupValue: gender,
                    title: Text(
                      'Male',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: 1,
                    groupValue: gender,
                    title: Text(
                      'Female',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                isDense: true,
                items: qualification.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    educationalQualification = newValue!;
                  });
                },
                value: educationalQualification,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.25,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 56,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
                hint: Text(
                  'Qualification',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Upload proof',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  TextButton(
                    onPressed: () {},
                    child: const Text('upload'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: CustomTextField(
                  hint: 'Registration Details', hintBorderColor: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Upload proof',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  TextButton(
                    onPressed: () {},
                    child: const Text('upload'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: CustomTextField(
                  hint: 'Identity Proof', hintBorderColor: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Upload proof',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                  TextButton(
                    onPressed: () {},
                    child: const Text('upload'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Save'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
