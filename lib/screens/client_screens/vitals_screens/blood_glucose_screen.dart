import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/log_blood_glucose.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';
import 'package:healthonify_mobile/widgets/vitals/blood_glucose_tab_screen.dart';

class BloodGlucoseScreen extends StatefulWidget {
  final String? userId;

  const BloodGlucoseScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<BloodGlucoseScreen> createState() => _BloodGlucoseScreen();
}

class _BloodGlucoseScreen extends State<BloodGlucoseScreen>
    with TickerProviderStateMixin {
  String tab1 = 'Today';
  String tab2 = 'This Week';
  String tab3 = 'This Month';
  String tab4 = 'This Year';

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);
    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'Blood Glucose',
        actionWIdget2: preferences.getString("role") != "ROLE_EXPERT"
            ? Padding(
                padding: const EdgeInsets.only(top: 15, right: 10),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LogBloodGlucose();
                      })).then((value) {
                        setState(() {
                          tab1 = 'Today';
                          tab2 = 'This Week';
                          tab3 = 'This Month';
                          tab4 = 'This Year';
                        });
                      });
                    },
                    child: const Text(
                      "+ Add Log",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
              )
            : const SizedBox(),
        bottomWidget: ColoredBox(
          color: Theme.of(context).appBarTheme.backgroundColor!,
          child: customTabBar(context, tabController),
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            BloodGlucoseTabScreen(
              tabName: tab1,
              dateType: "today",
            ),
            BloodGlucoseTabScreen(
              tabName: tab2,
              dateType: "weekly",
            ),
            BloodGlucoseTabScreen(
              tabName: tab3,
              dateType: "monthly",
            ),
            BloodGlucoseTabScreen(
              tabName: tab4,
              dateType: "yearly",
            ),
          ],
        ),
      ),
      // bottomNavigationBar:
      //     kSharedPreferences.getString("role") != "ROLE_EXPERT"
      //         ? SizedBox(
      //             height: 56,
      //             child: GradientButton2(
      //               gradient: orangeGradient,
      //               title: "Add Manually",
      //               func: () {
      //                 Navigator.push(context,
      //                     MaterialPageRoute(builder: (context) {
      //                   return const LogBloodGlucose();
      //                 })).then((value) {
      //                   setState(() {
      //                     tab1 = 'Today';
      //                     tab2 = 'This Week';
      //                     tab3 = 'This Month';
      //                     tab4 = 'This Year';
      //                   });
      //                 });
      //               },
      //             ),
      //           )
      //         : const SizedBox()
    );
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('DAILY'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('WEEKLY'),
          ),
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
