import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/rzp.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/payment_models/payment_models.dart';
import 'package:healthonify_mobile/providers/labs_provider/labs_provider.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class LabAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> labTestMap;
  const LabAppointmentScreen({Key? key, required this.labTestMap})
      : super(key: key);

  @override
  State<LabAppointmentScreen> createState() => _LabAppointmentScreenState();
}

class _LabAppointmentScreenState extends State<LabAppointmentScreen> {
  late Razorpay _razorpay;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  String? doorStreetNo;
  String? city;
  String? state;
  String? pincode;

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? selectedTime;
  String? todaysDate;

  TextEditingController timeController = TextEditingController();
  Map<String, dynamic> requestLabTestMap = {};

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, Rzp.handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, Rzp.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, Rzp.handleExternalWallet);
    requestLabTestMap = widget.labTestMap;
    todaysDate = DateFormat('d MMMM yyyy').format(DateTime.now());
  }

  PaymentModel paymentData = PaymentModel();

  Future<void> requestLabTest(BuildContext context) async {
    try {
      LoadingDialog().onLoadingDialog("Requesting...", context);

      paymentData = await Provider.of<LabsProvider>(context, listen: false)
          .requestLabTest(requestLabTestMap);
      goToPayment();
      popFunction();
      // popFunction();
      Fluttertoast.showToast(msg: 'Lab Test requested');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to request lab test');
    }
  }

  void goToPayment() {
    Rzp.openCheckout(
      paymentData.amountDue!,
      "Lab test payment",
      "rzp_test_ZyEGUT3SkQbtE6",
      paymentData.razorpayOrderId!,
      _razorpay,
      paymentData.labTestId,
      context,
      "",
      uid: "",
      f: "labTests",
    );
  }

  void popFunction() {
    Navigator.pop(context);
  }

  void onSubmit() {
    var tempDate = DateFormat('yyyy-MM-dd').parse(selectedDate);
    if (tempDate.isBefore(DateTime.now())) {
      Fluttertoast.showToast(msg: 'Please select a valid date');
      return;
    }
    requestLabTestMap['date'] = selectedDate;
    if (time24hrs != null) {
      requestLabTestMap['time'] = time24hrs;
    } else {
      Fluttertoast.showToast(msg: 'Please select a preferred time');
      return;
    }
    if (doorStreetNo != null &&
        city != null &&
        state != null &&
        pincode != null) {
      requestLabTestMap['address'] = {
        'doorNoAndStreetName': doorStreetNo,
        'city': city,
        'state': state,
        'pincode': pincode,
      };
    } else {
      Fluttertoast.showToast(msg: 'Please enter the address');
      return;
    }

    log(requestLabTestMap.toString());
    requestLabTest(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Request Appointment'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Day : $todaysDate',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: SizedBox(
                  height: 420,
                  child: CalendarCarousel(
                    pageSnapping: true,
                    customGridViewPhysics: const NeverScrollableScrollPhysics(),
                    weekendTextStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: orange),
                    weekdayTextStyle: Theme.of(context).textTheme.bodyMedium,
                    daysTextStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                    thisMonthDayBorderColor: Colors.grey,
                    onDayPressed: (DateTime date, List<Event> events) {
                      setState(() {
                        var dateFormat = DateFormat('yyyy-MM-dd').format(date);
                        selectedDate = dateFormat;
                      });
                      log(selectedDate.toString());
                    },
                    selectedDateTime:
                        DateFormat('yyyy-MM-dd').parse(selectedDate),
                    selectedDayTextStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                'Preferred Time',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  timePicker(context, timeController);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: timeController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      filled: true,
                      hintText: 'Time',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          timePicker(context, timeController);
                        },
                        child: const Text('PICK'),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: whiteColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: CustomTextField(
                hint: 'Door No/ Street No',
                hintBorderColor: Colors.grey,
                onChanged: (value) {
                  doorStreetNo = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: CustomTextField(
                hint: 'City',
                hintBorderColor: Colors.grey,
                onChanged: (value) {
                  city = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: CustomTextField(
                hint: 'State',
                hintBorderColor: Colors.grey,
                onChanged: (value) {
                  state = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: CustomTextField(
                hint: 'Pincode',
                hintBorderColor: Colors.grey,
                onChanged: (value) {
                  pincode = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: GradientButton(
                title: 'PAY NOW',
                func: () {
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

  String? time24hrs;

  void timePicker(context, TextEditingController controller) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        var selection = value;
        var format24hrTime =
            '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}';
        selectedTime = selection.format(context);
        time24hrs = format24hrTime;
        var tempDate =
            DateFormat('yyyy-MM-dd').parse(selectedDate).toString().split(' ');

        var todayDate = DateTime.now().toString().split(' ');

        if (tempDate[0] == todayDate[0]) {
          if (value.hour < (DateTime.now().hour + 6)) {
            Fluttertoast.showToast(
                msg:
                    'Consultation time must be atleast 6 hours after current time');
            return;
          } else {
            timeController.text = selectedTime!;
          }
        } else {
          timeController.text = selectedTime!;
        }
      });
    });
  }

  void showPopup(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Thank you for your request. Our health coach will get in touch with you shortly.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientButton(
                      title: 'OK',
                      func: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      gradient: orangeGradient,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
