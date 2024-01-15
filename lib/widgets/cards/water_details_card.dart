// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/trackers/watertracker_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/trackers/water_intake.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class WaterCardDetails extends StatelessWidget {
  final String? waterGlass, goalCount;
  bool flag;
  WaterCardDetails({
    Key? key,
    required this.waterGlass,
    required this.goalCount,
    this.flag = false,
  }) : super(key: key);

  Future<void> callApi(BuildContext context) async {
    flag = true;
    WaterTracker().getWaterData(context);
  }

  Future<void> empty() async {}

  void getWaterGlassCount(String glass) {
    log("water glass $glass");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterIntakeProvider>(
      builder: (context, value, child) {
        String wg, gc;
        wg = waterGlass!;
        gc = goalCount!;
        return WaterDetailsCard(
          waterGlass: int.parse(wg),
          returnWaterGlass: getWaterGlassCount,
          goalCount: int.parse(gc),
        );
      },
    );
  }
}

class WaterDetailsCard extends StatefulWidget {
  int? waterGlass, goalCount;
  final Function returnWaterGlass;
  WaterDetailsCard(
      {Key? key,
      required this.waterGlass,
      required this.goalCount,
      required this.returnWaterGlass})
      : super(key: key);

  @override
  State<WaterDetailsCard> createState() => _WaterDetailsCardState();
}

class _WaterDetailsCardState extends State<WaterDetailsCard> {
  Map<String, dynamic> waterData = {
    'userId': '',
    'waterGlassCount': '',
    'date': DateFormat('yyyy/MM/dd').format(DateTime.now()),
  };
  bool isCalled = false;
  Future<void> onSuccessfulUpdate(VoidCallback callback) async {
    callback.call();
  }

  Future<void> updateWaterData() async {
    try {
      WaterIntakeProvider().postWaterIntake(waterData);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error post water data widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    }
  }

  void updateGlass() async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    waterData['userId'] = userId!;
    waterData['waterGlassCount'] = widget.waterGlass;

    onSuccessfulUpdate(() =>
        Provider.of<AllTrackersData>(context, listen: false)
            .localUpdateWaterCount(widget.waterGlass!));
    widget.returnWaterGlass(widget.waterGlass.toString());

    if (!isCalled) {
      log("called api");
      Future.delayed(
        const Duration(
          seconds: 2,
        ),
        () {
          isCalled = false;
          updateWaterData();
        },
      );
      isCalled = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      elevation: 2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 70,
                      animation: true,
                      animateFromLastPercent: true,
                      // animationDuration: 2000,
                      progressColor: const Color(0xFFA2D3F4),
                      backgroundColor: Colors.grey[200]!,
                      center: const Icon(
                        Icons.water_drop_outlined,
                        color: Color(0xFFA2D3F4),
                        size: 42,
                      ),
                      lineWidth: 24,
                      percent: widget.waterGlass! >= widget.goalCount!
                          ? 1
                          : widget.waterGlass! / widget.goalCount!,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.waterGlass = widget.waterGlass! + 1;
                        });
                        updateGlass();
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFFA2D3F4),
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget.waterGlass != 0) {
                          setState(() {
                            widget.waterGlass = widget.waterGlass! - 1;
                          });
                        } else {
                          widget.waterGlass = 0;
                        }

                        updateGlass();
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Color(0xFFA2D3F4),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.waterGlass!.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Out of\n${widget.goalCount} glasses',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
