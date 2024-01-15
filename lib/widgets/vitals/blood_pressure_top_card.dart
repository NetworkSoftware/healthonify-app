import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/vitals/vitals_list.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';

class BloodPressureTopCard extends StatefulWidget {
  final BloodPressure data;
  const BloodPressureTopCard({Key? key, required this.data}) : super(key: key);

  @override
  State<BloodPressureTopCard> createState() => _BloodPressureTopCardState();
}

class _BloodPressureTopCardState extends State<BloodPressureTopCard> {
  int filterIndex = 0;

  String? systolic, diastolic, pulse = "";

  void setData(BloodPressure data) {
    log('blood pressure latest data -> ${data.latestData}');
    log('blood pressure maximum data -> ${data.maximumData}');
    log('blood pressure minimum data -> ${data.minimumData}');
    log('blood pressure average data -> ${data.averageData}');

    if (filterIndex == 0) {
      if (data.latestData != null) {
        systolic = data.latestData!["systolic"];
        diastolic = data.latestData!["diastolic"];
        pulse = data.latestData!["pulse"];
      } else {
        systolic = '0';
        diastolic = '0';
        pulse = '0';
      }
    } else if (filterIndex == 1) {
      if (data.maximumData != null) {
        systolic = data.maximumData!["maximumSystolic"];
        diastolic = data.maximumData!["maximumDiastolic"];
        pulse = data.maximumData!["maximumPulse"];
      } else {
        systolic = '0';
        diastolic = '0';
        pulse = '0';
      }
    } else if (filterIndex == 2) {
      if (data.minimumData != null) {
        systolic = data.minimumData!["minimumSystolic"];
        diastolic = data.minimumData!["minimumDiastolic"];
        pulse = data.minimumData!["minimumPulse"];
      } else {
        systolic = '0';
        diastolic = '0';
        pulse = '0';
      }
    } else if (filterIndex == 3) {
      if (data.averageData != null) {
        systolic = data.averageData!["systolicAverage"];
        diastolic = data.averageData!["diastolicAverage"];
        pulse = data.averageData!["pulseAverage"];
      } else {
        systolic = '0';
        diastolic = '0';
        pulse = '0';
      }
    } else {
      systolic = "0";
      diastolic = "0";
      pulse = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    setData(widget.data);
    return Column(
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (filterIndex == filters.length - 1) {
                    filterIndex = 0;
                  } else {
                    filterIndex++;
                  }
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 5,
                  ),
                  const SizedBox(width: 8),
                  Text(filters[filterIndex]),
                  const SizedBox(width: 8),
                  const Icon(Icons.unfold_more, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
        ),
        bpReading(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget bpReading(context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Systolic',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: orange,
                        ),
                  ),
                  Text(
                    '$systolic mmHg',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: orange,
                        ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Diastolic',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: const Color.fromARGB(255, 41, 132, 44),
                        ),
                  ),
                  Text(
                    '$diastolic mmHg',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color.fromARGB(255, 41, 132, 44),
                        ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Pulse',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.blue[300],
                        ),
                  ),
                  Text(
                    '$pulse bpm',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.blue[300],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
