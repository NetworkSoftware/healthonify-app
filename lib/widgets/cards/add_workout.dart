
import 'package:flutter/material.dart';

class AddWorkoutCard extends StatelessWidget {
  const AddWorkoutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add workout',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
               const Icon(
                  Icons.add,
                  size: 32,
                  color: Color(0xFF1592EA),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
