import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/log_hba1c_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';
import 'package:healthonify_mobile/widgets/vitals/hba1c_tab_screen.dart';

class HbA1cScreen extends StatefulWidget {
  const HbA1cScreen({Key? key}) : super(key: key);

  @override
  State<HbA1cScreen> createState() => _HbA1cScreenState();
}

class _HbA1cScreenState extends State<HbA1cScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  String tab1DateType = 'monthly';
  String tab2DateType = 'yearly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'HbA1c Level',
        bottomWidget: ColoredBox(
          color: Theme.of(context).appBarTheme.backgroundColor!,
          child: customTabBar(context, tabController),
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              Hba1cTabScreen(
                dateType: tab1DateType,
              ),
              Hba1cTabScreen(
                dateType: tab2DateType,
                isYearlyTab: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: preferences.getString("role") != "ROLE_EXPERT"
          ? SizedBox(
              height: 56,
              child: GradientButton2(
                func: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LogHbA1cScreen();
                  })).then((value) {
                    setState(() {
                      tab1DateType = 'monthly';
                      tab2DateType = 'yearly';
                    });
                  });
                },
                title: "Add Manually",
                gradient: orangeGradient,
              ),
            )
          : const SizedBox(),
    );
  }

  // Widget build2() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 10),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               'This Year',
  //               style: Theme.of(context).textTheme.labelLarge,
  //             ),
  //           ],
  //         ),
  //       ),
  //       Image.asset('assets/icons/graph.png'),
  //       const SizedBox(height: 16),
  //       Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Text(
  //           'STATS',
  //           style: Theme.of(context).textTheme.labelLarge,
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(10),
  //         child: Row(
  //           children: [
  //             Text(
  //               'Average HbA1c',
  //               style: Theme.of(context).textTheme.bodySmall,
  //             ),
  //             const Spacer(),
  //             Text(
  //               "_",
  //               style: Theme.of(context).textTheme.bodySmall,
  //             ),
  //             const Spacer(),
  //           ],
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Text(
  //           'HISTORY',
  //           style: Theme.of(context).textTheme.labelLarge,
  //         ),
  //       ),
  //       SizedBox(
  //         height: 500,
  //         // color: Colors.white,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(10),
  //               child: Row(
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Text(
  //                             '15.0',
  //                             style: Theme.of(context).textTheme.labelLarge,
  //                           ),
  //                           Text(
  //                             '%',
  //                             style: Theme.of(context).textTheme.bodySmall,
  //                           ),
  //                         ],
  //                       ),
  //                       Text(
  //                         '4th Jun at 3:56 pm via Manual Entry',
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .bodySmall!
  //                             .copyWith(color: Colors.grey),
  //                       ),
  //                     ],
  //                   ),
  //                   const Spacer(),
  //                   const Icon(
  //                     Icons.warning_amber_rounded,
  //                     color: Colors.red,
  //                     size: 18,
  //                   ),
  //                   const SizedBox(width: 4),
  //                   Text(
  //                     'Diabetic',
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .bodySmall!
  //                         .copyWith(color: Colors.red),
  //                   ),
  //                   // const Spacer(),
  //                 ],
  //               ),
  //             ),
  //             const Divider(),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Heart rate Tracker not connected',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('CONNECT'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      barrierDismissible: false,
    );
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('MONTHLY'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('YEARLY'),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: Colors.red,
        indicatorWeight: 2.5,
      );
}
