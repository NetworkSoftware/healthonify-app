import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/session_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/subs_data_card.dart';
import 'package:provider/provider.dart';

class PhysioViewSessions extends StatelessWidget {
  final String? subId;
  const PhysioViewSessions({Key? key, required this.subId}) : super(key: key);

  Future<void> fetchSessions(BuildContext context) async {
    try {
      await Provider.of<SessionData>(context, listen: false)
          .getAllSessions(data: "?subscriptionId=$subId");
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
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'My Sessions',
      ),
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
    );
  }
}
