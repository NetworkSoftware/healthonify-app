import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/rzp.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/packages.dart';
import 'package:healthonify_mobile/providers/physiotherapy/consult_now_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/other/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PackagesCard extends StatefulWidget {
  final PhysioPackage data;
  const PackagesCard({Key? key, required this.data}) : super(key: key);

  @override
  State<PackagesCard> createState() => _PackagesCardState();
}

class _PackagesCardState extends State<PackagesCard> {
  late Razorpay _razorpay;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, Rzp.handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, Rzp.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, Rzp.handleExternalWallet);
  }

  Future<void> _submitConsultForm() async {
    Rzp.openCheckout(widget.data.price!, "Hey", "rzp_test_ZyEGUT3SkQbtE6", "",
        _razorpay, "cId", context, widget.data.expertId!,
        uid: "", f: "packages");
    setState(() => _isLoading = true);
    var userData = Provider.of<UserData>(context, listen: false).userData;

    Map<String, dynamic> data = {
      "userId": userData.id!,
      "packageId": widget.data.id,
      "startDate": DateFormat("MM/dd/yyyy").format(DateTime.now()),
      "gstAmount": int.parse(widget.data.price!) * 0.18,
      "grossAmount":
          int.parse(widget.data.price!) - int.parse(widget.data.price!) * 0.18,
      "discount": 0,
      "netAmount": int.parse(widget.data.price!)
    };
    // log(data.toString());
    try {
      await Provider.of<ConsultNowData>(context, listen: false)
          .subscribePackage(data, "physio")
          .then((paymentData) => Rzp.openCheckout(
              widget.data.price!,
              "Purchase Package",
              "rzp_test_ZyEGUT3SkQbtE6",
              paymentData.rzpOrderId!,
              _razorpay,
              paymentData.subscriptionId,
              context,
              widget.data.expertId!,
              uid: userData.id!));
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
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.data.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          if (widget.data.packageDurationInWeeks != null)
                            const Icon(Icons.timelapse),
                          const SizedBox(
                            width: 5,
                          ),
                          if (widget.data.packageDurationInWeeks != null)
                            Text(
                              "${widget.data.packageDurationInWeeks} weeks",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          const SizedBox(
                            width: 15,
                          ),
                          if (widget.data.sessionCount != null)
                            const Icon(Icons.group),
                          const SizedBox(
                            width: 5,
                          ),
                          if (widget.data.sessionCount != null)
                            Text(
                              "${widget.data.sessionCount}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    Text(
                      widget.data.benefits!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(
                              "\u{20B9}${widget.data.price!}",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : GradientButton(
                                    title: "Buy Now",
                                    func: () => _submitConsultForm(),
                                    gradient: purpleGradient),
                          ],
                        )
                      ],
                    )

                    // Center(
                    //   child: TextButton(
                    //     onPressed: () {
                    //       _submitConsultForm();
                    //     },
                    //     child: const Text(
                    //       'Buy Now',
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
}
