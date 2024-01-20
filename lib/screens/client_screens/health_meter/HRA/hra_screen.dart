// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/HRA/hra_pdf_viewer.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/hra_model/hra_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_risk_assessment/hra_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/HRA/hra_assessment.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HraScreen extends StatefulWidget {
  final List<HraAnswerModel> hraData;
  const HraScreen({required this.hraData, Key? key}) : super(key: key);

  @override
  State<HraScreen> createState() => _HraScreenState();
}

class _HraScreenState extends State<HraScreen> {
  late String userId;
  List<HraAnswerModel> hraAnswers = [];
  bool isLoading = false;
  Future<void> getHraAnswers() async {
    setState(() {
      isLoading = true;
    });
    try {
      hraAnswers = await Provider.of<HraProvider>(context, listen: false)
          .getHraScore(userId);
      log('hra score fetched');
    } on HttpException catch (e) {
      log("Unable to fetch hra score $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error loading hra score $e");
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
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    getHraAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Health Risk Assessment'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        style: Theme.of(context).textTheme.bodySmall,
                        children: <TextSpan>[
                          TextSpan(
                              text: '\n\nSource',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrl(Uri.parse(
                                    "https://www.calculator.net/bmi-calculator.html"))),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[850],
                      child: Image.asset(
                        'assets/icons/hra_icon.png',
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Health Risk Assessment is a questionnaire to evaluate your health risks and quality of life.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GradientButton(
                      title: 'TAKE A HRA',
                      func: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const HraAssessment();
                        })).then((value) async {
                          if (value == true) {
                            await getHraAnswers();
                            showHraReport(context);
                            setState(() {});
                          }
                        });
                      },
                      gradient: blueGradient,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      'Previous HRA',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  hraAnswers.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text("No data available"),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              hraAnswers.length > 5 ? 5 : hraAnswers.length,
                          itemBuilder: (context, index) {
                            String tempDate = hraAnswers[index].createdAt!;
                            DateTime dateCreated =
                                DateFormat("yyyy-MM-dd").parse(tempDate);
                            String createdAt =
                                DateFormat("d MMM yyyy").format(dateCreated);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            createdAt,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 3),
                                          Container(
                                            height: 2,
                                            width: 100,
                                            color: orange,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Score : ${hraAnswers[index].hraScore}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (hraAnswers.isNotEmpty) {
                                            createFileOfPdfUrl(hraAnswers[index]
                                                    .reportUrl!)
                                                .then((f) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFScreen(path: f.path),
                                                ),
                                              );
                                            });
                                            // launchUrl(
                                            //   Uri.parse(
                                            //       hraAnswers[index].reportUrl ??
                                            //           ""),
                                            //   mode: LaunchMode
                                            //       .externalApplication,
                                            // );
                                          }
                                        },
                                        child: const Text('Show Report'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: TextButton(
                          onPressed: hraAnswers.isEmpty
                              ? () {
                                  Fluttertoast.showToast(
                                      msg: "No HRA tests taken");
                                }
                              : () {
                                  showAllHra();
                                },
                          child: Text(
                            'View all previous HRA',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: orange,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Future<File> createFileOfPdfUrl(String pdfUrl) async {
    Completer<File> completer = Completer();
    try {
      final url = pdfUrl;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  showHraReport(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Your HRA Result"),
      content: Text("Score : ${hraAnswers[0].hraScore}/100"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAllHra() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 32,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hraAnswers.length,
              itemBuilder: (context, index) {
                String tempDate = hraAnswers[index].createdAt!;
                DateTime dateCreated = DateFormat("yyyy-MM-dd").parse(tempDate);
                String createdAt = DateFormat("d MMM yyyy").format(dateCreated);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                createdAt,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 3),
                              Container(
                                height: 2,
                                width: 100,
                                color: orange,
                              ),
                            ],
                          ),
                          Text(
                            'Score : ${hraAnswers[index].hraScore}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('View Report'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
