import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lifestyle_model/lifestyle_model.dart';
import 'package:healthonify_mobile/providers/lifestyle_providers/lifestyle_providers.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class LifestyleDetailsScreen extends StatefulWidget {
  final String? clientId;
  const LifestyleDetailsScreen({this.clientId, super.key});

  @override
  State<LifestyleDetailsScreen> createState() => _LifestyleDetailsScreenState();
}

class _LifestyleDetailsScreenState extends State<LifestyleDetailsScreen> {
  bool isloading = false;

  List<LifestyleModel> lifestyleData = [];

  Future<void> fetchLifestyleData(String id) async {
    setState(() {
      isloading = true;
    });
    try {
      lifestyleData =
          await Provider.of<LifeStyleProviders>(context, listen: false)
              .getLifestyleData(id);
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
    roles = Provider.of<UserData>(context, listen: false).userData.roles![0]
        ['name'];

    userId = widget.clientId ??
        Provider.of<UserData>(context, listen: false).userData.id!;

    fetchLifestyleData(roles == 'client' ? userId : widget.clientId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Lifestyle'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  lifestyleData.isEmpty
                      ? const Padding(
                          padding:
                              EdgeInsets.only(top: 15.0, left: 8, right: 8),
                          child: Center(child: Text("No details available")),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: lifestyleData[0].qna!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Q : ${lifestyleData[0].qna![index].question}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      lifestyleData[0]
                                                  .qna![index]
                                                  .answer!
                                                  .length ==
                                              1
                                          ? Text(
                                              "A : ${lifestyleData[0].qna![index].answer![0]}",
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: lifestyleData[0]
                                                  .qna![index]
                                                  .answer!
                                                  .length,
                                              itemBuilder: (context, idx) =>
                                                  Text(
                                                "- ${lifestyleData[0].qna![index].answer![idx]}",
                                              ),
                                            ),
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
