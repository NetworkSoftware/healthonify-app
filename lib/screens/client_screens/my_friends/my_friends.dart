import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/learn_more.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:share_plus/share_plus.dart';

class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({Key? key}) : super(key: key);

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: "My Friends",
        widgetRight: IconButton(
          onPressed: () {
            Share.share(
                'Please check out Healthonify app. Download at https://play.google.com/store/apps/details?id=com.octal.healthonify .It will be fun if you can join too.');
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const AddFriendsScreen();
            // }));
          },
          icon: const Icon(
            Icons.person_add,
            color: whiteColor,
          ),
          splashRadius: 20,
        ),
      ),
      // appBar: TabAppBar(
      //   appBarTitle: 'My Friends',
      //   widgetRight: IconButton(
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (context) {
      //         return const AddFriendsScreen();
      //       }));
      //     },
      //     icon: const Icon(
      //       Icons.person_add,
      //       color: orange,
      //     ),
      //     splashRadius: 20,
      //   ),
      //   bottomWidget: ColoredBox(
      //     color: grey,
      //     child: customTabBar(
      //       context,
      //       tabController,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              page1(),
              page2(),
            ],
          ),
        ),
      ),
    );
  }

  Widget page1() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Image.asset(
          'assets/icons/friends.png',
          height: 125,
        ),
        const SizedBox(height: 10),
        Text(
          'Users who add friends lose 2X more wieght on average',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const LearnMoreScreen();
            }));
          },
          child: const Text('Learn More'),
        ),
      ],
    );
  }

  Widget page2() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          'You have no pending requests at this time',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Friends'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Requests'),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: orange,
        indicatorWeight: 2.5,
      );
}
