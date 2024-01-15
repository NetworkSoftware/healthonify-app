import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_mangement_enq.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:provider/provider.dart';

class WMMyAppoinmentsCard extends StatefulWidget {
  final Function onRequest;
  const WMMyAppoinmentsCard({required this.onRequest, Key? key})
      : super(key: key);

  @override
  State<WMMyAppoinmentsCard> createState() => _WMMyAppoinmentsCardState();
}

class _WMMyAppoinmentsCardState extends State<WMMyAppoinmentsCard> {
  final Map<String, String> data = {
    "name": "",
    "source": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "",
  };
  // final _form = GlobalKey<FormState>();

  void getMessage(String message) => data["message"] = message;

  Future<void> submitForm() async {
    String userId = Provider.of<UserData>(context).userData.id!;
    try {
      await Provider.of<WMEnqProvider>(context, listen: false)
          .getWmEnquiry("userId=$userId");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      // Fluttertoast.showToast(msg: "Not able to submit your request");
    }
  }

  void onSubmit() {
    // if (!_form.currentState!.validate()) {
    //   // setState(() => isLoading = false);
    //   return;
    // }
    // _form.currentState!.save();
    // log(data.toString());
    submitForm();
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNo"] = userData.mobile ?? "";
    data["userId"] = userData.id!;
    data["enqFor"] = "Physiotherapy";
    data["category"] = "Physiotherapy";
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    onSubmit();
    setData(userData);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.98,
          child: Card(
            elevation: 5,
            color: const Color(0xFFec6a13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child:  Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AllAppointmentsScreen(flow: 'manageWeight'),
                        ),
                      );
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFec6a13))),
                              child: const Center(
                                child: Text(
                                  "View",
                                  style: TextStyle(
                                      color: Color(0xFFec6a13),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Appointments",
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelLarge!.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Book and View your appointments here',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );




      Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.98,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Appointments",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Book and view your consultations here',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints:
                            const BoxConstraints(minWidth: 70, minHeight: 40),
                        decoration: BoxDecoration(
                          gradient: purpleGradient,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => const WmMyConsultations(),
                            //   ),
                            // );

                            Navigator.of(
                              context, /*rootnavigator: true*/
                            ).push(
                              MaterialPageRoute(
                                builder: (context) => AllAppointmentsScreen(flow: 'manageWeight'),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: Text(
                              'View',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(minWidth: 90, minHeight: 40),
                        decoration: BoxDecoration(
                          gradient: purpleGradient,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            widget.onRequest();
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Request',
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
                      // TextButton.icon(
                      //   onPressed: () {
                      //     widget.onRequest();
                      //   },
                      //   // check this api. Some changes have been done
                      //   // _showBottomSheet(userData, getMessage, _form);

                      //   //making button tap dynamic to allow different functionalities on different screens.
                      //   // showDatePicker(
                      //   //   context: context,
                      //   //   initialDate: DateTime.now(),
                      //   //   firstDate: DateTime(1800),
                      //   //   lastDate: DateTime(2200),
                      //   // ),
                      //   icon: const Icon(
                      //     Icons.add,
                      //     color: Colors.white,
                      //   ),
                      //   label: Text(
                      //     'Request',
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .labelMedium!
                      //         .copyWith(color: whiteColor),
                      //   ),
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: const Color(0xFF8E4CED),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _showBottomSheet(
  //   User data,
  //   Function getValue,
  //   GlobalKey<FormState> _key,
  // ) {
  //   showModalBottomSheet(
  //       elevation: 10,
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (ctx) => Form(
  //             key: _key,
  //             child: Padding(
  //               padding: EdgeInsets.only(
  //                   top: 15,
  //                   left: 15,
  //                   right: 15,
  //                   bottom: MediaQuery.of(ctx).viewInsets.bottom + 1),
  //               child: Column(mainAxisSize: MainAxisSize.min, children: [
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Center(
  //                   child: Text(
  //                     "Request Appointment",
  //                     style: Theme.of(context).textTheme.headlineSmall,
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Explain your issue",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       IssueField(getValue: getValue),
  //                       const SizedBox(
  //                         height: 20,
  //                       ),
  //                       Center(
  //                           child: SaveButton(
  //                         isLoading: false,
  //                         submit: onSubmit,
  //                         title: "Request Now",
  //                       )),
  //                     ],
  //                   ),
  //                 )
  //               ]),
  //             ),
  //           ));
  // }
}
