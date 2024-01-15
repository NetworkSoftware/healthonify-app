import 'dart:convert';
import 'dart:developer';


/// status : 1
/// data : [{"location":{"coordinates":[]},"expertise":[],"_id":"628e07c3295cbb2a64996d2d","mobileNo":"8332946991","email":"svssteja1997@gmail.com","firstName":"Teja","lastName":"Segu","address":"vinayaka street,Al Puram","city":"Visakhapatnam","country":"India","pincode":"531084","state":"Andra Pradesh","imageUrl":"https://i.pinimg.com/originals/f9/75/81/f9758151b717582c500f0dcc33beca4f.png"}]
/// message : "User data fetched successfully"
/// error : {"data":"{}"}
/// dataCount : 1

GetTherapyList getTherapyListFromJson(String str) =>
    GetTherapyList.fromJson(json.decode(str));
String getTherapyListToJson(GetTherapyList data) => json.encode(data.toJson());

class GetTherapyList {
  GetTherapyList({
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

  GetTherapyList.fromJson(dynamic json) {
    _status = json['status'];
    try {
      if (json['data'] != null) {
        _data = [];
        for (var element in json[data]) {
          _data!.add(Data.fromJson(element));
        }
      }
      _message = json['message'];
      _error = json['error'] != null ? Error.fromJson(json['error']) : null;
      _dataCount = json['dataCount'];
    } catch (e) {
      log("this is the probelm inside model class$e");
    }
  }
  int? _status;
  List<Data>? _data;
  String? _message;
  Error? _error;
  int? _dataCount;
  GetTherapyList copyWith({
    int? status,
    List<Data>? data,
    String? message,
    Error? error,
    int? dataCount,
  }) =>
      GetTherapyList(
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

/// location : {"coordinates":[]}
/// expertise : []
/// _id : "628e07c3295cbb2a64996d2d"
/// mobileNo : "8332946991"
/// email : "svssteja1997@gmail.com"
/// firstName : "Teja"
/// lastName : "Segu"
/// address : "vinayaka street,Al Puram"
/// city : "Visakhapatnam"
/// country : "India"
/// pincode : "531084"
/// state : "Andra Pradesh"
/// imageUrl : "https://i.pinimg.com/originals/f9/75/81/f9758151b717582c500f0dcc33beca4f.png"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    Location? location,
    // List<dynamic>? expertise,
    String? id,
    String? mobileNo,
    String? email,
    String? firstName,
    String? lastName,
    String? address,
    String? city,
    String? country,
    String? pincode,
    String? state,
    String? imageUrl,
  }) {
    this.location;
    // _expertise = expertise;
    this.id;
    this.mobileNo;
    this.email;
    this.firstName;
    this.lastName;
    this.address;
    this.city;
    this.country;
    this.pincode;
    this.state;
    this.imageUrl;
  }

  Data.fromJson(Map<String, dynamic> json) {
    // _location = json['location'] != null ? Location.fromJson(json['location']) : null;
    if (json['expertise'] != null) {
      _expertise = [];
      json['expertise'].forEach((v) {
        // _expertise?.add(Expertise.fromJson(v));
      });
    }
    _id = json['_id'];
    _mobileNo = json['mobileNo'];
    _email = json['email'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _address = json['address'];
    _city = json['city'];
    _country = json['country'];
    _pincode = json['pincode'];
    _state = json['state'];
    _imageUrl = json['imageUrl'];
  }
  Location? _location;
  List<dynamic>? _expertise;
  String? _id;
  String? _mobileNo;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _address;
  String? _city;
  String? _country;
  String? _pincode;
  String? _state;
  String? _imageUrl;
  Data copyWith({
    Location? location,
    List<dynamic>? expertise,
    String? id,
    String? mobileNo,
    String? email,
    String? firstName,
    String? lastName,
    String? address,
    String? city,
    String? country,
    String? pincode,
    String? state,
    String? imageUrl,
  }) =>
      Data(
        location: location ?? _location,
        // expertise: expertise ?? _expertise,
        id: id ?? _id,
        mobileNo: mobileNo ?? _mobileNo,
        email: email ?? _email,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        address: address ?? _address,
        city: city ?? _city,
        country: country ?? _country,
        pincode: pincode ?? _pincode,
        state: state ?? _state,
        imageUrl: imageUrl ?? _imageUrl,
      );
  Location? get location => _location;
  List<dynamic>? get expertise => _expertise;
  String? get id => _id;
  String? get mobileNo => _mobileNo;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get address => _address;
  String? get city => _city;
  String? get country => _country;
  String? get pincode => _pincode;
  String? get state => _state;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    if (_expertise != null) {
      map['expertise'] = _expertise?.map((v) => v.toJson()).toList();
    }
    map['_id'] = _id;
    map['mobileNo'] = _mobileNo;
    map['email'] = _email;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['address'] = _address;
    map['city'] = _city;
    map['country'] = _country;
    map['pincode'] = _pincode;
    map['state'] = _state;
    map['imageUrl'] = _imageUrl;
    return map;
  }
}

/// coordinates : []

// Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    List<dynamic>? coordinates,
  }) {
    _coordinates = coordinates;
  }

  // Location.fromJson(json) {
  //   if (json['coordinates'] != null) {
  //     _coordinates = [];
  //     json['coordinates'].forEach((v) {
  //       _coordinates?.add(Dynamic.fromJson(v));
  //     });
  //   }
  // }
  List<dynamic>? _coordinates;
  Location copyWith({
    List<dynamic>? coordinates,
  }) =>
      Location(
        coordinates: coordinates ?? _coordinates,
      );
  List<dynamic>? get coordinates => _coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_coordinates != null) {
      map['coordinates'] = _coordinates?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
