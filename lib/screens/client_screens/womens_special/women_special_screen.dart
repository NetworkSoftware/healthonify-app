// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/womens_special_fn/womens_special_fns.dart';
import 'package:healthonify_mobile/models/womens_special_models/ws_flow_intensity_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/womens_special/womens_special_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/womens_special/log_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class WomenSpecialScreen extends StatefulWidget {
  const WomenSpecialScreen({Key? key}) : super(key: key);

  @override
  State<WomenSpecialScreen> createState() => _WomenSpecialScreenState();
}

class _WomenSpecialScreenState extends State<WomenSpecialScreen> {
  bool isLoading = false;
  bool isScreenLoading = false;
  List legends = [
    'Menstruation',
    'Ovulation day',
    'Fertile window',
    'Predicted period',
    'Flow/Moods/Symptoms',
  ];
  List legendColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];

  void loadApis(String date) async {
    setState(() {
      isScreenLoading = true;
    });
    await WomensSpecialFun().fetchFlowIntensity(context);
    await WomensSpecialFun().fetchSymptoms(context);
    await WomensSpecialFun().fetchMoods(context);
    await WomensSpecialFun().fetchPeriods(context,
        userId: Provider.of<UserData>(context, listen: false).userData.id!,
        date: date);

    setState(() {
      isScreenLoading = false;
    });
  }

  void loadPeriods(DateTime date) async {
    setState(() {
      isLoading = true;
    });
    await WomensSpecialFun().fetchPeriods(
      context,
      userId: Provider.of<UserData>(context, listen: false).userData.id!,
      date: DateFormat("yyyy-MM-dd").format(date),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadApis(DateFormat("yyyy-MM-dd").format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "Women's Special"),
      body: isScreenLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'My Goal',
                  //         style: Theme.of(context).textTheme.bodyLarge,
                  //       ),
                  //       IconButton(
                  //         onPressed: () {
                  //           Navigator.push(context,
                  //               MaterialPageRoute(builder: (context) {
                  //             return const WomensSettings();
                  //           }));
                  //         },
                  //         icon: const Icon(
                  //           Icons.settings,
                  //           color: Colors.grey,
                  //           size: 28,
                  //         ),
                  //         splashRadius: 18,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 10),
                    child: Text(
                      'Track cycle',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  calendarCard(),
                  isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : logCycleCard(),
                  logOtherParams(),
                ],
              ),
            ),
    );
  }

  Widget calendarCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 350,
                child: CalendarCarousel(
                  onDayPressed: (DateTime date, p1) async {
                    loadPeriods(date);
                  },
                  pageSnapping: true,
                  customGridViewPhysics: const NeverScrollableScrollPhysics(),
                  weekendTextStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: orange),
                  weekdayTextStyle: Theme.of(context).textTheme.bodyMedium,
                  daysTextStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                  thisMonthDayBorderColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 130,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: legends.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: legendColors[index],
                              radius: 6,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              legends[index],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logCycleCard() {
    return Consumer<WomensSpecialProvider>(
      builder: (context, value, child) => value.periodLogs.isEmpty
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("No Logs found"),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: value.periodLogs.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (value.periodLogs[0].flowIntensity.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        'Flow',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 130,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: value
                                          .periodLogs[0].flowIntensity.length,
                                      itemBuilder: (context, index) {
                                        return scrollCard(
                                          data: value.flowIntensity[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            if (value.periodLogs[0].symptoms.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        'Symptoms',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          value.periodLogs[0].symptoms.length,
                                      itemBuilder: (context, index) {
                                        return scrollCard(
                                          data: value.symptoms[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            if (value.periodLogs[0].moods.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        'Moods',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 130,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          value.periodLogs[0].moods.length,
                                      itemBuilder: (context, index) {
                                        return scrollCard(
                                          data: value.moods[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: const [
                            //     Text('Menstrual Period'),
                            //     Text('Day 1/5'),
                            //   ],
                            // ),
                            // const Divider(height: 30),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: const [
                            //     Text('Current cycle'),
                            //     Text('Day 1/28'),
                            //   ],
                            // ),
                            // const Divider(height: 30),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: const [
                            //     Text('Fertile window starts in'),
                            //     Text('9 days'),
                            //   ],
                            // ),
                            const SizedBox(height: 10),
                          ],
                        )
                      : const SizedBox(),
                ),
              ),
            ),
    );
  }

  Widget logOtherParams() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Menstruation',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: Text(
            //     'Low chance of getting pregnant',
            //     style: Theme.of(context).textTheme.bodySmall,
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WomenLogScreen();
                })).then((value) {
                  if (value == true) {
                    loadPeriods(DateTime.now());
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey[350],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 46,
                              decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              child: Center(
                                child: Text(
                                  'Log',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: whiteColor,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: null,
                            child: Text('Flow'),
                          ),
                          TextButton(
                            onPressed: null,
                            child: Text('Mood'),
                          ),
                          TextButton(
                            onPressed: null,
                            child: Text('Symptoms'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scrollCard({
    required WSLogModel data,
  }) {
    return Card(
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: data.mediaLink,
                      height: 46,
                      width: 46,
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/icons/women_icon.png',
                        height: 46,
                        width: 46,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.name,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black,
                          ),
                      textAlign: TextAlign.center,
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
