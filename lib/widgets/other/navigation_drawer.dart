import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/auth/change_password.dart';
import 'package:healthonify_mobile/screens/auth/login_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/about_us.dart';
import 'package:healthonify_mobile/screens/client_screens/delete_account.dart';
import 'package:healthonify_mobile/screens/client_screens/my_care_plan/my_care_plan_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/my_experts/my_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/my_friends/my_friends.dart';
import 'package:healthonify_mobile/screens/client_screens/my_goals/my_goals.dart';
import 'package:healthonify_mobile/screens/client_screens/my_plans/my_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/privacy_center/privacy_center.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/reminders_screen.dart';
import 'package:healthonify_mobile/screens/my_diary/diary_settings.dart';
import 'package:healthonify_mobile/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthonify_mobile/screens/client_screens/community/my_community_posts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
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
    GoogleSignIn googleSignIn = GoogleSignIn();
    //await kSharedPreferences.remove(PrefConst.userToken);
    googleSignIn.signOut();
    // FirebaseAuth.instance.signOut();
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

  @override
  Widget build(BuildContext context) {
    String userMob =
        Provider.of<UserData>(context, listen: false).userData.mobile ?? "";
    List navBarItems = [
      {
        "title": "My Account",
        "icon": "assets/images/my_account.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const ProfileScreen();
          }));
        },
      },
      {
        "title": "My Goals",
        "icon": "assets/icons/_mygoal.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MyGoalsScreen();
          }));
        },
      },
      {
        "title": "Friends",
        "icon": "assets/icons/_friends.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MyFriendsScreen();
          }));
        },
      },
      {
        "title": "My Plans",
        "icon": "assets/icons/_myplans.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MyPlansScreen();
          }));
        },
      },
      {
        "title": "My Subscriptions",
        "icon": "assets/icons/_mysubs.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MyCarePlanScreen(
              title: "My Subcriptions",
            );
          }));
        },
      },
      // {
      //   "title": "My Apps and Devices",
      //   "icon": "assets/icons/_mydevices.png",
      //   "route": () {
      //     Navigator.pop(context);
      //     Navigator.of(
      //       context, /*rootnavigator: true*/
      //     ).push(MaterialPageRoute(builder: (context) {
      //       return const MyAppsAndDevices();
      //     }));
      //   },
      // },
      // {
      //   "title": "Diary Settings",
      //   "icon": "assets/icons/_diary.png",
      //   "route": () {
      //     Navigator.pop(context);
      //     Navigator.of(
      //       context, /*rootnavigator: true*/
      //     ).push(MaterialPageRoute(builder: (context) {
      //       return const DiarySettingsScreen();
      //     }));
      //   },
      // },
      {
        "title": "Reminders",
        "icon": "assets/icons/_reminders.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const RemindersScreen();
            // return const MealReminders(hideAppbar: false);
          }));
        },
      },
      {
        "title": "Change Password",
        "icon": "assets/icons/_changepass.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return ChangePasswordScreen(mobNo: userMob);
          }));
        },
      },
      {
        "title": "Delete Account",
        "icon": "assets/icons/_delete.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const DeleteAccountScreen();
          }));
        },
      },
      {
        "title": "Privacy Center",
        "icon": "assets/icons/_privacy.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const PrivacyCenterScreen();
          }));
        },
      },
      {
        "title": "About Us",
        "icon": "assets/icons/_about.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const AboutUsScreen();
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
        "title": "Contact Support",
        "icon": "assets/icons/_support.png",
        "route": () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return const ProfileScreen();
          // }));
          launchUrl(Uri.parse("mailto:<support@healthonify.com>"));
        },
      },
      // {
      //   "title": "Feedback",

      //   "icon": "assets/icons/_feedback.png",
      //   "route": () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return VideoCall(
      //         meetingId: "1234556",
      //         onVideoCallEnds: () {},
      //       );
      //     }));
      //   },
      // },
      {
        "title": "My Experts",
        "icon": "assets/icons/_experts.png",
        "route": () {
          Navigator.pop(context);
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MyExpertsScreen();
          }));
        },
      },
      {
        "title": "Share App",
        "icon": "assets/icons/_experts.png",
        "route": () {
          //Navigator.pop(context);
          if(Platform.isAndroid){
            Share.share('Check out Healthonify\nhttps://play.google.com/store/apps/details?id=com.octal.healthonify');
            log('message shared');
          }else{
            Share.share('Check out Healthonify\nhttps://apps.apple.com/in/app/healthonify-app/id6450786642');
            log('message shared');
          }
        },
      },
      {
        "title": "Logout",
        "icon": "assets/icons/_logout.png",
        "route": () {
          logout(context);
        },
      },
    ];
    User data = Provider.of<UserData>(context).userData;
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      //backgroundColor: whiteColor,
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
                          radius: 35,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            data.imageUrl!,
                          ),
                          radius: 35,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            "${data.firstName}",
                            //"${data.firstName} ${data.lastName}",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.mobile!,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: navBarItems.length,
              itemBuilder: (context, index) {
                return navBarItem(
                  context,
                  navBarItems[index]['route'],
                  navBarItems[index]['icon'],
                  navBarItems[index]['title'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget navBarItem(context, Function route, String icon, String navTitle) {
    return InkWell(
      onTap: () {
        route();
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 24,
              width: 24,
              color: orange,
            ),
            const SizedBox(width: 20),
            Text(
              navTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
