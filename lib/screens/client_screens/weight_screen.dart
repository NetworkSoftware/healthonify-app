import 'dart:developer';
import 'package:healthonify_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/tracker_models/weight_log.dart';
import 'package:healthonify_mobile/models/wm/goals_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_logs.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_goal/weight_goal_provider.dart';
import 'package:healthonify_mobile/widgets/cards/add_logs_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/lost_weight_card.dart';
import 'package:healthonify_mobile/widgets/cards/weight_log_graph.dart';
import 'package:provider/provider.dart';

class WeightScreen extends StatefulWidget {
  final bool isFromClient;
  final String? clientId;

  const WeightScreen({Key? key, this.clientId, this.isFromClient = false})
      : super(key: key);

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> fetchWeightLogs(String id) async {
    try {
      if (widget.isFromClient) {
        await Provider.of<WeightLogs>(context, listen: false)
            .getWeightLogs(widget.clientId!);
      } else {
        await Provider.of<WeightLogs>(context, listen: false).getWeightLogs(id);
      }
      await fetchWeightGoalData();
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching logs');
    }
  }

  Map<String, dynamic> weightLogData = {
    'userId': '',
    'date': '',
    'timeInMs': '',
    'weight': '',
  };
  Map<String, dynamic> editWeightLogData = {
    'set': {
      'date': '',
      'weight': '',
    },
  };

  void popFunc() {
    Navigator.of(context).pop();
  }

  late String userId;

  Future<void> postWeightLog(BuildContext context) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<WeightLogs>(context, listen: false)
          .postWeightLogs(weightLogData);

