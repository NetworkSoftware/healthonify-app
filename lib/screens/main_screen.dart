import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/update_profile.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/auth/change_password.dart';
import 'package:healthonify_mobile/screens/client_screens/community/community_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/tracker_screen.dart';
import 'package:healthonify_mobile/screens/no_connection.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_home.dart';
import 'package:healthonify_mobile/screens/client_screens/home_screen.dart';
import 'package:healthonify_mobile/screens/profile_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final bool pushCaloriesScreen;
  const MainScreen({
    Key? key,
    this.pushCaloriesScreen = false,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isloading = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> fetchUserData() async {
    await Provider.of<UserData>(context, listen: false).fetchUserData();
  }

  Future<void> fetchExpertData() async {
    await Provider.of<UserData>(context, listen: false).fetchExpertData();
  }

  Future<void> getUserData(BuildContext context) async {
    SharedPrefManager pref = SharedPrefManager();
    String role = await pref.getRoles();
    log(role);

    setState(() {
      isloading = true;
    });

    try {
      if (role == "ROLE_CLIENT" || role == "ROLE_CORPORATEEMPLOYEE") {
        log("client login");
        await fetchUserData();
      } else if (role == "ROLE_EXPERT") {
        log("Expert login");
        await fetchExpertData();
      }
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get user $e");
      Fluttertoast.showToast(msg: "Unable to fetch user data");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  late PersistentTabController bottomTabController;

  @override
  void initState() {
    super.initState();
    getUserData(context);
    //connectZego();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    bottomTabController = PersistentTabController(initialIndex: 0);
   // goToHome();
  }

  goToHome() async {
    Future.delayed(const Duration(seconds: 10), () async {
      FirebaseMessaging.instance.getToken().then((value) {
        UpdateProfile.updateFirebasetoken(context, {
          "set": {"firebaseToken": value!}
        });
      });
    });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      log(_connectionStatus.toString());
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  int cIndex = 0;
  int eIndex = 0;
  final List<Widget> clientScreens = [
    const HomeScreen(),
    const CommunityScreen(),
    const TrackerScreen(),
    const ShopScreen(),
    // const PlaceholderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return _connectionStatus == ConnectivityResult.none
        ? const NoConnectionScreen()
        : isloading
            ? Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset('assets/logo/splash.gif'),
                  // child: Text('Gathering all of your data'),
                ),
              )
            // ? const Center(child: CircularProgressIndicator())
            : Consumer<UserData>(
                builder: (context, data, child) {
                  log(" user name ${data.userData.firstName}");
                  final List<Widget> expertScreens = [
                    const ExpertHomeScreen(),
                    const CommunityScreen(),
                    ChangePasswordScreen(mobNo: data.userData.mobile ?? ""),
                    const ProfileScreen(),
                  ];
                  return data.userData.id == null
                      ? const Scaffold(
                          body: Center(
                            child: Text("Failed"),
                          ),
                        )
                      : SafeArea(
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: data.userData.roles![0]['name'] == 'expert'
                                ? expertScreens[eIndex]
                                : clientScreens[cIndex],
                            bottomNavigationBar:
                                // data.userData.roles![0]['name'] == 'expert'
                                //     ? persistentBottomNavBar(
                                //         bottomTabController,
                                //         expertScreens,
                                //         _expertNavBarsItems(),
                                //       )
                                //     : persistentBottomNavBar(
                                //         bottomTabController,
                                //         clientScreens,
                                //         _clientNavBarsItems(),
                                //       ),
                                data.userData.roles![0]['name'] == 'expert'
                                    ? expertBottomNavBar()
                                    : clientBottomNavBar(),
                          ),
                        );
                },
              );
  }

  // Widget persistentBottomNavBar(
  //   PersistentTabController controller,
  //   List<Widget> screens,
  //   List<PersistentBottomNavBarItem> icons,
  // ) {
  //   return PersistentTabView.custom(
  //     context,
  //     controller: controller,
  //     screens: screens,
  //     items: icons,
  //     confineInSafeArea: true,
  //     itemCount: icons.length,
  //     backgroundColor: Theme.of(context).canvasColor,
  //     handleAndroidBackButtonPress: true,
  //     stateManagement: true,
  //     screenTransitionAnimation: const ScreenTransitionAnimation(
  //       animateTabTransition: true,
  //       curve: Curves.ease,
  //       duration: Duration(milliseconds: 200),
  //     ),
  //     customWidget: (navBarEssentials) => CustomNavBarWidget(
  //       items: icons,
  //       onItemSelected: (index) {
  //         setState(() {
  //           navBarEssentials.onItemSelected!(index);
  //         });
  //       },
  //       selectedIndex: controller.index,
  //     ),
  //   );
  // }

  // List<PersistentBottomNavBarItem> _clientNavBarsItems() {
  //   Color activeColors = orange;
  //   Color inactiveColors = Colors.grey;
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.home),
  //       title: "Home",
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.group),
  //       title: ("Community"),
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.track_changes_rounded),
  //       title: ("Tracker"),
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.storefront_rounded),
  //       title: ("Shop"),
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //   ];
  // }

  // List<PersistentBottomNavBarItem> _expertNavBarsItems() {
  //   Color activeColors = orange;
  //   Color inactiveColors = Colors.grey;
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.home),
  //       title: "Home",
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.group),
  //       title: ("Community"),
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.settings),
  //       title: ("Settings"),
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const Icon(Icons.account_circle),
  //       title: ("My Profile"),
  //       activeColorPrimary: activeColors,
  //       inactiveColorPrimary: inactiveColors,
  //     ),
  //   ];
  // }

  Widget clientBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: cIndex,
      showUnselectedLabels: true,
      //backgroundColor: Colors.white,
     backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14
      ),
      iconSize: 20,
      onTap: (index) {
        setState(() {
          cIndex = index;
        });
      },
      items:  const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group,
          ),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.track_changes_rounded,
          ),
          label: 'Tracker',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.storefront_rounded,
          ),
          label: 'Shop',
        ),
      ],
    );
  }

  Widget expertBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: eIndex,
      showUnselectedLabels: true,
      iconSize: 26,
      onTap: (index) {
        setState(() {
          eIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group,
          ),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
          ),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
          ),
          label: 'My profile',
        ),
      ],
    );
  }
}
// }

