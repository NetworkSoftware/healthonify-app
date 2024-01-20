import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/notifications_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatelessWidget {
  // final String? notificationTitle;
  // final String? notificationDetail;
  // final String? notificationTime;

  NotificationScreen({
    Key? key,
    // required this.notificationTitle,
    // required this.notificationDetail,
    // required this.notificationTime,
  }) : super(key: key);

  bool _noContent = false;

  Future<void> getFunc(BuildContext context, String id) async {
    try {
      await Provider.of<NotificationsData>(context, listen: false)
          .getNotifications(id);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      _noContent = true;
    } catch (e) {
      log("Error get bookings widget $e");
      _noContent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserData>(context).userData.id;
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Notifications',
      ),
      body: FutureBuilder(
        future: getFunc(context, userId!),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _noContent
                ? const Center(
                    child: Text("No notifications available"),
                  )
                : Consumer<NotificationsData>(
                    builder: (context, value, child) => value
                            .notificationData.isEmpty
                        ? const Center(
                            child: Text("No notifications available"),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.notificationData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${value.notificationData[index].title}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: SelectableText(
                                                '${value.notificationData[index].body}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ),
                                            const Divider(
                                              color: Color(0xFFEFEFEF),
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 12,
                                                      bottom: 12,
                                                    ),
                                                    child: Text(
                                                      '${value.notificationData[index].createdAt}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
      ),
    );
  }
}
