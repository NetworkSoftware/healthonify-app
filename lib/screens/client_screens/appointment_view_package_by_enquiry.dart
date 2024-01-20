import "dart:developer";

import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:healthonify_mobile/constants/theme_data.dart";
import "package:healthonify_mobile/models/appointment_consultation/appointment_package_consultation_model.dart";
import "package:healthonify_mobile/models/http_exception.dart";
import "package:healthonify_mobile/providers/all_consultations_data.dart";
import "package:healthonify_mobile/providers/user_data.dart";
import "package:healthonify_mobile/screens/client_screens/appointment_view_session_by_enquiry.dart";
import "package:healthonify_mobile/screens/pay_now.dart";
import "package:healthonify_mobile/widgets/cards/custom_appbar.dart";
import "package:provider/provider.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

class AppointmentViewPackageByEnquiry extends StatefulWidget {
  AppointmentViewPackageByEnquiry(
      {Key? key, required this.ticketNumber, required this.flow})
      : super(key: key);
  String ticketNumber;
  String flow;

  @override
  State<AppointmentViewPackageByEnquiry> createState() =>
      _AppointmentViewPackageByEnquiryState();
}

class _AppointmentViewPackageByEnquiryState
    extends State<AppointmentViewPackageByEnquiry> {
  bool _isLoading = false;
  int currentPage = 0;
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No Data Found'),
    ),
    duration: Duration(milliseconds: 1000),
  );
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getPackageConsultations();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.ticketNumber),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<AllConsultationsData>(
              builder: (context, value, child) => ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10),
                    child: Text(
                      "Package Subscription Details",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: value.packageConsultationList.length,
                      itemBuilder: (context, index) {
                        return consultCard(
                            context, value.packageConsultationList[index]);
                      }),
                ],
              ),
            ),
    );
  }

  Widget consultCard(
      BuildContext context, AppointmentPackageConsultation consult) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${consult.expertId!['firstName']} ${consult.expertId!['lastName']}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        backgroundImage: consult.expertId!['imageUrl'].isEmpty
                            ? const AssetImage(
                                "assets/icons/user.png",
                              ) as ImageProvider
                            : NetworkImage(
                                consult.expertId!['imageUrl'],
                              ),
                        radius: 35,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  infoRow(
                      title: 'Package Name',
                      value: consult.packageId!['name']!),
                  infoRow(
                      title: 'Category',
                      value: consult.packageId!['expertiseId']['name']!),
                  infoRow(
                      title: 'SubCategory',
                      value: consult.packageId!['subCategoryId']['name']!),
                  infoRow(
                      title: 'ConsultationCharge',
                      value: consult.packageId!['price']),
                  infoRow(
                      title: 'Benefits',
                      value: consult.packageId!['benefits'] ?? ""),
                  infoRow(
                      title: 'Description',
                      value: consult.packageId!['description']),
                  infoRow(
                      title: 'Status',
                      value: consult.status!),
                  const SizedBox(height: 20),
                  consult.status == 'packagePaymentRequested' ?
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        bool result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PayNowScreen(paymentUrl: consult.paymentLink!);
                        }));

                        if (result == true) {
                          getPackageConsultations();
                        }
                        //launchUrl(Uri.parse(consult.paymentLink!));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: orange),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ) : const SizedBox()
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Text(
              "Service Details",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount:  consult.serviceDetails!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoRow(
                            title: 'Service Name',
                            value: consult.serviceDetails![index]['serviceName']!),
                        infoRow(
                            title: 'Expert',
                            value: "${consult.serviceDetails![index]['expertId']['firstName']!} ${consult.serviceDetails![index]['expertId']['lastName']!}"),

                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () async {
                             await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return AppointmentViewSessionByEnquiry(
                                      ticketNumber: widget.ticketNumber,
                                      flow: consult.serviceDetails![index]['serviceName']!,
                                    );
                                  }));

                              // if(result == true){
                              //   if (widget.flow == '') {
                              //     getConsultations();
                              //   } else {
                              //     getFlowConsultations();
                              //   }
                              // }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: orange,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: const Text(
                                  "View Session",
                                  style:
                                  TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),

        ],
      ),
    );
  }

  Future<void> getPackageConsultations() async {
    log(currentPage.toString());
    setState(() {
      _isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<AllConsultationsData>(context, listen: false)
          .getUserPackageConsultationsData(widget.ticketNumber, widget.flow);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting consultations $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultations");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
