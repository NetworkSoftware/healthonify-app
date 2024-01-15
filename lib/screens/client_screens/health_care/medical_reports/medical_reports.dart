import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/my_reports/my_reports_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/my_reports_provider/my_reports_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyReportsScreen extends StatefulWidget {
  final String? userId;
  const MyReportsScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  bool isloading = false;
  List<MyLabReports> myLabReports = [];

  Future<void> fetchMyLabReports() async {
    setState(() {
      isloading = true;
    });
    try {
      myLabReports =
          await Provider.of<MyLabReportsProvider>(context, listen: false)
              .getMyLabReports(userId);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching logs');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  late String userId;

  @override
  void initState() {
    super.initState();

    userId = widget.userId == null
        ? Provider.of<UserData>(context, listen: false).userData.id!
        : widget.userId!;

    fetchMyLabReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Reports'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : myLabReports.isEmpty
              ? const Center(
                  child: Text('No Lab Reports available'),
                )
              : Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myLabReports.length,
                        itemBuilder: (context, index) {
                          String reportDate = DateFormat('d MMM yyyy')
                              .format(myLabReports[index].reportDate!);
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Lab Report',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(reportDate),
                                        Text(myLabReports[index].reportTime!),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          if (myLabReports.isNotEmpty) {
                                            launchUrl(
                                              Uri.parse(
                                                myLabReports[index]
                                                        .labReportUrl ??
                                                    "",
                                              ),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          }
                                        },
                                        child: const Text('Download Report'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
    );
  }
}
