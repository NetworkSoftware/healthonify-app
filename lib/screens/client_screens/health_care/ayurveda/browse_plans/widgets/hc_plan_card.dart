import 'dart:developer';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:healthonify_mobile/func/rzp.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_plans/health_care_plans_provider.dart';
import 'package:healthonify_mobile/providers/store_payment.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/my_care_plan/my_care_plan_screen.dart';
import 'package:healthonify_mobile/screens/payment_success.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/payment_models/payment_models.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

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
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentPlanSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, Rzp.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, Rzp.handleExternalWallet);
  }

  handlePaymentPlanSuccess(PaymentSuccessResponse response) async {
    print("Signature : ${response.signature}");
    print("Order ID : ${response.signature}");
    print("Payment Id : ${response.paymentId}");
    log(" Success ");
    Fluttertoast.showToast(msg: "Payment Succesful");
    await saveWorkoutPayment(
            response.paymentId!, response.signature!, response.orderId!)
        .then((value) {
      showCupertinoDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            "Ticket Number : ${storePaymentResponse.ticketNumber}",
            style: const TextStyle(fontSize: 18),
          ),
          content: Text(
            storePaymentResponse.message!,
            style: const TextStyle(fontSize: 16),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(
                  context, /*rootnavigator: true*/
                ).push(MaterialPageRoute(builder: (context) {
                  return const MyCarePlanScreen(
                    title: "My Subcriptions",
                  );
                }));
              },
              child: const Text("Go To My Subscription"),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    });
    //Navigator.of(context).pop();

    return;
  }

  Future<void> saveWorkoutPayment(
      String payId, String paySign, String orderId) async {
    Map<String, String> data = {
      "razorpay_payment_id": payId,
      "razorpay_order_id": orderId,
      "razorpay_signature": paySign,
      "ticketNumber": paymentData.ticketNumber!,
      "flow": paymentData.flow!,
    };

    log(data.toString());

    try {
      //await StorePayment.storePayment(data, "diet");
      storePaymentResponse = await StorePayment.storePlanPayment(data, "diet");
      Fluttertoast.showToast(msg: "Payment Succesful");
    } on HttpException catch (e) {
      log("  $e");
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error save payment data $e");
      Fluttertoast.showToast(msg: "Payment failed");
    }
  }

  Map<String, dynamic> purchasePlan = {};

  void onPurchase({required String packageId}) {
    purchasePlan["userId"] = userId;
    purchasePlan["packageId"] = packageId;
    purchasePlan["startDate"] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    purchasePlan["startTime"] = DateFormat('HH:mm').format(DateTime.now());
    purchasePlan["flow"] = widget.planName;
    // purchasePlan["discount"] = "0";

    log("Purchase Plan : ${purchasePlan.toString()}");
    buyPlan();
  }

  PaymentModel paymentData = PaymentModel();
  StorePaymentResponse storePaymentResponse = StorePaymentResponse();

  Future<void> buyPlan() async {
    try {
      paymentData =
          await Provider.of<HealthCarePlansProvider>(context, listen: false)
              .purchaseHealthCarePackage(purchasePlan);

      goToPayment();
      // popFunction();
      Fluttertoast.showToast(msg: 'Plan payment initiated');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e, trace) {
      log(e.toString());
      log("TRace : ${trace.toString()}");
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10,right: 5),
                  child: Text(
                    widget.healthCarePlansModel.name ?? "",
                    // overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              widget.healthCarePlansModel.mediaLink == null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Image.asset(
                        'assets/images/sample_helthcre.jpg',
                        height: 110,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Image.network(
                        widget.healthCarePlansModel.mediaLink!,
                        height: 110,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Benefits - ',
                      style: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.healthCarePlansModel.benefits ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontSize: 14),
                        )
                      ]),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                      text: 'Sessions - ',
                      style: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.healthCarePlansModel.sessionCount ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontSize: 14),
                        )
                      ]),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                      text: 'Duration - ',
                      style: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: "${widget.healthCarePlansModel.durationInDays ?? ""} days",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontSize: 14),
                        )
                      ]),
                ),
              ],
            ),
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
                        style: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              // 'Description - ${widget.healthCarePlansModel
              //     .description ?? ""}',
              //overflow: TextOverflow.ellipsis,
              'Description -',
              style: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ReadMoreText(
              widget.healthCarePlansModel.description ?? "",
              trimLines: 7,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              lessStyle: const TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 14
              ),
              moreStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: orange),
            ),
          ),
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
