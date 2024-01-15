import 'dart:convert';

LabStatusModel labStatusModelFromJson(String str) =>
    LabStatusModel.fromJson(json.decode(str));
String labStatusModelToJson(LabStatusModel data) => json.encode(data.toJson());

class LabStatusModel {
  LabStatusModel({
    int? status,
    List<Data>? data,
    String? message,
    Error? error,
    int? dataCount,
  }) {
    _status = status;
    _data = data;
    _message = message;
    _error = error;
    _dataCount = dataCount;
  }

  LabStatusModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _message = json['message'];
    _error = json['error'] != null ? Error.fromJson(json['error']) : null;
    _dataCount = json['dataCount'];
  }
  int? _status;
  List<Data>? _data;
  String? _message;
  Error? _error;
  int? _dataCount;
  LabStatusModel copyWith({
    int? status,
    List<Data>? data,
    String? message,
    Error? error,
    int? dataCount,
  }) =>
      LabStatusModel(
        status: status ?? _status,
        data: data ?? _data,
        message: message ?? _message,
        error: error ?? _error,
        dataCount: dataCount ?? _dataCount,
      );
  int? get status => _status;
  List<Data>? get data => _data;
  String? get message => _message;
  Error? get error => _error;
  int? get dataCount => _dataCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    if (_error != null) {
      map['error'] = _error?.toJson();
    }
    map['dataCount'] = _dataCount;
    return map;
  }
}

/// data : "{}"

Error errorFromJson(String str) => Error.fromJson(json.decode(str));
String errorToJson(Error data) => json.encode(data.toJson());

class Error {
  Error({
    String? data,
  }) {
    _data = data;
  }

  Error.fromJson(dynamic json) {
    _data = json['data'];
  }
  String? _data;
  Error copyWith({
    String? data,
  }) =>
      Error(
        data: data ?? _data,
      );
  String? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = _data;
    return map;
  }
}

