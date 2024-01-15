import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/expert/assign_package.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/models/wm/wm_package.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/succes_screens/successful_update.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';

class ExpertWmPackagesCard extends StatefulWidget {
  final WmPackage data;
  final User expertData;
  final String userIdToAssign;
  final String consultationId;

  const ExpertWmPackagesCard(
      {Key? key,
      required this.data,
      required this.expertData,
      required this.consultationId,
      required this.userIdToAssign})
      : super(key: key);

  @override
  State<ExpertWmPackagesCard> createState() => _ExpertWmPackagesCardState();
}

class _ExpertWmPackagesCardState extends State<ExpertWmPackagesCard> {
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
    "netAmount": 0,
    "currency": "INR"
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
    data["startTime"] = DateFormat.Hms().format(DateTime.now());
    data["gstAmount"] = 0;
    data["discount"] = 0;
    data["netAmount"] = int.parse(widget.data.price!);

    log(data.toString());

    getFunc(context);
  }

  void onPackageAssigned() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SuccessfulUpdate(
            onSubmit: (context) {
              Navigator.of(context).pop();
            },
            title:
                "Package Assigned succesfully. Please wait for the user to complete the payment",
            buttonTitle: "Back"),
      ),
    );
  }

  Future<void> getFunc(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // log("Hey");
    try {
      await AssignPackage.wmAssignPackage(data);
      Fluttertoast.showToast(msg: "Package Assigned");
      onPackageAssigned.call();
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
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.name!,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  widget.data.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overview",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        "1. One on one doctor session : ${widget.data.doctorSessionCount}"),
                    Text(
                        "2. Fitness group session : ${widget.data.fitnessGroupSessionCount}"),
                    Text(
                        "3. Immunity booster councelling : ${widget.data.immunityBoosterCounselling}"),
                    Text(
                        "4. Personal Diet Plan : ${widget.data.dietSessionCount}"),
                    Text("5. Fitness plan : ${widget.data.fitnessPlan}"),
                    Text(
                        "6. Free access to group sessions : ${widget.data.freeGroupSessionAccess! ? "yes" : "no"}"),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timelapse),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              // "${widget.data.packageDurationInWeeks!} weeks",
                              "${widget.data.durationInDays!} days",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.data.frequency!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "\u{20B9}${widget.data.price!}",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : GradientButton(
                            title: "Assign",
                            func: () {
                              showBtmSheet();
                            },
                            gradient: blueGradient),
                  ],
                ),
              ],
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
          .getUsers("6229a968eb71920e5c85b0af");
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
