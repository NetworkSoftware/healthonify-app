import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/forms/medical_form_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class MedicalFormScreen extends StatelessWidget {
  final bool isFromClient;
  final String clientId;
  MedicalFormScreen({
    super.key,
    this.isFromClient = false,
    this.clientId = "",
  });

  List<MedicalForm> medicalForm = [];

  Future<void> getMedicalFormQuestions(BuildContext context) async {
    try {
      medicalForm = await MedicalFormFunc().fetchUserMedicalForm(clientId);

      print("Medical Form1 : $medicalForm");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting medical form $e");
      Fluttertoast.showToast(msg: "unable to get questions");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Medical History'),
      body: FutureBuilder(
        future: getMedicalFormQuestions(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : medicalForm.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 15.0, left: 8, right: 8),
                        child: Center(child: Text("No details available")),
                      )
                    : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: medicalForm.length -1,
                              itemBuilder: (context, index) =>
                                  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Q : ${medicalForm[index].question}"),
                                        Text("A : ${medicalForm[index].answer}")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                child: Text("Note : ${medicalForm.last.notes}"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
      ),
    );
  }
}
