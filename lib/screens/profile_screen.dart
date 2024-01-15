import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/cards/logout_card.dart';
import 'package:healthonify_mobile/widgets/cards/profile_options_card.dart';
import 'package:healthonify_mobile/widgets/cards/profile_details.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Future<void> fetchUserData(BuildContext context) async {
  //   await Provider.of<UserData>(context, listen: false).fetchUserData();
  // }

  // Future<void> fetchExpertData(BuildContext context) async {
  //   await Provider.of<UserData>(context, listen: false).fetchExpertData();
  // }

  // Future<void> getUserData(BuildContext context) async {
  //   SharedPrefManager pref = SharedPrefManager();
  //   String role = await pref.getRoles();
  //   log(role);

  //   try {
  //     if (role == "ROLE_CLIENT" || role == "ROLE_CORPORATEEMPLOYEE") {
  //       log("client login");
  //       await fetchUserData(context);
  //     } else if (role == "ROLE_EXPERT") {
  //       log("Expert login");
  //       await fetchExpertData(context);
  //     }
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error get user $e");
  //     Fluttertoast.showToast(msg: "Unable to fetch user data");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Profile',
      //     style: Theme.of(context).textTheme.headlineMedium,
      //   ),
      // ),
        appBar: const CustomAppBar(appBarTitle: 'Profile'),
       body: Consumer<UserData>(
          builder: (context, data, _) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ProfileDetails(
                          userName: data.userData.firstName!,
                          userEmail: data.userData.email!,
                          imgUrl: data.userData.imageUrl ?? "",
                        ),
                        // DetailsCard(
                        //   userContactNo: data.userData.mobile!,
                        //   userAddress: 'Bangalore, Karnataka',
                        //   userPincode: '560001',
                        // ),
                        const ProfileOptionsCard(),
                        const LogoutCard(),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Build 11",
                          style: TextStyle(fontSize: 10),
                        ),
                        const Text(
                          "31st Mar 2022",
                          style: TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      // body: FutureBuilder(
      //   future: null,
      //   builder: (context, snapshot) =>
      //       snapshot.connectionState == ConnectionState.waiting
      //           ? const Center(
      //               child: CircularProgressIndicator(),
      //             )
      //           : ,
      // ),
    );
  }
}
