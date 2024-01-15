import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout_analysis_model/workout_analysis_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/workout_analysis_provider/workout_analysis_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/workout_logs.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class WorkoutAnalysisScreen extends StatefulWidget {
  const WorkoutAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutAnalysisScreen> createState() => _WorkoutAnalysisScreenState();
}

class _WorkoutAnalysisScreenState extends State<WorkoutAnalysisScreen> {
  List<PieChartSectionData> pieChartSectionData = [];
  List counts = [];
  List titles = [
    'Total Workouts',
    'Total Sets',
    'Total Reps',
    'Total Volume',
    'Total Calories burnt',
  ];

  bool isLoading = false;

  WorkoutAnalysisModel workoutAnalysisModel = WorkoutAnalysisModel();

  Future<void> fetchWorkoutAnalysis(bool isDateRangeFilter) async {
    setState(() {
      isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      isDateRangeFilter == false
          ? workoutAnalysisModel = await Provider.of<WorkoutAnalysisProvider>(
                  context,
                  listen: false)
              .getWorkoutAnalysis(userId,
                  "&date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}")
          : workoutAnalysisModel =
              await Provider.of<WorkoutAnalysisProvider>(context, listen: false)
                  .getWorkoutAnalysis(
                      userId, "&fromDate=$startDate&toDate=$endDate");

      pieChartSectionData = workoutAnalysisModel.workoutPercentagesData!.isEmpty
          ? []
          : List.generate(
              workoutAnalysisModel.workoutPercentagesData!.length,
              (index) {
                return PieChartSectionData(
                  value: double.parse(workoutAnalysisModel
                      .workoutPercentagesData![index].percentage!),
                  title:
                      '${workoutAnalysisModel.workoutPercentagesData![index].percentage!}%\n ${workoutAnalysisModel.workoutPercentagesData![index].name!}',
                  color: Colors.red,
                  radius: 90,
                );
              },
            );

      counts = workoutAnalysisModel.workoutPercentagesData!.isEmpty
          ? []
          : List.generate(
              workoutAnalysisModel.workoutPercentagesData!.length,
              (index) {
                return '${workoutAnalysisModel.workoutPercentagesData![index].count!}';
              },
            );
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching logs');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchWorkoutAnalysis(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: 'Workout Analysis',
        widgetRight: calendarButton(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (pieChartSectionData.isNotEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: pieChartSectionData.isEmpty
                            ? const Center(
                                child: Text("No Data Available"),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20),
                                child: PieChart(
                                  PieChartData(
                                    sections: pieChartSectionData,
                                  ),
                                ),
                              ),
                      ),
                    if (pieChartSectionData.isEmpty)
                      const SizedBox(
                        height: 40,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: workoutCards(
                              workoutAnalysisModel.totalCalories == null
                                  ? "0"
                                  : workoutAnalysisModel.totalCalories!
                                      .toStringAsFixed(2),
                              "Total Calories",
                            ),
                          ),
                          Expanded(
                            child: workoutCards(
                              "${workoutAnalysisModel.totalSets ?? "0"}",
                              "Total Sets",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: workoutCards(
                              "${workoutAnalysisModel.totalReps ?? "0"}",
                              "Total Reps",
                            ),
                          ),
                          Expanded(
                            child: workoutCards(
                              "${workoutAnalysisModel.totalVolumeInKgs ?? "0"} kgs",
                              "Total Volume",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: workoutCards(
                              "${workoutAnalysisModel.totalWorkouts ?? "0"}",
                              "Total Workouts",
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: GridView.builder(
                    //     shrinkWrap: true,
                    //     physics: const BouncingScrollPhysics(),
                    //     gridDelegate:
                    //         const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       mainAxisSpacing: 4,
                    //       childAspectRatio: 1 / 0.5,
                    //     ),
                    //     itemCount: counts.length,
                    //     itemBuilder: (context, index) {
                    //       return workoutCards(
                    //         counts[index],
                    //         titles[index],
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  var isloading = false;
  void showDateFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "Select Date",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _datePicker(true, sheetState);
                        },
                        child: Text(
                          "Choose a starting date",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      Text(
                        startDate == null
                            ? ""
                            : DateFormat("d MMM yyyy").format(
                                DateFormat('yyyy-MM-dd').parse(startDate!)),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _datePicker(false, sheetState);
                        },
                        child: Text(
                          "Choose an ending time",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      Text(
                        endDate == null
                            ? ""
                            : DateFormat("d MMM yyyy").format(
                                DateFormat('yyyy-MM-dd').parse(endDate!)),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                isloading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: startDate == null || endDate == null
                            ? () {
                                Fluttertoast.showToast(
                                    msg: "Please select a date range");
                                return;
                              }
                            : () {
                                log("start date $startDate & end date $endDate");
                                fetchWorkoutAnalysis(true);
                                Navigator.pop(context);
                              },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFff7f3f),
                          ),
                        ),
                        child: const Text("Submit"),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  String? startDate;
  String? endDate;

  void _datePicker(bool isStartDate, Function(void Function()) state) {
    var minDate = DateTime.now().subtract(const Duration(days: 31));
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? datePickerDarkTheme
              : datePickerLightTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: minDate,
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      state(() {
        isStartDate
            ? startDate = DateFormat('yyyy-MM-dd').format(value)
            : endDate = DateFormat('yyyy-MM-dd').format(value);
      });
    });
  }

  Widget workoutCards(String count, String title) {
    return Card(
      child: InkWell(
        onTap: title == titles[0]
            ? () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WorkoutLogsScreen();
                }));
              }
            : null,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(count),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendarButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              showDateFilter();
            },
            icon: const Icon(
              Icons.event,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
