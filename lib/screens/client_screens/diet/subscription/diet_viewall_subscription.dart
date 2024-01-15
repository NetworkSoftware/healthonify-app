// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:healthonify_mobile/models/http_exception.dart';
// import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
// import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../widgets/cards/custom_appbar.dart';
//
// class DietViewAllSubscription extends StatefulWidget {
//   const DietViewAllSubscription({Key? key}) : super(key: key);
//
//   @override
//   State<DietViewAllSubscription> createState() => _DietViewAllSubscriptionState();
// }
//
// class _DietViewAllSubscriptionState extends State<DietViewAllSubscription> {
//   List<DietPlan> dietPlans = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(appBarTitle: "My Subscriptions"),
//       body: FutureBuilder(
//         future: getDietPlans(context, id),
//         builder: (context, snapshot) => snapshot.connectionState ==
//             ConnectionState.waiting
//             ? const Center(
//           child: CircularProgressIndicator(),
//         )
//             : Consumer<SubscriptionsData>(
//           builder: (context, value, child) => value.subsAyurvedaData.isEmpty
//               ? const Center(
//             child: Text("No Subscriptions available"),
//           )
//               :
//
//
//           ListView.builder(
//             padding: const EdgeInsets.all(20),
//             shrinkWrap: true,
//             itemCount: value.subsAyurvedaData.length,
//             itemBuilder: (context, index) => Card(
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 20, left: 20, right: 20, bottom: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       value.subsAyurvedaData[index].packageName ?? "",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineMedium,
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(vertical: 10),
//                       child: Row(
//                         children: [
//                           value.subsAyurvedaData[index].status! ==
//                               "paymentReceived"
//                               ? const Text("Paid")
//                               : const Text("Payment Pending"),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                               "\u{20B9}${value.subsAyurvedaData[index].netAmount!}"),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(vertical: 0),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.date_range),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(value.subsAyurvedaData[index].startDate!),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GradientButton(
//                             title: "View",
//                             func: () => Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     PhysioViewSessions(
//                                         subId: value
//                                             .subsAyurvedaData[index]
//                                             .id!),
//                               ),
//                             ),
//                             gradient: blueGradient),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> getDietPlans(BuildContext context, String id) async {
//     try {
//       dietPlans = await Provider.of<DietPlanProvider>(context, listen: false)
//           .getUserDietPlans("?userId=$id");
//     } on HttpException catch (e) {
//       log(e.toString());
//       // Fluttertoast.showToast(msg: "Something went wrong");
//     } catch (e) {
//       log("Error getting diet details $e");
//       // Fluttertoast.showToast(msg: "Something went wrong");
//     } finally {}
//   }
//
// }
