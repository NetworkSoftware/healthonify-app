import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/expert_screens/manage_calendar/session_timings/session_timings.dart';
import 'package:healthonify_mobile/screens/expert_screens/manage_calendar/view_calendar/view_calendar.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class ManageCalendarScreen extends StatelessWidget {
  const ManageCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Manage Calendar'),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SessionTimingsScreen();
                }));
              },
              child: const Text('Session Timings'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ViewCalendarScreen();
                }));
              },
              child: const Text('View Calendar'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Block Calendar'),
            ),
          ),
        ],
      ),
    );
  }
}
