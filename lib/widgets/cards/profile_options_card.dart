import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/auth/change_password.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_form/view_fitness_form.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/edit_profile.dart';
import 'package:healthonify_mobile/screens/expert_screens/medical_form_screen.dart';
import 'package:healthonify_mobile/screens/lifestyle_details.dart';
import 'package:healthonify_mobile/screens/notifications_screen.dart';
import 'package:provider/provider.dart';

class ProfileOptionsCard extends StatefulWidget {
  const ProfileOptionsCard({Key? key}) : super(key: key);

  @override
  State<ProfileOptionsCard> createState() => _ProfileOptionsCardState();
}

class _ProfileOptionsCardState extends State<ProfileOptionsCard> {
  late String roles;
  late String userId;

  @override
  void initState() {
    super.initState();

    roles = Provider.of<UserData>(context, listen: false).userData.roles![0]
        ['name'];
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    log("ROLES => $roles");
  }

  @override
  Widget build(BuildContext context) {
    String? mobileNo = Provider.of<UserData>(context).userData.mobile;
    List options = [
      {
        'icon': 'assets/icons/Home.png',
        'title': 'Your Profile',
        'route': () {
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
      //   'icon': 'assets/icons/orders.png',
      //   'title': 'My Posts',
      //   'route': () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return const MyCommunityPosts();
      //     }));
      //   },
      // },
      {
        'icon': 'assets/icons/notification-bell.png',
        'title': 'Notifications',
        'route': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(
            MaterialPageRoute(
              builder: (context) => NotificationScreen(),
            ),
          );
        },
      },
      if (roles == "client")
        {
          'icon': 'assets/icons/user.png',
          'title': 'My Medical Form',
          'route': () {
            Navigator.of(
              context, /*rootnavigator: true*/
            ).push(
              MaterialPageRoute(
                builder: (context) => MedicalFormScreen(
                  isFromClient: true,
                  clientId: userId,
                ),
              ),
            );
          },
        },
      if (roles == "client")
        {
          'icon': 'assets/icons/Bookings.png',
          'title': 'My Lifestyle Form',
          'route': () {
            Navigator.of(
              context, /*rootnavigator: true*/
            ).push(
              MaterialPageRoute(
                builder: (context) => LifestyleDetailsScreen(clientId: userId),
              ),
            );
          },
        },
      if (roles == "client")
        {
          'icon': 'assets/icons/fitnessform.png',
          'title': 'My Fitness Form',
          'route': () {
            Navigator.of(
              context, /*rootnavigator: true*/
            ).push(
              MaterialPageRoute(
                builder: (context) =>
                    ViewMyFitnessForm(isFromClient: false, clientId: userId),
              ),
            );
          },
        },
      // {
      //   'icon': 'assets/icons/user.png',
      //   'title': 'Change Plans',
      //   'route': () {
      //     Navigator.of(context, /*rootnavigator: true*/).push(
      //       MaterialPageRoute(
      //         builder: (context) => const ChoosePlansScreen(),
      //       ),
      //     );
      //   },
      // },
      {
        'icon': 'assets/icons/orders.png',
        'title': 'Password and Security',
        'route': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(
            MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(mobNo: mobileNo!),
            ),
          );
        },
      },
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        elevation: 4,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return optionTile(
                options[index] == {} ? () {} : options[index]["route"],
                options[index]["icon"],
                options[index]["title"],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget optionTile(Function route, String icon, String title) {
    return InkWell(
      onTap: () {
        route();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                icon,
                height: 20,
                width: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 32,
                color: Color(0xFF717579),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
