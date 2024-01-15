import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/update_profile.dart';

import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/edit_profile_text_fields.dart';

// ignore: must_be_immutable
class EditStateScreen extends StatefulWidget {
  String? title, value;

  EditStateScreen({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  State<EditStateScreen> createState() => _EditStateScreenState();
}

class _EditStateScreenState extends State<EditStateScreen> {
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
      "set": {
        "state": widget.value!,
      }
    };
    await UpdateProfile.updateProfile(context, data, onSuccess: () => Navigator.of(context).pop());
    setState(() {
      _isLoading = false;
    });
  }

  void getValue(String v) {
    log(v);
    widget.value = v;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomEditAppBar(
          appBarTitle: "Edit state",
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
                    child: StateTextField(
                      func: getValue,
                      initValue: widget.value!,
                    ),
                  ),
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
