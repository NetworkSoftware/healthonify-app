import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/get_subscriptions.dart';
import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/subscription_data_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LiveWellViewAllSubscriptions extends StatelessWidget {
  LiveWellViewAllSubscriptions({Key? key}) : super(key: key);

  bool noContent = false;

  Future<void> getSub(BuildContext context, String id) async {
    noContent = await GetSubscription()
        .getPhysioSubs(context, "userId=$id&isActive=true&flow=liveWell");
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
          builder: (context, value, child) => value.subsLiveWellData.isEmpty
              ? const Center(
            child: Text("No Subscriptions available"),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            itemCount: value.subsLiveWellData.length,
            itemBuilder: (context, index) => Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.subsLiveWellData[index].packageName ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          value.subsLiveWellData[index].status! ==
                              "paymentReceived"
                              ? const Text("Paid")
                              : const Text("Payment Pending"),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "\u{20B9}${value.subsLiveWellData[index].netAmount!}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 0),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(value.subsLiveWellData[index].startDate!),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GradientButton(
                            title: "View",
                            func: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PhysioViewSessions(
                                        subId: value
                                            .subsLiveWellData[index]
                                            .id!),
                              ),
                            ),
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