      await fetchWeightLogs(userId!);
      Fluttertoast.showToast(msg: 'Weight Log added');
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to create weight log');
    }
  }

  Future<void> updateWeightLog(BuildContext context, String weightLogId) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<WeightLogs>(context, listen: false)
          .updateWeightLogs(weightLogId, editWeightLogData, userId!);

      await fetchWeightLogs(userId);
      Fluttertoast.showToast(msg: 'Weight Log updated');
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: 'Unable to update weight log');
    }
  }

  void onUpdate(BuildContext context) {
    weightLogData['userId'] = userId;
    weightLogData['date'] = DateFormat("MM/dd/yyyy").format(DateTime.now());
    weightLogData['timeInMs'] = 1654231571755;

    log('$userId this is the id to which the data is being posted');
  }

  void onSubmit(bool isEdit, [String? weightLogId]) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    isEdit ? updateWeightLog(context, weightLogId!) : postWeightLog(context);
  }

  void getWeight(String weight) => weightLogData['weight'] = weight;

  List<WeightGoalModel> weightGoalData = [];

  Future<void> fetchWeightGoalData() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (widget.isFromClient) {
        weightGoalData =
            await Provider.of<WeightGoalProvider>(context, listen: false)
                .getWeightGoals(widget.clientId!);
      } else {
        weightGoalData =
            await Provider.of<WeightGoalProvider>(context, listen: false)
                .getWeightGoals(userId);
      }
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching weight goal data');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.clientId ??
        Provider.of<UserData>(context, listen: false).userData.id!;
    fetchWeightLogs(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: 'Weight',
        widgetRight:  kSharedPreferences.getString("role") != "ROLE_EXPERT" ? Padding(
          padding: const EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: (){
              addWeightLog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.add_circle,
                  color: whiteColor,
                  size: 28,
                ),
                const SizedBox(width: 5),
                Text(
                  'Add Logs',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: whiteColor),
                ),
              ],
            ),
          ),
        ) : const SizedBox(),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<WeightLogs>(
              builder: ((context, data, child) {
                List<WeightLog> recentLogs = data.weightlogs.toList();
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WeightLostCard(
                            updateWeight: fetchWeightGoalData,
                            weightGoalData: weightGoalData.isEmpty
                                ? WeightGoalModel(
                                    activityLevel: 'N/A',
                                    currentWeight: '0',
                                    date: 'N/A',
                                    goalWeight: '0',
                                    startingWeight: '0',
                                    userId: userId,
                                    weeklyGoal: '0')
                                : weightGoalData[0],
                          ),
                        ],
                      ),
                      // const SizedBox(height: 8),
                      // kSharedPreferences.getString("role") != "ROLE_EXPERT"
                      //     ? Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           AddLogsCard(
                      //             onAdd: () {
                      //               addWeightLog(context);
                      //             },
                      //           ),
                      //         ],
                      //       )
                      //     : const SizedBox(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WeightLogGraph(
                            weightLogData: data.weightlogs,
                            weightGoalData: weightGoalData.isEmpty
                                ? WeightGoalModel(
                                    activityLevel: 'N/A',
                                    currentWeight: '0',
                                    date: 'N/A',
                                    goalWeight: '0',
                                    startingWeight: '0',
                                    userId: userId,
                                    weeklyGoal: '0')
                                : weightGoalData[0],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Text(
                          'Recent Logs',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: orange),
                        ),
                      ),
                      recentLogs.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Text(
                                  'No data available',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  recentLogs.length > 5 ? 5 : recentLogs.length,
                              itemBuilder: (context, index) {
                                print("recentLogs : ${recentLogs.length}");
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Card(
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${recentLogs[index].weight} kgs',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          Text(
                                            StringDateTimeFormat()
                                                .stringtDateFormatLogWeight(
                                              recentLogs[index].date!,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                      trailing: kSharedPreferences
                                                  .getString("role") !=
                                              "ROLE_EXPERT"
                                          ? GestureDetector(
                                        onTap: () {
                                          editWeightLog(
                                            context,
                                            recentLogs[index].date!,
                                            recentLogs[index].id!,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: orange
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 25,
                                            color: whiteColor,
                                          ),
                                        ),
                                      )
                                          : const SizedBox(),
                                    ),
                                  ),
                                );
                              },
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: TextButton(
                              onPressed: () {
                                showAllWeightLogs(data);
                              },
                              child: const Text('Show all'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  void showAllWeightLogs(WeightLogs allWeightLogs) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        List<WeightLog> allRecentLogs =
            allWeightLogs.weightlogs.reversed.toList();
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, size: 32),
                    splashRadius: 20,
                  ),
                ],
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: allRecentLogs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${allRecentLogs[index].weight} kgs',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              StringDateTimeFormat().stringtDateFormat(
                                allRecentLogs[index].date!,
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            editWeightLog(
                              context,
                              allRecentLogs[index].date!,
                              allRecentLogs[index].id!,
                            );
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          splashRadius: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void addWeightLog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close_rounded),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  Text(
                    'Enter your weight (in kgs)',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFC3CAD9),
                        ),
                      ),
                      hintText: 'Weight in kgs',
                      hintStyle: const TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onChanged: (value) {
                      getWeight(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your weight';
                      }
                      if (double.parse(value) > 200) {
                        log('value > 200');
                        return 'Please enter a valid weight';
                      }
                      if (value.length > 6) {
                        log('value length is ${value.length}');
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      onUpdate(context);
                      onSubmit(false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFff7f3f),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Update',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void editWeightLog(BuildContext context, String date, String weightId) {
    String? weight;
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close_rounded),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  Text(
                    'Enter your weight',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFC3CAD9),
                        ),
                      ),
                      hintText: 'Weight',
                      hintStyle: const TextStyle(
                        color: Color(0xFF959EAD),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onChanged: (value) {
                      // getWeight(value);
                      weight = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your weight';
                      }
                      if (double.parse(value) > 300) {
                        return 'Please enter a valid weight';
                      }
                      if (value.length > 6) {
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      editWeightLogData['set']['date'] = date;
                      editWeightLogData['set']['weight'] = weight;

                      log(editWeightLogData.toString());
                      onSubmit(true, weightId);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFff7f3f),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Update',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
