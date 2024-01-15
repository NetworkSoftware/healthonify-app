class HcRevenue {
  int? status;
  RevenueListData? data;
  String? message;
  Error? error;
  int? dataCount;

  HcRevenue({this.status, this.data, this.message, this.error, this.dataCount});

  HcRevenue.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? RevenueListData.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    dataCount = json['dataCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    data['dataCount'] = dataCount;
    return data;
  }
}

class RevenueListData {
  List<RevenuesData>? revenuesData;
  String? totalPayout;

  RevenueListData({this.revenuesData, this.totalPayout});

  RevenueListData.fromJson(Map<String, dynamic> json) {
    if (json['revenuesData'] != null) {
      revenuesData = <RevenuesData>[];
      json['revenuesData'].forEach((v) {
        revenuesData!.add(RevenuesData.fromJson(v));
      });
    }
    totalPayout = json['totalPayout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (revenuesData != null) {
      data['revenuesData'] = revenuesData!.map((v) => v.toJson()).toList();
    }
    data['totalPayout'] = totalPayout;
    return data;
  }
}

class RevenuesData {
  String? sId;
  HcConsultationId? hcConsultationId;
  UserId? specialExpertId;
  int? iV;
  String? commission;
  String? createdAt;
  String? payout;
  int? serviceTax;
  String? sessionCost;
  String? updatedAt;
  String? id;

  RevenuesData(
      {this.sId,
      this.hcConsultationId,
      this.specialExpertId,
      this.iV,
      this.commission,
      this.createdAt,
      this.payout,
      this.serviceTax,
      this.sessionCost,
      this.updatedAt,
      this.id});

  RevenuesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    hcConsultationId = json['hcConsultationId'] != null
        ? HcConsultationId.fromJson(json['hcConsultationId'])
        : null;
    specialExpertId = json['specialExpertId'] != null
        ? UserId.fromJson(json['specialExpertId'])
        : null;
    iV = json['__v'];
    commission = json['commission'];
    createdAt = json['created_at'];
    payout = json['payout'];
    serviceTax = json['serviceTax'];
    sessionCost = json['sessionCost'];
    updatedAt = json['updated_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (hcConsultationId != null) {
      data['hcConsultationId'] = hcConsultationId!.toJson();
    }
    if (specialExpertId != null) {
      data['specialExpertId'] = specialExpertId!.toJson();
    }
    data['__v'] = iV;
    data['commission'] = commission;
    data['created_at'] = createdAt;
    data['payout'] = payout;
    data['serviceTax'] = serviceTax;
    data['sessionCost'] = sessionCost;
    data['updated_at'] = updatedAt;
    data['id'] = id;
    return data;
  }
}

class HcConsultationId {
  List<UserId>? userId;
  String? sId;
  String? startDate;
  String? startTime;

  HcConsultationId({this.userId, this.sId, this.startDate, this.startTime});

  HcConsultationId.fromJson(Map<String, dynamic> json) {
    if (json['userId'] != null) {
      userId = <UserId>[];
      json['userId'].forEach((v) {
        userId!.add(UserId.fromJson(v));
      });
    }
    sId = json['_id'];
    startDate = json['startDate'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data['userId'] = userId!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['startDate'] = startDate;
    data['startTime'] = startTime;
    return data;
  }
}

class UserId {
  String? sId;
  String? mobileNo;
  String? email;
  String? firstName;
  String? lastName;
  String? imageUrl;

  UserId(
      {this.sId,
      this.mobileNo,
      this.email,
      this.firstName,
      this.lastName,
      this.imageUrl});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class Error {
  String? data;

  Error({this.data});

  Error.fromJson(Map<String, dynamic> json) {
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    return data;
  }
}
