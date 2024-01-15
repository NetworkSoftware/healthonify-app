import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/calendar_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class CheckInLogScreen extends StatefulWidget {
  const CheckInLogScreen({Key? key}) : super(key: key);

  @override
  State<CheckInLogScreen> createState() => _ViewAppointmentScreenState();
}

class _ViewAppointmentScreenState extends State<CheckInLogScreen> {
  String? date;

  String id = "61fb81d2022efd3f889a3967";

  void getDate(BuildContext context, String d) {
    setState(() {
      date = d;
    });
    log(date!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22, left: 16, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Check in Logs',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  // CustomDropDownButton(),
                ],
              ),
            ),
            CalendarWidget(getDate: getDate),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logs',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      date != null
                          ? Text(
                              DateFormat.yMMMMd().format(
                                  DateFormat("MM/dd/yyyy").parse(date!)),
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : Text(
                              DateFormat.yMMMMd().format(DateTime.now()),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    excerciseTile(context),
                    const Divider(),
                  ],
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget excerciseTile(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Excercise 1',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Wed, 15th Jun 2022, 1:08 pm',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
        size: 28,
      ),
    );
  }
}
