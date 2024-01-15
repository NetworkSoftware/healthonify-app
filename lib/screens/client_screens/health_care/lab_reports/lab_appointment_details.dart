import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../../models/health_care/LabStatusModel.dart';
import '../../../../providers/labs_provider/labs_provider.dart';

class MyLabAppointmentScreen extends StatefulWidget {
  final String? userId;
  const MyLabAppointmentScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<MyLabAppointmentScreen> createState() => _MyLabAppointmentScreenState();
}

class _MyLabAppointmentScreenState extends State<MyLabAppointmentScreen> {
  bool isloading = false;
  LabStatusModel? myLabReports;

  Future<void> fetchMyLabReports() async {
    setState(() {
      isloading = true;
    });
    try {
      myLabReports = await Provider.of<LabsProvider>(context, listen: false)
          .getLabAppointmentStatus(userId);

      print("REEESPONSE = $myLabReports");
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
      appBar: const CustomAppBar(appBarTitle: 'My Lab Appointments'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : myLabReports!.data!.isEmpty
              ? const Center(
                  child: Text('No Lab Appointments available'),
                )
              : ListView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: myLabReports!.data!.length,
          itemBuilder: (context, index) {
            String reportDate = myLabReports!
                .data![index].createdAt
                .toString()
                .split("T")[0];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     myLabReports!.data![index].labId!
                    //         .vendorId!.firstName
                    //         .toString(),
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .labelLarge,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(reportDate),
                          Text(myLabReports!.data![index].status
                              .toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
