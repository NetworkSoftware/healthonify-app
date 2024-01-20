import 'dart:developer';

import "package:flutter/material.dart";
import 'package:healthonify_mobile/func/rzp.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_plans/health_care_plans_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/payment_models/payment_models.dart';
import 'package:intl/intl.dart';

class HcPlanCard extends StatefulWidget {
  final HealthCarePlansModel healthCarePlansModel;
  final String? planName;

  const HcPlanCard(
      {super.key, required this.healthCarePlansModel, this.planName});

  @override
  State<HcPlanCard> createState() => _HcPlanCardState();
}

class _HcPlanCardState extends State<HcPlanCard> {
  @override
  Widget build(BuildContext context) {
    return healthCareServiceCard();
  }

  late String userId;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, Rzp.handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, Rzp.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, Rzp.handleExternalWallet);
  }

  Map<String, dynamic> purchasePlan = {};

  void onPurchase({required String packageId}) {
    purchasePlan["userId"] = userId;
    purchasePlan["packageId"] = packageId;
    purchasePlan["startDate"] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    purchasePlan["startTime"] = DateFormat('HH:mm').format(DateTime.now());
    purchasePlan["flow"] = widget.planName;
    purchasePlan["discount"] = "0";

    log("Purchase Plan : ${purchasePlan.toString()}");
    buyPlan();
  }

  PaymentModel paymentData = PaymentModel();

  Future<void> buyPlan() async {
    try {
      paymentData =
          await Provider.of<HealthCarePlansProvider>(context, listen: false)
              .purchaseHealthCarePackage(purchasePlan);

      goToPayment();
      popFunction();
      Fluttertoast.showToast(msg: 'Plan payment initiated');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to purchase plan');
    } finally {}
  }

  void popFunction() {
    Navigator.pop(context);
  }

  void goToPayment() {
    Rzp.openCheckout(
      paymentData.amountDue!,
      "HC plan purchase payment",
      "rzp_test_ZyEGUT3SkQbtE6",
      paymentData.razorpayOrderId!,
      _razorpay,
      paymentData.subscriptionId,
      context,
      "",
      uid: "",
      f: widget.planName!,
    );
  }

  Widget healthCareServiceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      widget.healthCarePlansModel.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Description - ${widget.healthCarePlansModel.description ?? ""}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Benefits - ${widget.healthCarePlansModel.benefits ?? ""}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Sessions - ${widget.healthCarePlansModel.sessionCount ?? ""}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Duration - ${widget.healthCarePlansModel.durationInDays ?? ""} days',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            widget.healthCarePlansModel.mediaLink == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.network(
                      widget.healthCarePlansModel.mediaLink!,
                      height: 110,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
          ],
        ),
        widget.healthCarePlansModel.services!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Services -',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.healthCarePlansModel.services!.length,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            '${idx + 1}. ${widget.healthCarePlansModel.services![idx].serviceName}'),
                      );
                    },
                  ),
                ],
              )
            : const SizedBox(),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹ ${widget.healthCarePlansModel.price ?? ""}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                GradientButton(
                  func: () {
                    onPurchase(packageId: widget.healthCarePlansModel.id!);
                  },
                  title: 'Purchase',
                  gradient: orangeGradient,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
