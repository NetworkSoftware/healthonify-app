import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final Function route;
  const ReminderCard({required this.route, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.96,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 2,
        child: InkWell(
          onTap: () {
            route();
          },
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Set Reminder',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF717579),
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
