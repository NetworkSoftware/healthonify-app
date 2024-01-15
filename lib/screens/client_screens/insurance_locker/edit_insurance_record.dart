import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/insurance_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/insurance_locker/insurance_provider.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditInsuranceRecord extends StatefulWidget {
  final String recordId;
  final InsuranceModel insuranceRecord;
  const EditInsuranceRecord(
      {required this.recordId, required this.insuranceRecord, Key? key})
      : super(key: key);

  @override
  State<EditInsuranceRecord> createState() => _EditInsuranceRecordState();
}

class _EditInsuranceRecordState extends State<EditInsuranceRecord> {
  final formKey = GlobalKey<FormState>();

  String? insuranceCompany;
  String? type;
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
  List options = [
    'Life Insurance',
    'Health Insurance',
    'Motor Insurance',
  ];

  Map<String, dynamic> editRecord = {"set": {}};

  void popFunc() {
    Navigator.pop(context);
  }

  Future editRecordData() async {
    try {
      await Provider.of<InsuranceProvider>(context, listen: false)
          .updateInsuranceRecord(widget.recordId, editRecord);
      popFunc();
      Fluttertoast.showToast(msg: 'Insurance Record edited successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to edit insurance record');
    }
  }

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    if (ymdFormat == null) {
      Fluttertoast.showToast(msg: 'Please choose the new expiry date');
      return;
    }
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    editRecord["set"]["userId"] = userId;
    if (insuranceCompany != 'Other') {
      editRecord["set"]["insuranceCompanyName"] = insuranceCompany;
    } else {
      editRecord["set"]["insuranceCompanyName"] = insuranceCompanyName;
    }
    editRecord["set"]["insuranceType"] = type;
    if (ymdFormat != null) {
      editRecord["set"]["expiryDate"] = ymdFormat;
    }
    log(editRecord.toString());
    editRecordData();
  }

  TextEditingController dateController = TextEditingController();

  String? insuranceCompanyName;

  @override
  void initState() {
    super.initState();

    DateTime tempDate = DateFormat('yyyy-MM-dd')
        .parse(widget.insuranceRecord.expiryDate ?? '2022-20-20');
    String autofillDate = DateFormat('d MMM yyyy').format(tempDate);

    dateController.text = autofillDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Edit Insurance Record'),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: dropDownOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        insuranceCompany = newValue!;
                      });
                    },
                    value: insuranceCompany,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
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
                    hint: Text(
                        widget.insuranceRecord.insuranceCompanyName ?? "",
                        style: Theme.of(context).textTheme.bodySmall),
                    validator: (value) {
                      if (value == null) {
                        return 'Please choose an insurance company';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            insuranceCompany == 'Other'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: CustomTextField(
                        hint: 'Enter insurance company\'s name',
                        hintBorderColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            insuranceCompanyName = value;
                          });
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: DropdownButtonFormField(
                    isDense: true,
                    items: options.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        type = newValue!;
                      });
                    },
                    value: type,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
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
                    hint: Text(
                      widget.insuranceRecord.insuranceType ?? "",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please choose an insurance type';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
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
                      fillColor: Theme.of(context).canvasColor,
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: GradientButton(
                title: 'Update',
                func: insuranceCompany == 'Other' &&
                        insuranceCompanyName == null
                    ? () {
                        Fluttertoast.showToast(
                            msg: 'Please enter the insurance company\'s name');
                        return;
                      }
                    : () {
                        onSubmit();
                      },
                gradient: orangeGradient,
              ),
            ),
          ],
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
