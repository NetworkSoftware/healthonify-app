import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/forms/medical_form_func.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  List<MedicalForm> medicalForm = [];

  List<String> answers = [];

  String note = "";

  Future<void> getMedicalFormQuestions() async {
    try {
      medicalForm = await MedicalFormFunc().fetchMedicalHistoryQuestions();
      answers = List.generate(medicalForm.length, (index) => "no");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting fitness form $e");
      Fluttertoast.showToast(msg: "unable to get questions");
    }
  }

  void updateAnswers(String value, int index) async {
    answers[index] = value;
  }

  void popScreen() {
    Navigator.of(context).pop();
  }

  void updateMedicalForm() async {
    LoadingDialog().onLoadingDialog("Submitting form", context);
    try {
      await MedicalFormFunc().submitMedicalForm(
        answers: answers,
        note: note,
        userId: Provider.of<UserData>(context, listen: false).userData.id!,
        medicalFormQuestionsData: medicalForm,
      );

      Fluttertoast.showToast(msg: "Form Submitted");
      popScreen();
      popScreen();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting fitness form $e");
      Fluttertoast.showToast(msg: "Unable to submit your answers");
    }
  }

  @override
  Widget build(BuildContext context) {
    // List headers = [
    //   'Heart Condition',
    //   'Diabetes',
    //   'Chest Pain',
    //   'Dizzy Spells',
    //   'Back or Joint Pain',
    //   'Asthma',
    //   'Medication',
    //   'Surgery',
    //   'Injury',
    //   'Pregnancy',
    //   'Allergies',
    //   'Do not have any medical problem',
    // ];
    // List questions = [
    //   'Do you have a heart condition?',
    //   'Do you have diabetes?',
    //   'Do you ever experience pain in your chest while resting or exercising?',
    //   'Do you experience dizziness?',
    //   'Do you have back or joint pain?',
    //   'Do you have asthma?',
    //   'Are you taking any sort of medication? If yes, please specify in the notes section below.',
    //   'Have you had any type of surgery that might affect your physical activity?',
    //   'Do you have any injury or reason to change your exercise regime?',
    //   'Are you pregnant? Or have you given birth in the last 7 weeks?',
    //   'Do you have any allergies?',
    //   'I do not have any medical problems.',
    // ];

    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Medical History'),
      body: FutureBuilder(
        future: getMedicalFormQuestions(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: medicalForm.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  medicalForm[index].conditionName ?? "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              checkboxTile(
                                  false,
                                  medicalForm[index].question ?? "",
                                  updateAnswers,
                                  index),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Add notes if any, for more information on your medical history.',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).canvasColor,
                          filled: true,
                          hintText: 'Add notes',
                          hintStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: const Color(0xFF717579),
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        cursorColor: whiteColor,
                        onChanged: (value) => note = value,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: TextButton(
          onPressed: () {
            updateMedicalForm();
          },
          child: Text(
            'SAVE',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  Widget checkboxTile(
      bool isChecked, String? listTitle, Function updateAnswers, int index) {
    return StatefulBuilder(
      builder: (context, newState) => Theme(
        data: ThemeData(
          unselectedWidgetColor: orange,
        ),
        child: CheckboxListTile(
          value: isChecked,
          title: Text(
            listTitle!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onChanged: (isTapped) {
            newState(
              () {
                isChecked = !isChecked;
              },
            );
            updateAnswers(isChecked ? "yes" : "no", index);
          },
          activeColor: const Color(0xFFff7f3f),
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}
