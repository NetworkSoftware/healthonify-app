import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import '../buttons/custom_buttons.dart';

class PlansCard extends StatelessWidget {
  final String planCategory;
  final String planPrice;
  final String planServices;

  const PlansCard({Key? key, 
    required this.planCategory,
    required this.planPrice,
    required this.planServices,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 5),
                  child: Text(
                    planCategory,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Image.asset(
                  'assets/icons/diamond.png',
                  height: 64,
                  width: 70,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 18),
                  child: Container(
                    height: 92,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient:  LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        // ignore: prefer_const_literals_to_create_immutables
                        colors: [
                          Color(0xFF0BC6F0),
                          Color(0xFF3CE5AB),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              '₹ ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: whiteColor),
                            ),
                            Text(
                              planPrice,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 40, color: whiteColor),
                            ),
                          ],
                        ),
                        Text(
                          'per month',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              planServices,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SelectPlanButton(),
                Text(
                  '7 day Money-back guarantee. Cancel anytime.',
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
