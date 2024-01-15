import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/plans_card.dart';

class ChoosePlansScreen extends StatelessWidget {
  const ChoosePlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Choose Your Plan',
         
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Wrap(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Find the perfect plan for your wellbeing.',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const PlansCard(
                      planCategory: 'Pro',
                      planPrice: '2399',
                      planServices: 'Service',
                    );
                  },
                  scrollDirection: Axis.vertical,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
