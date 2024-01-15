import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/placeholder_images.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/rzp.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/payment_models/payment_models.dart';
import 'package:healthonify_mobile/providers/health_care/ayurveda_provider/ayurveda_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_plans_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BuyAyurvedaPlan extends StatefulWidget {
  final AyurvedaPlansModel plan;
  const BuyAyurvedaPlan({Key? key, required this.plan}) : super(key: key);

  @override
  State<BuyAyurvedaPlan> createState() => _BuyAyurvedaPlanState();
}

class _BuyAyurvedaPlanState extends State<BuyAyurvedaPlan> {
  late Razorpay _razorpay;
  Map<String, dynamic> purchasePlan = {};
  PaymentModel paymentData = PaymentModel();

  void onPurchase() {
    purchasePlan["userId"] =
        Provider.of<UserData>(context, listen: false).userData.id!;
    purchasePlan["planId"] = widget.plan.id;
    purchasePlan["startDate"] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    purchasePlan["grossAmount"] = widget.plan.price;
    purchasePlan["gstAmount"] = 0;
    purchasePlan["netAmount"] = widget.plan.price;
    purchasePlan["discount"] = 0;
    log(purchasePlan.toString());
    buyPlan();
  }

  Future<void> buyPlan() async {
    LoadingDialog().onLoadingDialog("Please wait", context);
    try {
      paymentData = await Provider.of<AyurvedaProvider>(context, listen: false)
          .purchaseAyurvedaPackage(purchasePlan);
      goToPayment();
      popFunction();
      Fluttertoast.showToast(msg: 'Plan payment initiated');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to purchase plan');
    } finally {
      popFunction();
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  void goToPayment() {
    Rzp.openCheckout(
      paymentData.amountDue!,
      "Ayurveda plan purchase payment",
      "rzp_test_ZyEGUT3SkQbtE6",
      paymentData.razorpayOrderId!,
      _razorpay,
      paymentData.subscriptionId,
      context,
      "",
      uid: "",
      f: "ayurved",
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, Rzp.handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, Rzp.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, Rzp.handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Buy Plan',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${widget.plan.name}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '₹${widget.plan.price}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[200],
                indent: 8,
                endIndent: 8,
                height: 30,
              ),
              // Container(
              //   height: 200,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     gradient: const LinearGradient(
              //       colors: [
              //         whiteColor,
              //         Colors.grey,
              //       ],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     image: const DecorationImage(
              //       image: AssetImage('assets/icons/play.png'),
              //     ),
              //   ),
              // ),

              CachedNetworkImage(
                height: 200,
                imageUrl: widget.plan.mediaLink!,
                errorWidget: (context, url, error) => Image.network(
                  placeholderImg,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "${widget.plan.description}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Included in the plan',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              ListView.builder(
                itemCount: widget.plan.included!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "${index + 1}. ${widget.plan.included![index]}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GradientButton(
                      title: 'Request Appointment',
                      func: () {},
                      gradient: blueGradient,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: GradientButton(
                      title: 'Buy Plan',
                      func: () {
                        onPurchase();
                      },
                      gradient: orangeGradient,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
