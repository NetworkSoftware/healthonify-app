import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/plan_order_summary.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class PlanDetailsScreen extends StatefulWidget {
  const PlanDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  bool isAgreed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Subscription Details',
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
                  'Personal Training (L1) (13s)',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'Personal Training/ Nutrition',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Category',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Divider(
                color: Colors.grey[200],
                indent: 16,
                endIndent: 16,
                height: 30,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Center(
              //     child: Text(
              //       '1 Month',
              //       style: Theme.of(context).textTheme.labelLarge,
              //     ),
              //   ),
              // ),
              // Center(
              //   child: Text(
              //     'Tenure',
              //     style: Theme.of(context).textTheme.bodyMedium,
              //   ),
              // ),
              // Divider(
              //   color: Colors.grey[200],
              //   indent: 16,
              //   endIndent: 16,
              //   height: 30,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Price',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        '₹8,500',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'Tenure',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Center(
                        child: Text(
                          '1 Month',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[200],
                indent: 16,
                endIndent: 16,
                height: 30,
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
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quam elementum pulvinar etiam non.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Text(
              //     'Process',
              //     style: Theme.of(context).textTheme.labelLarge,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Text(
              //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quam elementum pulvinar etiam non.',
              //     style: Theme.of(context).textTheme.bodyMedium,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Terms and conditions',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '1. Membership rates can be revised by the management.\n2. No membership is refundable.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: whiteColor,
                ),
                child: CheckboxListTile(
                  title: Text(
                    'I agree to all the terms and conditions',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  value: isAgreed,
                  onChanged: (isChecked) {
                    setState(() {
                      isAgreed = isChecked!;
                    });
                  },
                  activeColor: const Color(0xFFff7f3f),
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientButton(
                      title: 'Buy Plan',
                      func: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const PlanOrderSummary();
                        }));
                      },
                      gradient: orangeGradient,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
