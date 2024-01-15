import 'dart:developer';

import 'package:intl/intl.dart';

class StringDateTimeFormat {
  String stringToTimeOfDay(String tod) {
    if (tod.isEmpty) {
      return "";
    }
    //final timeFormat = DateFormat("HH:mm:ss").parse(tod);
    final timeFormat = DateFormat("HH:mm").parse(tod);
    String finalFormattedDate = DateFormat('h:mm a').format(timeFormat);
    return finalFormattedDate;
  }

  bool checkForVideoCallValidation(String tod, String date) {
    Duration hrsDiff;

    print("Date : $date");
    // final timeFormat = DateFormat("HH:mm:ss").parse(tod);
    // final dateFormat = DateFormat("MM/dd/yyyy").parse(date);

    final timeFormat = DateFormat("HH:mm").parse(tod);
    //final dateFormat = DateFormat("dd-MM-yyyy").parse(date);
    final dateFormat = DateFormat("dd/MM/yyyy").parse(date);

    final assignedDate = DateTime(dateFormat.year, dateFormat.month,
        dateFormat.day, timeFormat.hour, timeFormat.minute);

    var todayDate = DateTime.now();

    log("today $todayDate");
    log("assigned $assignedDate");

    if (assignedDate.isAfter(todayDate) ||
        assignedDate.isAtSameMomentAs(todayDate)) {
      log("Meeting is yet to begun");
      hrsDiff = assignedDate.difference(todayDate);
      log("diff in date = $hrsDiff");
      String hrDiffr = hrsDiff.toString().split(':00.')[0];
      int hours = int.parse(hrDiffr.toString().split(':')[0]);
      int minutes = int.parse(hrDiffr.toString().split(':')[1]);

      int totalMins = hours * 60 + minutes;
      log("mins left $totalMins");
      if (totalMins <= 15) {
        return true;
      }
    }
    if (todayDate.isAfter(assignedDate)) {
      hrsDiff = todayDate.difference(assignedDate);
      // log("diff in date = $hrsDiff");
      String hrDiffr = hrsDiff.toString().split(':00.')[0];
      int hours = int.parse(hrDiffr.toString().split(':')[0]);
      int minutes = int.parse(hrDiffr.toString().split(':')[1]);
      int totalMins = hours * 60 + minutes;
      log("mins left $totalMins");
      if (totalMins <= 60) {
        return true;
      }
    }
    return false;
  }

  bool checkForVideoCallSessionValidation(String tod, String date) {
    Duration hrsDiff;

    // final timeFormat = DateFormat("HH:mm:ss").parse(tod);
    // final dateFormat = DateFormat("MM/dd/yyyy").parse(date);

    final timeFormat = DateFormat("HH:mm").parse(tod);
    //final dateFormat = DateFormat("dd-MM-yyyy").parse(date);
    final dateFormat = DateFormat("MM/dd/yyyy").parse(date);

    final assignedDate = DateTime(dateFormat.year, dateFormat.month,
        dateFormat.day, timeFormat.hour, timeFormat.minute);

    var todayDate = DateTime.now();

    log("today $todayDate");
    log("assigned $assignedDate");

    if (assignedDate.isAfter(todayDate) ||
        assignedDate.isAtSameMomentAs(todayDate)) {
      log("Meeting is yet to begun");
      hrsDiff = assignedDate.difference(todayDate);
      log("diff in date = $hrsDiff");
      String hrDiffr = hrsDiff.toString().split(':00.')[0];
      int hours = int.parse(hrDiffr.toString().split(':')[0]);
      int minutes = int.parse(hrDiffr.toString().split(':')[1]);

      int totalMins = hours * 60 + minutes;
      log("mins left $totalMins");
      if (totalMins <= 15) {
        return true;
      }
    }
    if (todayDate.isAfter(assignedDate)) {
      hrsDiff = todayDate.difference(assignedDate);
      // log("diff in date = $hrsDiff");
      String hrDiffr = hrsDiff.toString().split(':00.')[0];
      int hours = int.parse(hrDiffr.toString().split(':')[0]);
      int minutes = int.parse(hrDiffr.toString().split(':')[1]);
      int totalMins = hours * 60 + minutes;
      log("mins left $totalMins");
      if (totalMins <= 60) {
        return true;
      }
    }
    return false;
  }

  String stringtDateFormat(String d) {
    final dateFormat = DateFormat("yyyy/MM/dd");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("EEE, MMM d ''yy").format(date);
    return formattedDate;
  }

  String stringAssignFormat(String d) {
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("dd/MM/yyyy").format(date);
    return formattedDate;
  }

  String stringAssignTimeFormat(String d) {
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("HH:mm a").format(date);
    return formattedDate;
  }

