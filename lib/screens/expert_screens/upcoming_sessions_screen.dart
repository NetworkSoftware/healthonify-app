// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/session_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/booking_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UpcomingSessions extends StatelessWidget {
  bool _noContent = false;
  Future<void> getFunc(BuildContext context, String id) async {
    String flow = Provider.of<UserData>(context).userData.topLevelExpName!;
    log(flow);
    try {
      await Provider.of<SessionData>(context, listen: false)
          .fetchUpcommingSessions(
              "specialExpertId=61fb81d2022efd3f889a3967", flow);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      _noContent = true;
    } catch (e) {
      log("Error get bookings widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch orders");
      _noContent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Upcoming Sessions',
      ),
      body: FutureBuilder(
        future: getFunc(context, "61fb81d2022efd3f889a3967"),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _noContent
                    ? Center(
                        child: Text("No sessions available"),
                      )
                    : Consumer<SessionData>(
                        builder: (context, value, child) => ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: value.upcomingSessions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: UpcomingSessionsCard(
                                serviceName: 'Service name',
                                customerName: 'Customer Name',
                                invoiceNumber: 'INV-0956',
                                bookingStatus: 'Paid',
                                bookingAmount: '80,000',
                                createdDate: '23/02/2022',
                                dueDate: '28/03/2022',
                                data: value.upcomingSessions[index],
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
