import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/batches/batches_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/batch_providers/batch_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class JoinBatchScreen extends StatefulWidget {
  const JoinBatchScreen({super.key});

  @override
  State<JoinBatchScreen> createState() => _JoinBatchScreenState();
}

class _JoinBatchScreenState extends State<JoinBatchScreen> {
  bool isLoading = true;
  List<BatchModel> batches = [];

  Future<void> getAllBatches() async {
    try {
      batches = await Provider.of<BatchProvider>(context, listen: false)
          .getUserBatches(userId);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching batches');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userId;

  @override
  void initState() {
    super.initState();

    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    getAllBatches();
  }

  Map<String, dynamic> joinBatch = {};
  void onJoin() {
    joinBatch['userId'] = userId;
    joinBatch['isActive'] = true;
    joinBatch['date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> joinBatches(BuildContext context) async {
    try {
      await Provider.of<BatchProvider>(context, listen: false)
          .joinBatch(joinBatch);
      popFunction();
      Fluttertoast.showToast(msg: 'Batch joined');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to join batch');
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Batches'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : batches.isEmpty
              ? const Center(
                  child: Text("No Batches Joined"),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: batches.length,
                        itemBuilder: (context, index) {
                          DateTime sTime = DateFormat('HH:mm')
                              .parse(batches[index].startTime!);
                          DateTime eTime = DateFormat('HH:mm')
                              .parse(batches[index].endTime!);

                          String startTime = DateFormat('h:mm a').format(sTime);
                          String endTime = DateFormat('h:mm a').format(eTime);

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${batches[index].name}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Time : $startTime to $endTime',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      batches[index].info ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     setState(() {
                                //       joinBatch['batchId'] = batches[index].id!;
                                //     });

                                //     onJoin();

                                //     joinBatches(context);
                                //   },
                                //   child: const Text('Join'),
                                // ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