  String stringDateBloodGlucoseFormat(String d) {
    final dateFormat = DateFormat("MM/dd/yyyy");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("dd-MMM-yyyy").format(date);
    return formattedDate;
  }

  String stringDateFormatApp(String d) {
    final dateFormat = DateFormat("dd/MM/yyyy");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("EEE, MMM d ''yy").format(date);
    return formattedDate;
  }

  String stringtDateFormatLogWeight(String d) {

    final dateFormat = DateFormat("MM/dd/yyyy");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("EEE, MMM d ''yy").format(date);
    return formattedDate;
  }

  String stringtDateFormatHeartRate(String d) {
    final dateFormat = DateFormat("yyyy-MM-dd");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("EEE, MMM d ''yy").format(date);
    return formattedDate;
  }

  String stringtDateFormat2(String d) {
    final dateFormat = DateFormat("yyyy/MM/dd");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("MM/dd/yyyy").format(date);
    return formattedDate;
  }

  String stringtDateFormat3(String d) {
    final dateFormat = DateFormat("MM-dd-yyyy");
    final date = dateFormat.parse(d);
    final formattedDate = DateFormat("EEE, MMM d ''yy").format(date);
    return formattedDate;
  }

  String _subtractTimes(String userWake, String userSleep) {
    try {
      Duration hrsDiff;
      String hours, minutes, hrsSlept;
      DateTime wakeTime = DateFormat("Hms").parse(userWake);
      DateTime sleepTimeUser = DateFormat("Hms").parse(userSleep);
      // log(wakeTime.toString());
      // log(sleepTimeUser.toString());
      wakeTime = wakeTime.add(const Duration(days: 1));

      if (wakeTime.isAfter(sleepTimeUser)) {
        hrsDiff = wakeTime.difference(sleepTimeUser);

        String hrDiffr = hrsDiff.toString().split(':00.')[0];
        hours = hrDiffr.toString().split(':')[0];
        minutes = hrDiffr.toString().split(':')[1];
        // log(hrDiffr.toString().split(':')[0]);
        // log(hrDiffr.toString().split(':')[1]);
        if (minutes == "00") {
          hrsSlept = "$hours hrs";
        } else if (hours == "00") {
          hrsSlept = "$hours hrs $minutes mins";
        } else {
          hrsSlept = "$hours hrs $minutes mins";
        }
        // log(hrsSlept);
      } else {
        hrsDiff = const Duration(days: 0);
        // log('did not enter if loop');
        hrsSlept = '0';
      }
      return hrsSlept;
    } catch (e) {
      // log("Error subtracting time " + e.toString());
      return "0";
    }
  }

  String subtractTime(String startTime, String endTime) {
    // log("mess $startTime $endTime");
    String convert;
    // log("Sleep " + sleepTime); log("wake" + wakeupTime);
    if (endTime.isEmpty || startTime.isEmpty) {
      convert = "";
    } else {
      convert = _subtractTimes(endTime, startTime);
    }
    // log("converted time " + convert);
    return convert;
  }

  int convertHoursToMins(String value) {
    List data = value.split(' hrs');

    String hours = data[0];
    String minsValue = data[1];
    String mins = "0";
    if (minsValue.isNotEmpty) {
      mins = minsValue.split(' mins')[0].trim();
    }
    // if (minsValue.isNotEmpty) {
    //   String mins = value.split(' mins')[0];
    // }
    // log("convert " + data.toString());
    // log("convert " + data.length.toString());
    // log("convert " + hours);
    // log("convert " + mins);

    int totalMinutes = int.parse(hours) * 60 + int.parse(mins);
    log("convert total $totalMinutes");

    return totalMinutes;
  }

  int subtractTimesToSeconds(String userWake, String userSleep) {
    try {
      Duration hrsDiff;
      String hours, minutes;
      DateTime wakeTime = DateFormat("Hms").parse(userWake);
      DateTime sleepTimeUser = DateFormat("Hms").parse(userSleep);
      // log(wakeTime.toString());
      // log(sleepTimeUser.toString());
      wakeTime = wakeTime.add(const Duration(days: 1));

      if (wakeTime.isAfter(sleepTimeUser)) {
        hrsDiff = wakeTime.difference(sleepTimeUser);

        String hrDiffr = hrsDiff.toString().split(':00.')[0];
        hours = hrDiffr.toString().split(':')[0];
        minutes = hrDiffr.toString().split(':')[1];

        int h = int.parse(hours);
        int m = int.parse(minutes);

        double seconds = h * 3600 + m * 60;
        // log(seconds.toString());
        return seconds.round();
      }

      return 0;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  String convertTimeStampToTime(int timestamp) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String time = DateFormat.jm().format(dt);
    return time;
  }
}
