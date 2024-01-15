import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class PlanOrderSummary extends StatelessWidget {
  const PlanOrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Order Summary'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Card(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Personal Training (L1) (13s)',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Personal Training/Nutrition',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1 month',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹10,000',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Trainer Selected',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        // backgroundColor: Colors.blue,
                        child: Image.asset('assets/icons/expert_pfp.png'),
                      ),
                      Text(
                        'Trainer Name',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  filled: true,
                  hintText: 'Enter coupon code',
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF717579),
                      ),
                  suffixIcon: TextButton(
                    onPressed: () {},
                    child: const Text('APPLY'),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                cursorColor: whiteColor,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                onTap: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                tileColor: Theme.of(context).colorScheme.background,
                title: Text(
                  'Bill Details',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  'Rs. 10,000',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: blueGradient,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'BUY NOW',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
