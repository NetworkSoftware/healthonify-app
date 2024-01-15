import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/physio_packages_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/num_picker.dart';
import 'package:healthonify_mobile/widgets/text%20fields/create_package_fields.dart';
import 'package:provider/provider.dart';

class CreatePackage extends StatefulWidget {
  final String? expertId, expertiseId;
  const CreatePackage({
    Key? key,
    required this.expertId,
    required this.expertiseId,
  }) : super(key: key);

  @override
  State<CreatePackage> createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  int _packageDurationValue = 1;
  int _noOfSessionsValue = 1;
  final _key = GlobalKey<FormState>();

  final Map<String, dynamic> _packageData = {
    "name": "",
    "expertId": "",
    "expertiseId": "",
    "price": "",
    "packageDurationInWeeks": 1,
    "sessionCount": 1,
    "description": "",
    "benefits": "",
    "isActive": true,
    "frequency": "fortnight"
  };

  void getPackageDurationValue(int i) => setState(() {
        log(i.toString());
        _packageDurationValue = i;
      });

  void getNoOfSessionsValue(int i) => setState(() => _noOfSessionsValue = i);
  void getName(String value) => _packageData["name"] = value;
  void getPrice(String value) => _packageData["price"] = value;
  void getDesc(String value) => _packageData["description"] = value;
  void getBenefits(String value) => _packageData["benefits"] = value;

  void onSubmit() {
    if (!_key.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    _packageData["packageDurationInWeeks"] = _packageDurationValue;
    _packageData["sessionCount"] = _noOfSessionsValue.toString();
    _packageData["expertId"] = widget.expertId;
    _packageData["expertiseId"] = widget.expertiseId;
    _key.currentState!.save();
    log(_packageData.toString());
    createPackage(context, _packageData);
  }

  void popFunc() {
    Navigator.of(context).pop();
  }

  Future<void> createPackage(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      await Provider.of<PhysioPackagesData>(context, listen: false)
          .createPackage(data);
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get func widget $e");
      Fluttertoast.showToast(msg: "Unable to save your package");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Create Package',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(children: [
          Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpertPackageTextField(
                  getFunc: getName,
                  hint: "Enter the package name",
                  title: "Package name",
                ),
                const SizedBox(
                  height: 10,
                ),
                PriceField(getPrice: getPrice),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('Package duration'),
                          ChoosePackageDurationBtn(
                            func: showBottomSheet,
                            getV: getPackageDurationValue,
                            val: _packageDurationValue,
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      Column(
                        children: [
                          const Text('No of sessions'),
                          PackageSessionsBtn(
                            func: showBottomSheet,
                            getV: getNoOfSessionsValue,
                            val: _noOfSessionsValue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DescField(getDesc: getDesc),
                const SizedBox(
                  height: 10,
                ),
                BenefitsField(getBenefits: getBenefits),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: SaveButton(
                    isLoading: false,
                    submit: onSubmit,
                    title: "Create Package",
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void showBottomSheet(
    context,
    String title,
    Function getVal,
    int minVal,
    int maxVal,
    int intialVal,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            NumPicker(
              minimumValue: minVal,
              maximumValue: maxVal,
              getNumber: getVal,
              initVal: intialVal,
            ),
          ],
        );
      },
    );
  }
}
