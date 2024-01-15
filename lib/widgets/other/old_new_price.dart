import 'package:flutter/material.dart';

class OldNewPrice extends StatelessWidget {
  const OldNewPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 5,
      ),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Icon(
            Icons.schedule,
            color: Color(0xFFFFB755),
            size: 17,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              '6 days',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Spacer(),
          Text(
            '₹12,499',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2.5,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              '₹11,999',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
