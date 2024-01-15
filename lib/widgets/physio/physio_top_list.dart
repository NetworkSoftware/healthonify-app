import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/browse_physio_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/excercise_with_doctor/excercise_w_doctor.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/medical_reports/medical_reports_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/my_connected_therapists.dart';
import 'package:healthonify_mobile/widgets/physio/bottomsheet_freeconsult_datetimepicker.dart';
import 'package:healthonify_mobile/widgets/physio/physio_bottomsheet_datetime_picker.dart';
import 'package:healthonify_mobile/widgets/physio/request_appointment_form.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PhysioTopList extends StatefulWidget {
  final String? id;
  const PhysioTopList({Key? key, required this.id}) : super(key: key);

  @override
  State<PhysioTopList> createState() => _PhysioTopListState();
}

class _PhysioTopListState extends State<PhysioTopList> {
  @override
  void initState() {
    super.initState();
    log("init");
    getExpertise();
  }

  Future<void> getExpertise() async {
    var topLevelExpertiseIdList =
        Provider.of<ExpertiseData>(context, listen: false)
            .topLevelExpertiseData;
    String? id;
    log("Get exp");
    for (var element in topLevelExpertiseIdList) {
      log("check");

      if (element.name == "Physiotherapy") {
        id = element.id!;
        log("physio");
      }
    }
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchExpertise(id!);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch expertise $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpertiseData>(
      builder: (context, data, child) {
        return  Row(
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                padding: const EdgeInsets.only(left: 10, right: 10),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  physioListItem(
                    context,
                    Image.asset('assets/icons/my_consultation.png'),
                    'Consult Physio',
                    orangeGradient,
                        () {
                      _showConsultPhysiobottomSheet(context);
                    },
                  ),
                  physioListItem(
                    context,
                    Image.asset('assets/icons/enquire.png'),
                    'Request Now',
                    blueGradient,
                        () {
                      _showEnquireNowBottomSheet(context,data);
                    },
                  ),
                  physioListItem(
                    context,
                    Image.asset('assets/icons/free.png'),
                    'Free Consultation',
                    orangeGradient,
                        () {
                      showFreeConsultbtmSheet(
                        context,
                      );
                    },
                  ),
                  physioListItem(
                    context,
                    Image.asset('assets/icons/therapy.png'),
                    'My Therapies',
                    blueGradient,
                        () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ConnectedPhyisoExperts()));
                    },
                  ),
                  physioListItem(
                    context,
                    Image.asset('assets/icons/reports.png'),
                    'Medical Reports',
                    orangeGradient,
                        () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const MedicalReportScreen();
                      }));
                    },
                  ),
                  physioListItem(
                    context,
                    Image.asset('assets/icons/doctor.png'),
                    'Exercise with Doctor',
                    blueGradient,
                        () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const ExcerciseWithDoctor();
                      }));
                    },
                  ),
                  // physioListItem(
                  //   context,
                  //   Image.asset('assets/icons/shop.png'),
                  //   'Shop',
                  //   orangeGradient,
                  //       () {
                  //     launchUrl(
                  //       Uri.parse("https://healthonify.com/Shop"),
                  //       mode: LaunchMode.externalApplication,
                  //     );
                  //   },
                  // ),
                  physioListItem(
                    context,
                    Image.asset('assets/icons/browse_plans.png'),
                    'View Plans',
                    purpleGradient,
                        () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BrowsePhysioPlans(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );



  }

  Widget physioListItem(
      BuildContext context,
      Image icon,
      String name,
      Gradient gradientColor,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
              gradient: gradientColor, borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: icon,
                ),
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: whiteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConsultPhysiobottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => FutureBuilder(
        future: getExpertise(),
        builder: (context, snapshot) => snapshot.connectionState ==
            ConnectionState.waiting
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Consumer<ExpertiseData>(
          builder: (context, data, child) => DraggableScrollableSheet(
            initialChildSize: 1,
            builder: (context, scrollController) => Container(
              color: Theme.of(context).canvasColor,
              // color: const Color.fromARGB(255, 34, 34, 34),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enquiry for',
                          style:
                          Theme.of(context).textTheme.headlineSmall,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: orange,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    itemCount: data.expertise.length,
                    itemBuilder: (cxt, index) => Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              showbtmSheet(context, {
                                "expertiseId": data.expertise[index].id,
                                "name": data.expertise[index].name
                              });
                            },
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.expertise[index].name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
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
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.teal,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showbtmSheet(BuildContext context, Map<String, dynamic> data) {
    // log(data.toString());

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: PhysioBottomSheetDateAndTimePicker(data: data),
      ),
    );
  }

  void showFreeConsultbtmSheet(BuildContext context) {
    // log(data.toString());

    Map<String, dynamic> data = {
      "type": "",
      "status": "",
      "userId": "",
      "startDate": "",
      "startTime": "",
      "durationInMinutes": 60,
    };

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: BottomsheetFreeConsultDatetimePicker(data: data),
      ),
    );
  }

  void _showEnquireNowBottomSheet(
      BuildContext context,
      ExpertiseData data,
      // Function getValue,
      // GlobalKey<FormState> _key,
      ) {
    log("into the verse");
    List<String> options = [];
    List<String> id = [];
    for (var element in data.expertise) {
      options.add(element.name!);
      id.add(element.id!);
    }
    showModalBottomSheet(
      elevation: 10,
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>  RequestAppointmentForm(
        title: "Enquire Now",
        options: options,
        buttonTitle: "Enquire Now",
      ),
    );
  }
}