/// _id : "6472fea32c6184fc4830a820"
/// date : "2023-05-29T00:00:00.000Z"
/// labId : {"_id":"6357be467efd830dee9769a6","vendorId":{"_id":"6353d545ef53461bc86d71a5","email":"prasadcp563@gmail.com","mobileNo":"9504691111","firstName":"Teja","lastName":"LabVendor"},"address":"Sri Shanthi Towers, #141, 3rd Floor, 3rd Main Rd, East of NGEF Layout, Kasturi Nagar, Bengaluru, Karnataka 560043"}
/// testType : "center"
/// time : "12:41"
/// userId : {"_id":"627dffae862ba3a172f62929","email":"absahoo1993@gmail.com","firstName":"Abhipsa","lastName":"Sahoo","imageUrl":"https://healthonify-bk.s3.ap-south-1.amazonaws.com/healthonify/1668759885379-plant.png"}
/// __v : 0
/// address : {"doorNoAndStreetName":"Vhcv","city":"Fg","state":"Gg","pincode":"Gjdg"}
/// age : 25
/// created_at : "2023-05-28T07:11:31.252Z"
/// gender : "Female"
/// labTestCategoryId : [{"_id":"63578037e5a8e19d1cf98f4c","name":"Covid 19 IgG Antibody Test"}]
/// location : {"type":"Point","coordinates":[13.00345,77.662795]}
/// mobileNo : "6363114836"
/// status : "awaitingPayment"
/// testFor : "self"
/// updated_at : "2023-05-28T07:11:32.737Z"
/// paymentId : "6472fea42c6184fc4830a9ec"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    String? id,
    String? date,
    LabId? labId,
    String? testType,
    String? time,
    UserId? userId,
    int? v,
    Address? address,
    int? age,
    String? createdAt,
    String? gender,
    List<LabTestCategoryId>? labTestCategoryId,
    Location? location,
    String? mobileNo,
    String? status,
    String? testFor,
    String? updatedAt,
    String? paymentId,
  }) {
    _id = id;
    _date = date;
    _labId = labId;
    _testType = testType;
    _time = time;
    _userId = userId;
    _v = v;
    _address = address;
    _age = age;
    _createdAt = createdAt;
    _gender = gender;
    _labTestCategoryId = labTestCategoryId;
    _location = location;
    _mobileNo = mobileNo;
    _status = status;
    _testFor = testFor;
    _updatedAt = updatedAt;
    _paymentId = paymentId;
  }

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _date = json['date'];
    _labId = json['labId'] != null ? LabId.fromJson(json['labId']) : null;
    _testType = json['testType'];
    _time = json['time'];
    _userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    _v = json['__v'];
    _address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    _age = json['age'];
    _createdAt = json['created_at'];
    _gender = json['gender'];
    if (json['labTestCategoryId'] != null) {
      _labTestCategoryId = [];
      json['labTestCategoryId'].forEach((v) {
        _labTestCategoryId?.add(LabTestCategoryId.fromJson(v));
      });
    }
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _mobileNo = json['mobileNo'];
    _status = json['status'];
    _testFor = json['testFor'];
    _updatedAt = json['updated_at'];
    _paymentId = json['paymentId'];
  }
  String? _id;
  String? _date;
  LabId? _labId;
  String? _testType;
  String? _time;
  UserId? _userId;
  int? _v;
  Address? _address;
  int? _age;
  String? _createdAt;
  String? _gender;
  List<LabTestCategoryId>? _labTestCategoryId;
  Location? _location;
  String? _mobileNo;
  String? _status;
  String? _testFor;
  String? _updatedAt;
  String? _paymentId;
  Data copyWith({
    String? id,
    String? date,
    LabId? labId,
    String? testType,
    String? time,
    UserId? userId,
    int? v,
    Address? address,
    int? age,
    String? createdAt,
    String? gender,
    List<LabTestCategoryId>? labTestCategoryId,
    Location? location,
    String? mobileNo,
    String? status,
    String? testFor,
    String? updatedAt,
    String? paymentId,
  }) =>
      Data(
        id: id ?? _id,
        date: date ?? _date,
        labId: labId ?? _labId,
        testType: testType ?? _testType,
        time: time ?? _time,
        userId: userId ?? _userId,
        v: v ?? _v,
        address: address ?? _address,
        age: age ?? _age,
        createdAt: createdAt ?? _createdAt,
        gender: gender ?? _gender,
        labTestCategoryId: labTestCategoryId ?? _labTestCategoryId,
        location: location ?? _location,
        mobileNo: mobileNo ?? _mobileNo,
        status: status ?? _status,
        testFor: testFor ?? _testFor,
        updatedAt: updatedAt ?? _updatedAt,
        paymentId: paymentId ?? _paymentId,
      );
  String? get id => _id;
  String? get date => _date;
  LabId? get labId => _labId;
  String? get testType => _testType;
  String? get time => _time;
  UserId? get userId => _userId;
  int? get v => _v;
  Address? get address => _address;
  int? get age => _age;
  String? get createdAt => _createdAt;
  String? get gender => _gender;
  List<LabTestCategoryId>? get labTestCategoryId => _labTestCategoryId;
  Location? get location => _location;
  String? get mobileNo => _mobileNo;
  String? get status => _status;
  String? get testFor => _testFor;
  String? get updatedAt => _updatedAt;
  String? get paymentId => _paymentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['date'] = _date;
    if (_labId != null) {
      map['labId'] = _labId?.toJson();
    }
    map['testType'] = _testType;
    map['time'] = _time;
    if (_userId != null) {
      map['userId'] = _userId?.toJson();
    }
    map['__v'] = _v;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    map['age'] = _age;
    map['created_at'] = _createdAt;
    map['gender'] = _gender;
    if (_labTestCategoryId != null) {
      map['labTestCategoryId'] =
          _labTestCategoryId?.map((v) => v.toJson()).toList();
    }
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    map['mobileNo'] = _mobileNo;
    map['status'] = _status;
    map['testFor'] = _testFor;
    map['updated_at'] = _updatedAt;
    map['paymentId'] = _paymentId;
    return map;
  }
}

/// type : "Point"
/// coordinates : [13.00345,77.662795]

Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    String? type,
    List<double>? coordinates,
  }) {
    _type = type;
    _coordinates = coordinates;
  }

  Location.fromJson(dynamic json) {
    _type = json['type'];
    _coordinates =
        json['coordinates'] != null ? json['coordinates'].cast<double>() : [];
  }
  String? _type;
  List<double>? _coordinates;
  Location copyWith({
    String? type,
    List<double>? coordinates,
  }) =>
      Location(
        type: type ?? _type,
        coordinates: coordinates ?? _coordinates,
      );
  String? get type => _type;
  List<double>? get coordinates => _coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['coordinates'] = _coordinates;
    return map;
  }
}

/// _id : "63578037e5a8e19d1cf98f4c"
/// name : "Covid 19 IgG Antibody Test"

LabTestCategoryId labTestCategoryIdFromJson(String str) =>
    LabTestCategoryId.fromJson(json.decode(str));
String labTestCategoryIdToJson(LabTestCategoryId data) =>
    json.encode(data.toJson());

class LabTestCategoryId {
  LabTestCategoryId({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  LabTestCategoryId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
  LabTestCategoryId copyWith({
    String? id,
    String? name,
  }) =>
      LabTestCategoryId(
        id: id ?? _id,
        name: name ?? _name,
      );
  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// doorNoAndStreetName : "Vhcv"
/// city : "Fg"
/// state : "Gg"
/// pincode : "Gjdg"

Address addressFromJson(String str) => Address.fromJson(json.decode(str));
String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    String? doorNoAndStreetName,
    String? city,
    String? state,
    String? pincode,
  }) {
    _doorNoAndStreetName = doorNoAndStreetName;
    _city = city;
    _state = state;
    _pincode = pincode;
  }

