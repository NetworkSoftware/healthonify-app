class BloodPressure {
  Map<String, dynamic>? latestData, averageData, minimumData, maximumData;
  List<BpRecentLogs>? recentLogs;
}

class BpRecentLogs {
  String? id, date, userId, systolic, diastolic, pulse, time;
  BpRecentLogs({
    this.id,
    this.date,
    this.userId,
    this.systolic,
    this.diastolic,
    this.pulse,
    this.time,
  });
}

class HbA1c {
  Map<String, dynamic>? averageData;
  List<Hba1CRecentLogs>? recentLogs;
}

class Hba1CRecentLogs {
  String? id, date, userId, hba1cLevel, time;
  Hba1CRecentLogs({
    this.id,
    this.date,
    this.userId,
    this.hba1cLevel,
    this.time,
  });
}

class BloodGlucose {
  Map<String, dynamic>? averageData;
  List<BloodGlucoseRecentLogs>? recentLogs;
}

class BloodGlucoseRecentLogs {
  String? id, date, userId, bloodGlucoseLevel, testType, time,mealType;
  BloodGlucoseRecentLogs({
    this.id,
    this.date,
    this.userId,
    this.bloodGlucoseLevel,
    this.testType,
    this.time,
    this.mealType,
  });
}
