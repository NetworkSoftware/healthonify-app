import 'package:flutter/material.dart';

class NutritionCard extends StatelessWidget {
  const NutritionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 98,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'PROTEIN',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '160 g',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'CARBS',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '200 g',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'FAT',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '15 g',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'FIBRE',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '20 g',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
