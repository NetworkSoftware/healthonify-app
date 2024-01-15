import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/experts/upcoming_sessions.dart';

class UpcomingSessionsCard extends StatelessWidget {
  final String serviceName;
  final String customerName;
  final String invoiceNumber;
  final String bookingStatus;
  final String bookingAmount;
  final String createdDate;
  final String dueDate;
  final UpcomingSessions data;

  const UpcomingSessionsCard({Key? key, 
    required this.serviceName,
    required this.customerName,
    required this.invoiceNumber,
    required this.bookingStatus,
    required this.bookingAmount,
    required this.createdDate,
    required this.dueDate,
    required this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        color: const Color(0xFFFFF7F5),
        child: SizedBox(
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
                        serviceName,
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
                      Image.asset('assets/icons/user.png',
                          height: 14, width: 14),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          customerName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Start: ${data.startDate}',
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
                        'Amount: $bookingAmount',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        'Time: ${data.startTime}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Start Session"),
                    )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
