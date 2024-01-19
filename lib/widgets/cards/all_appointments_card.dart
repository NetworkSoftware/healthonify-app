import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:provider/provider.dart';

class AllAppoinmentsCard extends StatefulWidget {
  final Function onRequest;

  const AllAppoinmentsCard({required this.onRequest, Key? key})
      : super(key: key);

  @override
  State<AllAppoinmentsCard> createState() => _AllAppoinmentsCardState();
}

class _AllAppoinmentsCardState extends State<AllAppoinmentsCard> {
  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "",
    "flow": "",
  };

  @override
  void initState() {
    super.initState();
    getExpertise();
  }

  Future<void> getExpertise() async {
    Provider
        .of<ExpertiseData>(context, listen: false)
        .topLevelExpertiseData;
  }

  List options = [
    "Live Well",
    "Weight Management",
    "Fitness",
    "Health Care",
    "Physiotherapy",
    "Dietitian",
  ];
  final _form = GlobalKey<FormState>();

  void getMessage(String message) => data["message"] = message;

  Future<void> submitForm() async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(data);
      Fluttertoast.showToast(
          msg: "Appointment Requested, an expert will get back to you soon");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      // Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      Navigator.of(context).pop();
    }
  }

  void onSubmit() {
    if (!_form.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (selectedValue == null) {
      Fluttertoast.showToast(msg: "Please choose a value from the dropdown");
    }
    data["category"] = selectedValue!;
    if(selectedValue == "Live Well"){
    data["flow"] = "liveWell";
    }else if(selectedValue == "Weight Management"){
    data["flow"] = "manageWeight";
    }else if(selectedValue == "Fitness"){
    data["flow"] = "fitness";
    }else if(selectedValue == "Physiotherapy"){
    data["flow"] = "physioTherapy";
    }else if(selectedValue == "Health Care"){
    data["flow"] = "healthCare";
    }else{
    data["flow"] = "diet";
    }
    _form.currentState!.save();
    log(data.toString());
    submitForm();
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "";
    data["userId"] = userData.id!;
    data["flow"] = "";
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider
        .of<UserData>(context)
        .userData;
    setData(userData);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.98,
          child: Card(
            elevation: 5,
            color: const Color(0xFFec6a13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child:  Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(
                        MaterialPageRoute(
                          builder: (context) => AllAppointmentsScreen(flow: ''),
                        ),
                      );
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFec6a13))),
                              child: const Center(
                                child: Text(
                                  "View",
                                  style: TextStyle(
                                      color: Color(0xFFec6a13),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Appointments",
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelLarge!.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Book and View your appointments here',
                          //overflow: TextOverflow.ellipsis,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? selectedValue;

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        context: context,
        builder: (ctx) =>
            SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery
                            .of(ctx)
                            .viewInsets
                            .bottom + 1),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          "Request Appointment",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explain your issue",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IssueField(getValue: (value) {
                              data["message"] = value;
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, newState) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: DropdownButtonFormField(
                                isDense: true,
                                items:
                                options.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  newState(() {
                                    selectedValue = newValue!;
                                  });
                                },
                                value: selectedValue,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
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
                                  'Select',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ),
                      ),
                      Center(
                          child: SaveButton(
                            isLoading: false,
                            submit: onSubmit,
                            title: "Request Now",
                          )),
                    ]),
                  ),
                ),
              ),
            ));
  }
}
