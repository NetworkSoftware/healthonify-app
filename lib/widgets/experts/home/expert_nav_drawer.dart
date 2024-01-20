import 'package:flutter/material.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/auth/change_password.dart';
import 'package:healthonify_mobile/screens/auth/login_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/community/my_community_posts.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/edit_profile.dart';
import 'package:healthonify_mobile/screens/expert_screens/earnings/expert_earnings.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_availability.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_personal_clients.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpertNavigationDrawer extends StatefulWidget {
  final String topLevelExp;
  const ExpertNavigationDrawer({required this.topLevelExp, Key? key})
      : super(key: key);

  @override
  State<ExpertNavigationDrawer> createState() => _ExpertNavigationDrawerState();
}

class _ExpertNavigationDrawerState extends State<ExpertNavigationDrawer> {
  bool isLoading = false;
  void onLogoutSuccess() {
    Navigator.of(
      context, /*rootnavigator: true*/
    ).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void logout(BuildContext context) async {
    setState(() => isLoading = true);

    SharedPrefManager prefManager = SharedPrefManager();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    //workaround as it's not getting cleared in android 11
    await prefManager.saveSession(false);
    await preferences.clear();
    setState(() => isLoading = false);
    //onLogoutSuccess.call();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
        (Route<dynamic> route) => false);

    Provider.of<UserData>(context, listen: false).clearUserData();
  }

  // void logout(BuildContext context) async {
  //   setState(() => isLoading = true);
  //
  //   SharedPrefManager prefManager = SharedPrefManager();
  //
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   //workaround as it's not getting cleared in android 11
  //   await prefManager.saveSession(false);
  //   await preferences.clear();
  //   setState(() => isLoading = false);
  //   //onLogoutSuccess.call();
  //
  //   Provider.of<UserData>(context, listen: false).clearUserData();
  // }

  @override
  Widget build(BuildContext context) {
    User data = Provider.of<UserData>(context).userData;
    List expertDrawerItems = [
      {
        'title': 'Profile',
        "icon": "assets/icons/_reminders.png",
        'route': () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(
            MaterialPageRoute(
              builder: (context) => const YourProfileScreen(),
            ),
          );
        },
      },
      // {
      //   'title': 'Calendar',
      //   "icon": "assets/icons/_diary.png",
      //   'route': () {},
      // },
      {
        'title': 'Settings',
        "icon": "assets/icons/settings.png",
        'route': () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(
            MaterialPageRoute(
              builder: (context) =>
                  ChangePasswordScreen(mobNo: data.mobile ?? ""),
            ),
          );
        },
      },
      {
        'title': 'My Clients',
        "icon": "assets/icons/_friends.png",
        'route': () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return MyPersonalClients();
          }));
        },
      },
      // {
      //   'title': 'Batchessss',
      //   "icon": "assets/icons/batch.png",
      //   'route': () {
      //     Navigator.pop(context);
      //     Navigator.of(
      //       context, /*rootnavigator: true*/
      //     ).push(MaterialPageRoute(builder: (context) {
      //       return const ExpertBatchesScreen();
      //     }));
      //   },
      // },
      {
        'title': 'Earnings',
        "icon": "assets/icons/_privacy.png",
        'route': () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return ExpertEarningsScreen(topLevelExpertise: widget.topLevelExp);
          }));
        },
      },
      {
        "title": "My Community Posts",
        "icon": "assets/icons/_community.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MyCommunityPosts();
          }));
        },
      },
      {
        "title": "Availability",
        "icon": "assets/icons/_myplans.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const ExpertAvailabilityScreen();
          }));
        },
      },
      // {
      //   'title': 'Feedback',
      //   "icon": "assets/icons/_feedback.png",
      //   'route': () {},
      // },
      {
        "title": "Logout",
        "icon": "assets/icons/_logout.png",
        "route": () {
          logout(context);
        },
      },
      // {
      //   'title': 'Reminders',
      //   "icon": "assets/icons/_reminders.png",
      //   'route': () {
      //     // Navigator.pop(context);
      //     // Navigator.of(context, /*rootnavigator: true*/)
      //     //     .push(MaterialPageRoute(builder: (context) {
      //     //   return const RemindersScreen();
      //     // }));
      //   },
      // },
    ];

    return Drawer(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 20, bottom: 30),
              child: Row(
                children: [
                  data.imageUrl == null || data.imageUrl!.isEmpty
                      ? const CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/icons/pfp_placeholder.jpg',
                          ),
                          radius: 40,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            data.imageUrl!,
                          ),
                          radius: 40,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data.firstName!} ${data.lastName}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.email!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 2,
                width: double.infinity,
                color: const Color(0xFFff7f3f),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: expertDrawerItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: expertDrawerItems[index]['route'],
                  leading: Image.asset(
                    expertDrawerItems[index]['icon'],
                    height: 24,
                    width: 24,
                  ),
                  title: Text(
                    expertDrawerItems[index]['title'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
