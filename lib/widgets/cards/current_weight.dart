import 'package:flutter/material.dart';

class CurrentWeightCard extends StatefulWidget {
  const CurrentWeightCard({Key? key}) : super(key: key);

  @override
  State<CurrentWeightCard> createState() => _CurrentWeightCardState();
}

class _CurrentWeightCardState extends State<CurrentWeightCard> {
  int _weight = 74;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184,
      width: MediaQuery.of(context).size.width * 0.42,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Current Weight',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_weight',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'kg',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _weight--;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(
                    Icons.remove_circle,
                    size: 42,
                    color: Color(0xFF717579),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _weight++;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Icon(
                    Icons.add_circle,
                    size: 42,
                    color: Color(0xFF717579),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
