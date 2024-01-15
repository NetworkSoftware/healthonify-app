import 'package:flutter/material.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutCard extends StatefulWidget {
  const LogoutCard({Key? key}) : super(key: key);

  @override
  State<LogoutCard> createState() => _LogoutCardState();
}

class _LogoutCardState extends State<LogoutCard> {
  bool _isLoading = false;

  void pushHomeRoute() {
    Navigator.of(context, /*rootnavigator: true*/).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false);
  }

  void logout(BuildContext context) async {
    setState(() => _isLoading = true);

    SharedPrefManager prefManager = SharedPrefManager();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    //workaround as it's not getting cleared in android 11
    await prefManager.saveSession(false);
    await preferences.clear();
    setState(() => _isLoading = false);

    Provider.of<UserData>(context, listen: false).clearUserData();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
            (Route<dynamic> route) => false);
    //pushHomeRoute();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isLoading
          ? null
          : () {
              logout(context);
            },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          elevation: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.91,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Image.asset(
                          'assets/icons/Home.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Logout',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
