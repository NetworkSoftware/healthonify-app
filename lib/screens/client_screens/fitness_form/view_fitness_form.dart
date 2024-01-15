import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/fitness_form_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/fitness_form_provider/get_fitness_form.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class ViewMyFitnessForm extends StatefulWidget {
  final bool isFromClient;
  final String clientId;

  const ViewMyFitnessForm(
      {required this.clientId, required this.isFromClient, super.key});

  @override
  State<ViewMyFitnessForm> createState() => _ViewMyFitnessFormState();
}

class _ViewMyFitnessFormState extends State<ViewMyFitnessForm> {
  bool isloading = false;

  List<FitnessFormModel> fitnessData = [];

  Future<void> fetchFitnessFormData() async {
    setState(() {
      isloading = true;
    });
    try {
      fitnessData = await Provider.of<FitnessFormProvider>(context,
              listen: false)
          .getFitnessFormData(widget.isFromClient ? widget.clientId : userId);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching logs');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  late String roles;
  late String userId;

  @override
  void initState() {
    super.initState();

    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    fetchFitnessFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Fitness Form'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : fitnessData.isEmpty
              ? const Center(
                  child: Text('No Fitness Data available'),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: fitnessData.length,
                        itemBuilder: (context, index) {
                          log("fitness form data length => ${fitnessData.length}");
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Q : ${fitnessData[index].questionId!.question}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "A : ${fitnessData[index].answer}",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
    );
  }
}
