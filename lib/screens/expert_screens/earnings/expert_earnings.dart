import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/experts/expert_earnings_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/expert_earnings_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ExpertEarningsScreen extends StatefulWidget {
  final String topLevelExpertise;
  const ExpertEarningsScreen({required this.topLevelExpertise, Key? key})
      : super(key: key);

  @override
  State<ExpertEarningsScreen> createState() => _ExpertEarningsScreenState();
}

class _ExpertEarningsScreenState extends State<ExpertEarningsScreen> {
  int? value = 0;
  List<Map<String, String>> items = [
    {
      'title': "Today",
      'value': "today",
    },
    {
      'title': "Week",
      'value': "weekly",
    },
    {
      'title': "Month",
      'value': "monthly",
    },
  ];

  String todaysDate = DateFormat('d MMM yyyy').format(DateTime.now());
  String lastWeek = DateFormat('d MMM yyyy')
      .format(DateTime.now().subtract(const Duration(days: 7)));

  // String thisMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String thisMonth = "Last Month";

  late String expertId;

  bool isLoading = false;
  String? formattedConsultDate;
  HcRevenue earnings = HcRevenue();

  Future<void> fetchExpertEarnings() async {
    setState(() {
      isLoading = true;
    });

    String dateFilter =
        "date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    if (value == 0) {
      dateFilter = dateFilter;
    } else if (value == 1) {
      dateFilter =
          "fromDate${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))}&toDate${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    } else {
      dateFilter =
          "fromDate${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)))}&toDate${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    }
    try {
      earnings =
          await Provider.of<ExpertEarningsProvider>(context, listen: false)
              .getHealthCareExpertEarnings(expertId, dateFilter);
      print(earnings.data!.revenuesData!.length);

      // print(earnings.data!.revenuesData!.length);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching earnings');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    expertId = Provider.of<UserData>(context, listen: false).userData.id!;

    fetchExpertEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Earnings'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Total Earnings",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return earningsCard(
                          earnings.data == null
                              ? " "
                              : earnings.data!.revenuesData![index]
                                  .hcConsultationId!.sId
                                  .toString(),
                          earnings.data == null
                              ? " "
                              : earnings.data!.revenuesData![index].createdAt!
                                  .split("T")[0],
                          earnings.data == null
                              ? " "
                              : earnings.data!.revenuesData![index]
                                  .hcConsultationId!.userId![0].firstName,
                          earnings.data == null
                              ? " "
                              : earnings.data!.revenuesData![index].sessionCost,
                          earnings.data == null
                              ? " "
                              : earnings.data!.revenuesData![index].payout,
                          earnings.data == null
                              ? " "
                              : earnings.data!.revenuesData![index].serviceTax
                                  .toString());
                    },
                    itemCount: earnings.data!.revenuesData!.isEmpty
                        ? 0
                        : earnings.data!.revenuesData!.length,
                  ),
                )
              ],
            ),
    );
  }

  Widget earningsCard(String? consultId, String? consultDate, String? client,
      String? sessionCost, String? payout, String? serviceTax) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 30,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: List<Widget>.generate(
              //     items.length,
              //     (int index) {
              //       return Expanded(
              //         child: ChoiceChip(
              //           label: Text(items[index]["title"]!),
              //           selected: value == index,
              //           onSelected: (bool selected) {
              //             setState(() {
              //               value = selected ? index : null;
              //             });
              //             fetchExpertEarnings();
              //           },
              //           selectedColor:
              //               Theme.of(context).colorScheme.secondary,
              //           backgroundColor: Colors.grey[800],
              //           labelStyle:
              //               Theme.of(context).textTheme.bodyMedium!.copyWith(
              //                     color: whiteColor,
              //                   ),
              //         ),
              //       );
              //     },
              //   ).toList(),
              // ),
              // const SizedBox(height: 20),
              // Text(
              //   value == 0
              //       ? todaysDate
              //       : value == 1
              //           ? '$lastWeek to $todaysDate'
              //           : thisMonth,
              // ),

              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(20),
              //     child: Text(
              //       earnings.totalPayout == null
              //           ? "Rs. 0"
              //           : "Rs. ${earnings.totalPayout}",
              //       style: Theme.of(context).textTheme.labelMedium,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 40),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Amount Paid",
              //               style: Theme.of(context).textTheme.labelMedium,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Rs. 2,000",
              //               style: Theme.of(context).textTheme.labelMedium,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Amount Pending",
              //               style: Theme.of(context).textTheme.labelMedium,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Rs. 0",
              //               style: Theme.of(context).textTheme.labelMedium,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Consultation Id",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earnings.data == null ||
                                    earnings.data!.revenuesData!.isEmpty
                                ? "0"
                                : consultId.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Consultation Date",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earnings.data == null ||
                                    earnings.data!.revenuesData!.isEmpty
                                ? "0"
                                : consultDate.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Client",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earnings.data == null ||
                                    earnings.data!.revenuesData!.isEmpty
                                ? "0"
                                : client.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Session Cost",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earnings.data == null ||
                                    earnings.data!.revenuesData!.isEmpty
                                ? "0"
                                : sessionCost!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payout",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earnings.data == null ||
                                    earnings.data!.revenuesData!.isEmpty
                                ? "0"
                                : payout!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Service Tax",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earnings.data == null ||
                                    earnings.data!.revenuesData!.isEmpty
                                ? "0"
                                : serviceTax!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
