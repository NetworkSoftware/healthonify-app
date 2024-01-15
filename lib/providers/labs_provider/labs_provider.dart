import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lab_models/family_member_model.dart';
import 'package:healthonify_mobile/models/lab_models/lab_cities.dart';
import 'package:healthonify_mobile/models/lab_models/lab_models.dart';
import 'package:healthonify_mobile/models/lab_models/popular_tests_model.dart';
import 'package:healthonify_mobile/models/payment_models/payment_models.dart';
import 'package:http/http.dart' as http;

import '../../models/health_care/LabStatusModel.dart' as lb;

class LabsProvider with ChangeNotifier {
  Future<List<LabsModel>> getLabsAroundYou(
      double longitude, double latitude) async {
    String url =
        "${ApiUrl.hc}getNearbyLabs?longitude=$longitude&latitude=$latitude";

    log(url);
    List<LabsModel> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 0) {
        throw HttpException(responseData["data"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          loadedData.add(
            LabsModel(
              labTestCategories: List<LabTestModel>.from(
                  ele["labTestCategoryId"]
                      .map((x) => LabTestModel.fromJson(x))),
              address: ele['address'],
              agreement: ele['agreement'],
              coordinates: ele['location']['coordinates'],
              gstPercent: ele['gstPercent'],
              homeServicePercent: ele['homeServicePercent'],
              hplCommission: ele['hplCommission'],
              id: ele['id'],
              platformCostProduct: ele['platformCostProduct'],
              labEmail: ele['labEmail'],
              labMobileNo: ele['labMobileNo'].toString(),
              labName: ele['name'],
              vendorId: ele['vendorId'],
              status: ele['status'],
            ),
          );
        }

        log('fetched labs around you');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<LabsAroundyouModel>> searchLabs(
      String cityId, String cityName) async {
    String url = "${ApiUrl.hc}user/searchLabs?cityId=$cityId&name=$cityName";

    log(url);
    List<LabsAroundyouModel> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 0) {
        throw HttpException(responseData["data"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          loadedData.add(
            LabsAroundyouModel(
              location: Location.fromJson(ele["location"]),
              isApproved: ele["isApproved"],
              labTestCategoryId: List<Id>.from(
                  ele["labTestCategoryId"].map((x) => Id.fromJson(x))),
              serviceType: List<String>.from(ele["serviceType"].map((x) => x)),
              status: ele["status"],
              id: ele["_id"],
              vendorId: ele["vendorId"],
              name: ele["name"],
              labEmail: ele["labEmail"],
              labMobileNo: ele["labMobileNo"],
              address: ele["address"],
              agreement: ele["agreement"],
              createdAt: DateTime.parse(ele["created_at"]),
              updatedAt: DateTime.parse(ele["updated_at"]),
              v: ele["__v"],
              gstPercent: ele["gstPercent"],
              homeServicePercent: ele["homeServicePercent"],
              hplCommission: ele["hplCommission"],
              platformCostPercent: ele["platformCostPercent"],
              cityId: Id.fromJson(ele["cityId"]),
              stateId: Id.fromJson(ele["stateId"]),
              labsAroundyouModelId: ele["id"],
            ),
          );
        }

        log('search city complete');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<PaymentModel> requestLabTest(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}user/createLabTestRequest';

    log(data.toString());

    PaymentModel paymentData = PaymentModel();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      final payData = responseData['data'] as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);

        paymentData.amountDue = payData['paymentData']['amoundDue'];
        paymentData.amountPaid = payData['paymentData']['amountPaid'];
        paymentData.currency = payData['paymentData']['currency'];
        paymentData.discount = payData['paymentData']['discount'];
        paymentData.grossAmount = payData['paymentData']['grossAmount'];
        paymentData.gstAmount = payData['paymentData']['gstAmount'];
        paymentData.id = payData['paymentData']['id'];
        paymentData.invoiceNumber = payData['paymentData']['invoiceNumber'];
        paymentData.labTestId = payData['paymentData']['labTestId'];
        paymentData.netAmount = payData['paymentData']['netAmount'];
        paymentData.razorpayOrderId = payData['paymentData']['rzpOrderId'];
        paymentData.status = payData['paymentData']['status'];
        paymentData.userId = payData['paymentData']['userId'];
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
      return paymentData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FamilyMemberModel>> getFamilyMember(String userId) async {
    String url = "${ApiUrl.hc}user/fetchFamilyMembers?relatesTo=$userId";

    log(url);
    List<FamilyMemberModel> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 0) {
        throw HttpException(responseData["data"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          loadedData.add(
            FamilyMemberModel(
              age: ele['age'],
              dob: ele['dob'],
              email: ele['email'],
              id: ele['_id'],
              mobileNo: ele['mobileNo'],
              relatesTo: FamilyMemberRelatesTo(
                email: ele['relatesTo']['email'],
                firstName: ele['relatesTo']['firstName'],
                id: ele['relatesTo']['_id'],
                lastName: ele['relatesTo']['lastName'],
              ),
              relativeFirstName: ele['firstName'],
              relativeLastName: ele['lastName'],
              gender: ele['gender'],
            ),
          );
        }

        log('fetched family members');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addFamilyMember(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}user/addFamilyMember';
    log(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PopularTestsModel>> getPopularTests() async {
    String url = "${ApiUrl.hc}get/labTestCategory";

    log(url);
    List<PopularTestsModel> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 0) {
        throw HttpException(responseData["data"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          loadedData.add(
            PopularTestsModel(
              id: ele['_id'],
              isActive: ele['isActive'],
              name: ele['name'],
              price: ele['price'],
            ),
          );
        }

        log('fetched popular tests');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<lb.LabStatusModel> getLabAppointmentStatus(String? userId) async {
    String url = "${ApiUrl.hc}get/labTest?userId=$userId";

    log(url);
    lb.LabStatusModel loadedData;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);

      print("RESponse : $responseData");
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 0) {
        throw HttpException(responseData["data"]);
      }
      if (responseData['status'] == 1) {
        log("started");
        final data = json.decode(response.body);
        loadedData = lb.LabStatusModel.fromJson(data);

        log(loadedData.data!.length.toString());
        log('fetched lab appoinments');

        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
