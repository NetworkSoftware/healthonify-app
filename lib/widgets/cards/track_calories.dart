import 'package:flutter/material.dart';

class TrackCalories extends StatelessWidget {
  const TrackCalories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        color: const Color(0xFFF7F7F7),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Icon(
                  Icons.restaurant,
                  color:  Color(0xFFE99C0C),
                  size: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    'Track your calorie intake',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color:  Color(0xFF717579),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
