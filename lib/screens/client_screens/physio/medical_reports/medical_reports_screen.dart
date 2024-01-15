import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/medical_reports/add_medical_report.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';

class MedicalReportScreen extends StatefulWidget {
  const MedicalReportScreen({Key? key}) : super(key: key);

  @override
  State<MedicalReportScreen> createState() => _MedicalReportScreenState();
}

class _MedicalReportScreenState extends State<MedicalReportScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'Medical Reports',
        bottomWidget: ColoredBox(
          color: Theme.of(context).appBarTheme.backgroundColor!,
          // color: const Color(0xFF121212),
          child: customTabBar(context, tabController),
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              build1(),
              build2(),
              build3(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddMedicalReport();
            }));
          },
          child: Center(
            child: Text(
              'Add new medical report',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: whiteColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build1() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              onTap: () {},
              leading: Image.asset(
                'assets/icons/file.png',
                height: 30,
                width: 30,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medical Report',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '4th Jun at 10:00 am',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 24,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[600],
            ),
          ],
        );
      },
    );
  }

  Widget build2() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Start uploading your medical reports'),
        ),
      ],
    );
  }

  Widget build3() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Start uploading your medical reports'),
        ),
      ],
    );
  }

  // Widget build4() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: const [
  //       Center(
  //         child: Text('Start uploading your medical records'),
  //       ),
  //     ],
  //   );
  // }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('ALL REPORTS'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'LAB REPORTS',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('DOCTOR CONSULTATIONS'),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: Colors.red,
        indicatorWeight: 2.5,
      );
}
