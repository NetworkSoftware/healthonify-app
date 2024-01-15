import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/get_subscriptions.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_subscriptions_data.dart';
import 'package:healthonify_mobile/screens/client_screens/appointment_view_package_by_enquiry.dart';
import 'package:healthonify_mobile/screens/client_screens/appointment_view_session_by_enquiry.dart';
import 'package:healthonify_mobile/screens/client_screens/subscription_data_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ViewAllSubscriptions extends StatelessWidget {
  ViewAllSubscriptions({Key? key, required this.flow}) : super(key: key);
  String flow;

  bool noContent = false;

  Future<void> getSub(BuildContext context, String id) async {
    if(kSharedPreferences.getString("role") != "ROLE_EXPERT") {
      noContent = await GetSubscription()
          .getSubs(context, "userId=$id&isActive=true&flow=$flow");
    }else{
      noContent = await GetSubscription()
          .getSubs(context, "expertId=$id&isActive=true&flow=$flow");
    }

  }

  @override
  Widget build(BuildContext context) {
    String id = Provider.of<UserData>(context, listen: false).userData.id!;
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "My Subscriptions"),
      body: FutureBuilder(
        future: getSub(context, id),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<SubscriptionsData>(
                builder: (context, value, child) => value
                        .subsFitnessData.isEmpty
                    ? const Center(
                        child: Text("No Subscriptions available"),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        shrinkWrap: true,
                        itemCount: value.subsFitnessData.length,
                        itemBuilder: (context, index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.subsFitnessData[index].packageName ??
                                      "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                      text: 'Ticket Number: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(fontSize: 16),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: value.subsFitnessData[index]
                                              .ticketNumber,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(fontSize: 14),
                                        )
                                      ]),
                                ),
                                Row(
                                  children: [
                                    Text(
                                        value.subsFitnessData[index].status!),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    // Text(
                                    //     "\u{20B9}${value.subsFitnessData[index].netAmount!}"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                 Row(
                                  children: [
                                    const Icon(Icons.date_range),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(StringDateTimeFormat().stringtDateFormatLogWeight(value.subsFitnessData[index].startDate!)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GradientButton(
                                        title: "View",
                                        // func: () => Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             PhysioViewSessions(
                                        //                 subId: value
                                        //                     .subsFitnessData[
                                        //                         index]
                                        //                     .id!),
                                        //       ),
                                        //     ),
                                        func: () => Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return AppointmentViewPackageByEnquiry(
                                                ticketNumber: value.subsFitnessData[index].ticketNumber!,
                                                flow: value.subsFitnessData[index].flow!,
                                              );
                                            })),
                                        gradient: blueGradient),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
