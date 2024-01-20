import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/session_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/subs_data_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExcerciseWithDoctor extends StatelessWidget {
  const ExcerciseWithDoctor({Key? key}) : super(key: key);

  Future<void> fetchSessions(BuildContext context) async {
    String userId = Provider.of<UserData>(context).userData.id!;
    try {
      await Provider.of<SessionData>(context, listen: false)
          .getAllSessions(data: "?userId=$userId&status=stored");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get sessions $e");
      // Fluttertoast.showToast(msg: "Unable to get your sessions");
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isToday = false;
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Excercise with Doctor'),
      body: FutureBuilder(
        future: fetchSessions(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Consumer<SessionData>(
                      builder: (context, value, child) => value.session.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: Center(
                                child: Text("Expert is yet to assign sessions"),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: value.session.length,
                              itemBuilder: (context, index) {
                                return SubsDataCard(
                                  session: value.session[index],
                                );
                              },
                              scrollDirection: Axis.vertical,
                            ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.5,
        // constraints: const BoxConstraints(minWidth: 70, minHeight: 40),
        decoration: BoxDecoration(
          gradient: blueGradient,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              launchUrl(Uri.parse('https://api.whatsapp.com/send/?phone=919743474558&text=Hi,&type=phone_number&app_absent=0'),
                  mode: LaunchMode.externalApplication);
            },
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.mark_chat_unread_outlined,
                      color: whiteColor,
                      size: 30,
                    ),
                    Text(
                      'Chat with Expert',
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
        ),
      ),
    );
  }

  Widget todayAppointment(
      context, Widget? scheduledDate, String buttonText, bool isToday) {
    // bool isToday = false;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Appointment Name',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(
                'with Expert Name',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    scheduledDate!,
                    const Spacer(),
                    Icon(Icons.schedule_rounded,
                        size: 22,
                        color: isToday
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[500]),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        '2:40 pm',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: isToday
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Status : ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isToday
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[500]),
                  ),
                  Text(
                    'Scheduled',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isToday
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[500]),
                  ),
                  const Spacer(),
                  GradientButton(
                    title: buttonText,
                    func: () {},
                    gradient: orangeGradient,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text(buttonText),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