class CustomNavBarWidget extends StatelessWidget {
  final int? selectedIndex;
  final List<PersistentBottomNavBarItem>? items;
  final ValueChanged<int>? onItemSelected;

  const CustomNavBarWidget({
    Key? key,
    this.selectedIndex,
    @required this.items,
    this.onItemSelected,
  }) : super(key: key);

  Widget _buildItem(
      BuildContext context, PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      color: Theme.of(context).canvasColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 26.0,
                  color: isSelected
                      ? (item.activeColorSecondary ?? item.activeColorPrimary)
                      : item.inactiveColorPrimary ?? item.activeColorPrimary),
              child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                child: Text(
                  item.title!,
                  style: TextStyle(
                      color: isSelected
                          ? (item.activeColorSecondary ??
                              item.activeColorPrimary)
                          : item.inactiveColorPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2F2465),
      child: SizedBox(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items!.map((item) {
            int index = items!.indexOf(item);
            return Expanded(
              child: InkWell(
                onTap: () {
                  onItemSelected!(index);
                },
                child: _buildItem(context, item, selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        var isLastPage = await inAppWebViewController.canGoBack();
        if(isLastPage){
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // elevation: 5,
            title: Text(
              "Shop",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: whiteColor),
            ),
            shadowColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse("https://healthonify.com/Shop")
                ),
                onWebViewCreated: (InAppWebViewController controller){
                  inAppWebViewController = controller;
                },
                onProgressChanged: (InAppWebViewController controller , int progress){
                  setState(() {
                    _progress = progress / 100;
                  });
                },
              ),
              _progress < 1 ? LinearProgressIndicator(
                value: _progress,
              ):const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
