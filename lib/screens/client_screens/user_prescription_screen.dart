import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/prescription/prescription_model.dart';
import 'package:healthonify_mobile/providers/experts/store_prescription_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/pdf_viewing_screen.dart';
import 'package:provider/provider.dart';

class PrescriptionUserScreen extends StatefulWidget {
  const PrescriptionUserScreen({
    Key? key,
    required this.ticketNumber,
  }) : super(key: key);
  final String ticketNumber;

  @override
  State<PrescriptionUserScreen> createState() => _PrescriptionUserScreenState();
}

class _PrescriptionUserScreenState extends State<PrescriptionUserScreen> {
  bool isLoading = false;

  Future<void> getConsultations() async {
    setState(() {
      isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<StorePrescriptionProvider>(context, listen: false)
          .getPrescriptionAllData(widget.ticketNumber);
    } on HttpException catch (e) {
      log("fetch all consultations error http $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting consultations $e");
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
    getConsultations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "Prescription"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) :

      Consumer<StorePrescriptionProvider>(
          builder: (context, value, child) => ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: value.prescriptionList.length,
              itemBuilder: (context, index) {
                return enquiryCard(context,value.prescriptionList[index]);
              })),
    );
  }

  Widget enquiryCard(BuildContext context,PrescriptionConsultation consultation) {
    // final date =
    // StringDateTimeFormat().stringtDateFormatLogWeight(enquiries.date!);
    // final time =
    // StringDateTimeFormat().stringToTimeOfDay(enquiries.time!);

    // String status = "";
    // if (enquiries.status == "Interested") {
    //   status = "Review in Progress";
    // } else if (enquiries.status == "generalEnquiryInitiated") {
    //   status = "Review in Progress";
    // } else if (enquiries.status == "initiated") {
    //   status = "Review in Progress";
    // } else if (enquiries.status == "packagePaymentRequested") {
    //   status = "View Package Details";
    // } else if (enquiries.status == "packageSubscribed") {
    //   status = "View Sessions";
    // } else {
    //   status = "View Details";
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoRow(title: 'Ticket Number', value: consultation.ticketNumber!),
              infoRow(title: 'Gender', value: consultation.gender!),
              //infoRow(title: 'Date', value: consultation.date!),
              infoRow(title: 'Complaints', value: consultation.chiefComplaints!),
              infoRow(title: 'Report Type', value: consultation.reportType!),
              const SizedBox(height: 10),
              Text(
                "Medicines",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              infoRow(title: 'Name', value: consultation.medicines!.first['medicineName']),
              infoRow(title: 'Duration', value: consultation.medicines!.first['duration']),
              infoRow(title: 'No.Tablet', value: consultation.medicines!.first['count']),
              infoRow(title: 'Description', value: consultation.medicines!.first['description']),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfScreen(
                                url: consultation.prescriptionUrl,
                              )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: orange,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: const Text(
                        'Download Prescription',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow({required String title, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
