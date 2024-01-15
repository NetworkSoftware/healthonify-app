import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/expert_screens/upcoming_sessions_screen.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String customerName;
  final String invoiceNumber;
  final String orderStatus;
  final String orderAmount;
  final String orderDate;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.customerName,
    required this.invoiceNumber,
    required this.orderStatus,
    required this.orderAmount,
    required this.orderDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => UpcomingSessions(),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          color: const Color(0xFFFFF7F5),
          child: SizedBox(
            height: 145,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          productName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/user.png',
                          height: 14,
                          width: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            customerName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/icons/calendar-silhouette.png',
                          height: 13,
                          width: 13,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            orderDate,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Amount: $orderAmount',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          'Invoice: $invoiceNumber',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Status : $orderStatus',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
