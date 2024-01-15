import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/enquiry_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class EnquiryListScreen extends StatefulWidget {
  const EnquiryListScreen({super.key});

  @override
  State<EnquiryListScreen> createState() => _EnquiryListScreenState();
}

class _EnquiryListScreenState extends State<EnquiryListScreen> {
  List<EnquiryFormModel> enquiryData = [];

  bool isLoading = false;

  Future<void> getExperts() async {
    setState(() {
      isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      enquiryData = await Provider.of<EnquiryData>(context, listen: false)
          .getEnquiryData(userId: userId);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error get fetch experts $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getExperts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Your appointments',
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: enquiryData.length,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              itemBuilder: (context, index) => Card(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expert - ${enquiryData[index].name}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text("Issue : ${enquiryData[index].message}"),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Ticket number : ${enquiryData[index].ticketNumber}",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              )),
            ),
    );
  }
}
