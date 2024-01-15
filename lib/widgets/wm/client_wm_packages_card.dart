import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/rzp.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_package.dart';
import 'package:healthonify_mobile/providers/physiotherapy/consult_now_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/other/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ClientWmPackages extends StatefulWidget {
  final WmPackage data;

  const ClientWmPackages({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ClientWmPackages> createState() => _ClientWmPackagesState();
}

class _ClientWmPackagesState extends State<ClientWmPackages> {
  bool _isLoading = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, Rzp.handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, Rzp.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, Rzp.handleExternalWallet);
  }

  Future<void> _submitConsultForm() async {
    // Rzp.openCheckout(widget.data.price!, "Hey", "rzp_test_ZyEGUT3SkQbtE6", "",
    //     _razorpay, "cId", context, widget.data.expertId!,
    //     uid: "", f: "packages");
    setState(() => _isLoading = true);
    var userData = Provider.of<UserData>(context, listen: false).userData;

    Map<String, dynamic> data = {
      "userId": userData.id!,
      "packageId": widget.data.id,
      "startDate": DateFormat("MM/dd/yyyy").format(DateTime.now()),
      "startTime": DateFormat("hh:mm:ss").format(DateTime.now()),
      "expertId": widget.data.expertId,
      "gstAmount": int.parse(widget.data.price!) * 0.18,
      "grossAmount":
          int.parse(widget.data.price!) - int.parse(widget.data.price!) * 0.18,
      "discount": 0,
      "netAmount": int.parse(widget.data.price!),
      "currency": "INR"
    };
    log(data.toString());
    try {
      await Provider.of<ConsultNowData>(context, listen: false)
          .subscribePackage(data, "diet")
          .then((paymentData) => Rzp.openCheckout(
                widget.data.price!,
                "Purchase Package",
                "rzp_test_ZyEGUT3SkQbtE6",
                paymentData.rzpOrderId!,
                _razorpay,
                paymentData.subscriptionId,
                context,
                widget.data.expertId!,
                uid: userData.id!,
                f: "diet",
              ));
    } on HttpException catch (e) {
      log("http ppackages by health $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 2000),
          content: CustomSnackBarChild(
            title: e.message,
          ),
        ),
      );
    } catch (e) {
      log("Error submit consultation form$e");
      Fluttertoast.showToast(msg: "Consultation request failed");
    } finally {
      setState(() => _isLoading = false);
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
                            title: "Buy",
                            func: () {
                              _submitConsultForm();
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
}
