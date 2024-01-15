// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:healthonify_mobile/providers/user_data.dart';
// import 'package:healthonify_mobile/widgets/cards/product_cards.dart';
// import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
// import 'package:healthonify_mobile/models/http_exception.dart';
// import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
// import 'package:provider/provider.dart';
//
// // ignore: must_be_immutable
// class OrdersScreen extends StatelessWidget {
//   bool _noContent = false;
//
//   OrdersScreen({Key? key}) : super(key: key);
//   Future<void> getFunc(BuildContext context, String id) async {
//     try {
//       await Provider.of<SubscriptionsData>(context, listen: false)
//           .getSubsData(id);
//     } on HttpException catch (e) {
//       log(e.toString());
//       Fluttertoast.showToast(msg: e.message);
//       _noContent = true;
//     } catch (e) {
//       log("Error get orders widget $e");
//       // Fluttertoast.showToast(msg: "Unable to fetch orders");
//       _noContent = true;
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     String expertId = Provider.of<UserData>(context).userData.id!;
//     log(expertId);
//
//     return Scaffold(
//       appBar: const CustomAppBar(
//         appBarTitle: 'Orders',
//       ),
//       body: FutureBuilder(
//         future: getFunc(context, expertId),
//         builder: (context, snapshot) =>
//             snapshot.connectionState == ConnectionState.waiting
//                 ? const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : _noContent
//                     ? const Center(
//                         child: Text("No orders available"),
//                       )
//                     : Consumer<SubscriptionsData>(
//                         builder: (context, value, child) => ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           itemCount: value.subsData.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 15),
//                               child: ProductCard(
//                                 productName: 'Product Name',
//                                 customerName: 'Sarah Johnson',
//                                 invoiceNumber: 'INV-5683',
//                                 orderStatus: 'Paid',
//                                 orderAmount: value.subsData[index].grossAmount!,
//                                 orderDate: value.subsData[index].startDate!,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//       ),
//     );
//   }
// }
