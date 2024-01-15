import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/prescription/prescription_model.dart';
import 'package:http/http.dart' as http;

class StorePrescriptionProvider with ChangeNotifier {
  List<PrescriptionConsultation> _prescriptionList = [];
  List<PrescriptionConsultation> _expertPrescriptionList = [];

  List<PrescriptionConsultation> get prescriptionList {
    return [..._prescriptionList];
  }

  List<PrescriptionConsultation> get expertPrescriptionList {
    return [..._expertPrescriptionList];
  }

  Future<void> storePrescription(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}expert/storeHcPrescription';
    log("urk : $url");
    log(json.encode(data));

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

  Future<void> getPrescriptionAllData(String ticketNumber) async {
    // String url = "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId";
    String url = "${ApiUrl.hc}get/hcPrescriptions?ticketNumber=$ticketNumber";

    log("fetch all consultations url $url");

    final List<PrescriptionConsultation> pc = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      // log(responseData.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          // log(ele.toString());
          pc.add(
            PrescriptionConsultation(
                id: ele["_id"],
                userId: ele["userId"],
                expertId: ele["expertId"],
                advices: ele["advices"] ?? "",
                date: ele["date"] ?? "",
                gender: ele["gender"] ?? "",
                ticketNumber: ele["ticketNumber"],
                reportType: ele["reportType"] ?? "",
                prescriptionUrl: ele["prescriptionUrl"] ?? "",
                chiefComplaints: ele["chiefComplaints"] ?? "",
                medicines: ele["medicines"] != null
                    ? List<dynamic>.from(ele["medicines"].map((x) => x))
                    : []),
          );
        }

        log("len ${pc.length}");

        _prescriptionList = pc;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(trace.toString());
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getExpertPrescriptionAllData(String expertId,String userId) async {
    // String url = "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId";
    String url = "${ApiUrl.hc}get/hcPrescriptions?expertId=$expertId&userId=$userId";

    log("fetch all consultations url $url");

    final List<PrescriptionConsultation> expc = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      // log(responseData.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          // log(ele.toString());
          expc.add(
            PrescriptionConsultation(
                id: ele["_id"],
                userId: ele["userId"],
                expertId: ele["expertId"],
                advices: ele["advices"] ?? "",
                date: ele["date"] ?? "",
                gender: ele["gender"] ?? "",
                ticketNumber: ele["ticketNumber"],
                reportType: ele["reportType"] ?? "",
                prescriptionUrl: ele["prescriptionUrl"] ?? "",
                chiefComplaints: ele["chiefComplaints"] ?? "",
                medicines: ele["medicines"] != null
                    ? List<dynamic>.from(ele["medicines"].map((x) => x))
                    : []),
          );
        }

        log("len ${expc.length}");

        _expertPrescriptionList = expc;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(trace.toString());
      log(e.toString());
      rethrow;
    }
  }

  Future<void> storePhysioPrescription(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}expert/create/PhysioPrescriptions';

    log(data.toString());

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      log(responseData.toString());

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
}