  Address.fromJson(dynamic json) {
    _doorNoAndStreetName = json['doorNoAndStreetName'];
    _city = json['city'];
    _state = json['state'];
    _pincode = json['pincode'];
  }
  String? _doorNoAndStreetName;
  String? _city;
  String? _state;
  String? _pincode;
  Address copyWith({
    String? doorNoAndStreetName,
    String? city,
    String? state,
    String? pincode,
  }) =>
      Address(
        doorNoAndStreetName: doorNoAndStreetName ?? _doorNoAndStreetName,
        city: city ?? _city,
        state: state ?? _state,
        pincode: pincode ?? _pincode,
      );
  String? get doorNoAndStreetName => _doorNoAndStreetName;
  String? get city => _city;
  String? get state => _state;
  String? get pincode => _pincode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['doorNoAndStreetName'] = _doorNoAndStreetName;
    map['city'] = _city;
    map['state'] = _state;
    map['pincode'] = _pincode;
    return map;
  }
}

/// _id : "627dffae862ba3a172f62929"
/// email : "absahoo1993@gmail.com"
/// firstName : "Abhipsa"
/// lastName : "Sahoo"
/// imageUrl : "https://healthonify-bk.s3.ap-south-1.amazonaws.com/healthonify/1668759885379-plant.png"

UserId userIdFromJson(String str) => UserId.fromJson(json.decode(str));
String userIdToJson(UserId data) => json.encode(data.toJson());

class UserId {
  UserId({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? imageUrl,
  }) {
    _id = id;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _imageUrl = imageUrl;
  }

  UserId.fromJson(dynamic json) {
    _id = json['_id'];
    _email = json['email'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _imageUrl = json['imageUrl'];
  }
  String? _id;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _imageUrl;
  UserId copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? imageUrl,
  }) =>
      UserId(
        id: id ?? _id,
        email: email ?? _email,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        imageUrl: imageUrl ?? _imageUrl,
      );
  String? get id => _id;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['email'] = _email;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['imageUrl'] = _imageUrl;
    return map;
  }
}

/// _id : "6357be467efd830dee9769a6"
/// vendorId : {"_id":"6353d545ef53461bc86d71a5","email":"prasadcp563@gmail.com","mobileNo":"9504691111","firstName":"Teja","lastName":"LabVendor"}
/// address : "Sri Shanthi Towers, #141, 3rd Floor, 3rd Main Rd, East of NGEF Layout, Kasturi Nagar, Bengaluru, Karnataka 560043"

LabId labIdFromJson(String str) => LabId.fromJson(json.decode(str));
String labIdToJson(LabId data) => json.encode(data.toJson());

class LabId {
  LabId({
    String? id,
    VendorId? vendorId,
    String? address,
  }) {
    _id = id;
    _vendorId = vendorId;
    _address = address;
  }

  LabId.fromJson(dynamic json) {
    _id = json['_id'];
    _vendorId =
        json['vendorId'] != null ? VendorId.fromJson(json['vendorId']) : null;
    _address = json['address'];
  }
  String? _id;
  VendorId? _vendorId;
  String? _address;
  LabId copyWith({
    String? id,
    VendorId? vendorId,
    String? address,
  }) =>
      LabId(
        id: id ?? _id,
        vendorId: vendorId ?? _vendorId,
        address: address ?? _address,
      );
  String? get id => _id;
  VendorId? get vendorId => _vendorId;
  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_vendorId != null) {
      map['vendorId'] = _vendorId?.toJson();
    }
    map['address'] = _address;
    return map;
  }
}

/// _id : "6353d545ef53461bc86d71a5"
/// email : "prasadcp563@gmail.com"
/// mobileNo : "9504691111"
/// firstName : "Teja"
/// lastName : "LabVendor"

VendorId vendorIdFromJson(String str) => VendorId.fromJson(json.decode(str));
String vendorIdToJson(VendorId data) => json.encode(data.toJson());

class VendorId {
  VendorId({
    String? id,
    String? email,
    String? mobileNo,
    String? firstName,
    String? lastName,
  }) {
    _id = id;
    _email = email;
    _mobileNo = mobileNo;
    _firstName = firstName;
    _lastName = lastName;
  }

  VendorId.fromJson(dynamic json) {
    _id = json['_id'];
    _email = json['email'];
    _mobileNo = json['mobileNo'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
  }
  String? _id;
  String? _email;
  String? _mobileNo;
  String? _firstName;
  String? _lastName;
  VendorId copyWith({
    String? id,
    String? email,
    String? mobileNo,
    String? firstName,
    String? lastName,
  }) =>
      VendorId(
        id: id ?? _id,
        email: email ?? _email,
        mobileNo: mobileNo ?? _mobileNo,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
      );
  String? get id => _id;
  String? get email => _email;
  String? get mobileNo => _mobileNo;
  String? get firstName => _firstName;
  String? get lastName => _lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['email'] = _email;
    map['mobileNo'] = _mobileNo;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    return map;
  }
}
