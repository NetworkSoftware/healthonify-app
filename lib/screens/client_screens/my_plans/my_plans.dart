import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/browse_fitness_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/browse_ayurveda_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/browse_hc_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/browse_livewell_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/current_workout_plan.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/browse_physio_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/quick_actions/browse_plans.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Plans'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'My Workout Plan',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return  CurrentWorkoutPlan();
                    }));
                  },
                  title: Text(
                    'My Workout Plan',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'My Diet Plan',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const MyDietPlans();
                    }));
                  },
                  title: Text(
                    'My Diet Plan',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: Text(
            //     'Others',
            //     style: Theme.of(context).textTheme.labelLarge,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            //   child: Card(
            //     child: ListTile(
            //       onTap: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context) {
            //           return BrowseHealthCarePlans(isFree: true);
            //         }));
            //       },
            //       title: Text(
            //         'Healthcare',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       trailing: const Icon(
            //         Icons.chevron_right_rounded,
            //         color: Colors.grey,
            //         size: 28,
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            //   child: Card(
            //     child: ListTile(
            //       onTap: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context) {
            //           return BrowsePhysioPlans(isFree: true);
            //         }));
            //       },
            //       title: Text(
            //         'Physio Therapy',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       trailing: const Icon(
            //         Icons.chevron_right_rounded,
            //         color: Colors.grey,
            //         size: 28,
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            //   child: Card(
            //     child: ListTile(
            //       onTap: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context) {
            //           return BrowseAyurvedaPlans(isFree: true);
            //         }));
            //       },
            //       title: Text(
            //         'Ayurveda',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       trailing: const Icon(
            //         Icons.chevron_right_rounded,
            //         color: Colors.grey,
            //         size: 28,
            //       ),
            //     ),
            //   ),
            // ),
            //
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            //   child: Card(
            //     child: ListTile(
            //       onTap: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context) {
            //           return const WmPackagesQuickActionsScreen(isFree: true);
            //         }));
            //       },
            //       title: Text(
            //         'Manage Weight',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       trailing: const Icon(
            //         Icons.chevron_right_rounded,
            //         color: Colors.grey,
            //         size: 28,
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            //   child: Card(
            //     child: ListTile(
            //       onTap: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context) {
            //           return const BrowseFitnessPlans(isExpertCurated: false,isFree: true);
            //         }));
            //       },
            //       title: Text(
            //         'Fitness',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       trailing: const Icon(
            //         Icons.chevron_right_rounded,
            //         color: Colors.grey,
            //         size: 28,
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            //   child: Card(
            //     child: ListTile(
            //       onTap: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context) {
            //           return const BrowseLiveWellPlans(isFree: true);
            //         }));
            //       },
            //       title: Text(
            //         'Live Well',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       trailing: const Icon(
            //         Icons.chevron_right_rounded,
            //         color: Colors.grey,
            //         size: 28,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
