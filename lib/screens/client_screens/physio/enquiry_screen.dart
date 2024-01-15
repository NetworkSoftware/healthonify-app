import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/enquiry_text_fields.dart';
import 'package:provider/provider.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  final Map<String, String> _enqData = {
    "name": "",
    "email": "",
    "contactNo": "",
    "message": "",
    "enquiryFor": "",
    "category": "",
  };

  void getName(String name) => _enqData['name'] = name;
  void getEmail(String email) => _enqData['email'] = email;
  void getNumber(String phNumber) => _enqData['contactNo'] = phNumber;
  void getMessage(String msg) => _enqData['message'] = msg;
  void getFor(String enqFor) => _enqData['enquiryFor'] = enqFor;
  void getCategory(String catgy) => _enqData['category'] = catgy;

  void enqSubmit(BuildContext context) {
    isLoading = true;
    if (_formKey.currentState!.validate()) {
      isLoading = false;
      return;
    }
    _formKey.currentState!.save();
    enquiry(context);
    isLoading = false;
  }

  Future<void> enquiry(BuildContext context) async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(_enqData);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error enquiry widget $e");
      Fluttertoast.showToast(msg: "Unable to submit enquiry form");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
         
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                EnquiryName(getValue: getName),
                const SizedBox(height: 12),
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                EnquiryEmail(getValue: getEmail),
                const SizedBox(height: 12),
                Text(
                  'Contact Number',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                EnquiryContact(getValue: getNumber),
                const SizedBox(height: 12),
                Text(
                  'Message',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                EnquiryMessage(getValue: getMessage),
                const SizedBox(height: 12),
                Text(
                  'Enquiry for',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                EnquiryFor(getValue: getFor),
                const SizedBox(height: 12),
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                EnquiryCategory(getValue: getCategory),
                const SizedBox(height: 12),
                Center(
                  child: EnquirySubmit(
                    submit: enqSubmit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
