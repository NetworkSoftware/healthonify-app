// import 'package:flutter/material.dart';
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int cIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: cIndex,
//       type: BottomNavigationBarType.fixed,
//       showUnselectedLabels: true,
//       selectedItemColor: Colors.orange,
//       unselectedItemColor: Colors.grey,
//       iconSize: 26,
//       onTap: (index) {
//         setState(() {
//           cIndex = index;
//         });
//       },
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.home,
//           ),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.group,
//           ),
//           label: 'Community',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.bolt,
//           ),
//           label: 'Expert',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.account_circle,
//           ),
//           label: 'My profile',
//         ),
//       ],
//     );
//   }
// }

// class ExpertBottomNavBar extends StatefulWidget {
//   const ExpertBottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<ExpertBottomNavBar> createState() => _ExpertBottomNavBarState();
// }

// class _ExpertBottomNavBarState extends State<ExpertBottomNavBar> {
//   // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ProfileScreen()));
//   int cIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: cIndex,
//       type: BottomNavigationBarType.fixed,
//       showUnselectedLabels: true,
//       selectedItemColor: Colors.orange,
//       unselectedItemColor: Colors.grey,
//       iconSize: 26,
//       onTap: (index) {
//         setState(() {
//           cIndex = index;
//         });
//       },
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.home,
//           ),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.group,
//           ),
//           label: 'Community',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.settings,
//           ),
//           label: 'Settings',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//             Icons.account_circle,
//           ),
//           label: 'My profile',
//         ),
//       ],
//     );
//   }
// }
