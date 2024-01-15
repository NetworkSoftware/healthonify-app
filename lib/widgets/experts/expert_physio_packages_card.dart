import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/expert/assign_package.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/packages.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';

class ExpertPhysioPackagesCard extends StatefulWidget {
  final PhysioPackage data;
  final User expertData;
  final String userIdToAssign;
  final String consultationId;

  const ExpertPhysioPackagesCard(
      {Key? key,
      required this.data,
      required this.expertData,
      required this.consultationId,
      required this.userIdToAssign})
      : super(key: key);

  @override
  State<ExpertPhysioPackagesCard> createState() =>
      _ExpertPhysioPackagesCardState();
}

class _ExpertPhysioPackagesCardState extends State<ExpertPhysioPackagesCard> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> data = {
    // "name": "",
    // "email": "",
    // "mobileNo": "",
    "consultationId": "",
    "expertId": "",
    "userId": "",
    "packageId": "",
    "startDate": "",
    "grossAmount": 0,
    "gstAmount": 0,
    "discount": 0,
    "netAmount": 0
  };

  void _onSubmit() {
    data["name"] = widget.expertData.firstName;
    data["email"] = widget.expertData.email;
    data["mobileNo"] = widget.expertData.mobile;
    data["consultationId"] = widget.consultationId;
    // data["expertId"] = widget.data.expertId;
    data["userId"] = widget.userIdToAssign;
    data["packageId"] = widget.data.id;
    data["startDate"] = DateFormat("MM/dd/yyyy").format(DateTime.now());
    data["grossAmount"] = int.parse(widget.data.price!);
    data["gstAmount"] = 0;
    data["discount"] = 0;
    data["netAmount"] = int.parse(widget.data.price!);

    log(data.toString());

    getFunc(context);
  }

  Future<void> getFunc(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // log("Hey");
    try {
      await AssignPackage.physioAssignPackage(data);
      Fluttertoast.showToast(msg: "Package Assigned");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get sessions $e");
      Fluttertoast.showToast(msg: "Failed to assign to user");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Description : ',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            widget.data.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timelapse),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${widget.data.packageDurationInWeeks!} weeks",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.group),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.data.sessionCount!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\u{20B9}${widget.data.price!}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Benefits : ',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            widget.data.benefits!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _isLoading
                            ? const CircularProgressIndicator()
                            : GradientButton(
                                title: "Assign to user",
                                func: () {
                                  showBtmSheet();
                                },
                                gradient: blueGradient),
                      ],
                    ),

                    // Center(
                    //   child: TextButton(
                    //     onPressed: () {
                    //       // _onSubmit();
                    //       showBtmSheet();
                    //     },
                    //     child: const Text(
                    //       'Assign to user',
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool noContent = false;

  Future<void> getUsers(BuildContext context) async {
    try {
      await Provider.of<UserData>(context, listen: false)
          .getUsers("6229a980305897106867f787");
      noContent = false;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to load experts");
      noContent = true;
    } catch (e) {
      log("Error store session $e");
      Fluttertoast.showToast(msg: "Unable to load experts");
      noContent = true;
    }
  }

  showBtmSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FutureBuilder(
        future: getUsers(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Choose an expert",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                        Consumer<UserData>(
                          builder: (context, value, child) => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.users.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                data["expertId"] = value.users[index].id!;
                                _onSubmit();
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                    "${value.users[index].firstName!} ${value.users[index].lastName!}"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
