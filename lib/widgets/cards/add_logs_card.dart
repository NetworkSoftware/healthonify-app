import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/trackers/sleep_tracker_func.dart';

class AddLogsCard extends StatelessWidget {
  const AddLogsCard({Key? key, required this.onAdd}) : super(key: key);
  final Function onAdd;

  Future<void> getSleepLogs(BuildContext context) async {
    await SleepTrackerFunc().getSleepLogs(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.96,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            onAdd();
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Logs',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Icon(
                  Icons.add_circle,
                  color: Colors.blue.shade300,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
