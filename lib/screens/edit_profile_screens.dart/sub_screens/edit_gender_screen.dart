import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/update_profile.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

// ignore: must_be_immutable
class EditGenderScreen extends StatefulWidget {
  String? title, value;

  EditGenderScreen({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  State<EditGenderScreen> createState() => _EditGenderScreenState();
}

class _EditGenderScreenState extends State<EditGenderScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  var _isLoading = false;

  void onSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (!_key.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    _key.currentState!.save();

    log(widget.value!);
    Map<String, dynamic> data = {
      "set": {"gender": dropdownValue}
    };
    await UpdateProfile.updateProfile(context, data, onSuccess: () {
      Navigator.of(context).pop();
      log('gender updated');
    });
    setState(() {
      _isLoading = false;
    });
  }

  void getValue(String v) {
    log(v);
    widget.value = v;
  }

  String? dropdownValue;
  List dropDownOptions = [
    'Male',
    'Female',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomEditAppBar(
          appBarTitle: "Edit Gender",
          onSubmit: onSubmit,
          isLoading: _isLoading,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _key,
                    child: DropdownButtonFormField(
                      isDense: true,
                      items: dropDownOptions
                          .map<DropdownMenuItem<String>>((value) {
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
                          dropdownValue = newValue!;
                        });
                      },
                      value: dropdownValue,
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
                          maxHeight: 56,
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
                        widget.value ?? "Gender",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                      onSaved: (value) {
                        getValue(dropdownValue!);
                      },
                    ),
                  ),
                  // Form(
                  //   key: _key,
                  //   child: CountryTextField(
                  //     func: getValue,
                  //     initValue: widget.value!,
                  //   ),
                  // ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          ],
        ));
  }
}
