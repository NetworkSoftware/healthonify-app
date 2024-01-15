import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/appointment_consultation/appointment_consultation_model.dart';
import 'package:healthonify_mobile/models/appointment_consultation/appointment_package_consultation_model.dart';
import 'package:healthonify_mobile/models/appointment_consultation/appointment_session_model.dart';
import 'package:healthonify_mobile/models/consultation.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_consultation.dart';
import "package:http/http.dart" as http;

class AllConsultationsData with ChangeNotifier {
  List<Consultation> _physioConsultation = [];
  List<WmConsultation> _wmConsultation = [];
  List<HealthCareConsultations> _healthCareConsultation = [];
  List<AppointmentConsultation> _consultationList = [];
  List<AppointmentPackageConsultation> _packageConsultationList = [];
  List<AppointmentSessionConsultation> _sessionConsultationList = [];
  List<Enquiry> _enquiryList = [];

  List<Enquiry> get enquiryList {
    return [..._enquiryList];
  }

  List<AppointmentConsultation> get consultationList {
    return [..._consultationList];
  }

  List<AppointmentSessionConsultation> get sessionConsultationList {
    return [..._sessionConsultationList];
  }

  List<AppointmentPackageConsultation> get packageConsultationList {
    return [..._packageConsultationList];
  }

  List<Consultation> get physioConsultation {
    return [..._physioConsultation];
  }

  List<WmConsultation> get wmConsultation {
    return [..._wmConsultation];
  }

  List<HealthCareConsultations> get healthCareConsultation {
    return [..._healthCareConsultation];
  }

  Future<void> getAllConsultationsData(String userId,
      {String status = ""}) async {
    // String url = "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId";
    String url = "";

    if (status == "scheduled") {
      url =
          "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId&status=scheduled";
    }

    log("fetch all consultations url $url");

    final List<Consultation> physio = [];
    final List<WmConsultation> wm = [];
    final List<HealthCareConsultations> hc = [];

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
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        // log(data.toString());
        final physioConsultationsData =
            data["physioConsultationsData"] as List<dynamic>;
        final wmConsultationsData =
            data["wmConsultationsData"] as List<dynamic>;

        final healthCareConsultationsData =
            data["hcConsultationsData"] as List<dynamic>;

        // log(healthCareConsultationsData.toString());

        for (var ele in physioConsultationsData) {
          // log(ele.toString());
          if (ele["status"] == "initiated") {
            // log("hey");
            physio.add(
              Consultation(
                id: ele["_id"],
                expertiseId: ele["expertiseId"] != null
                    ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
                    : [],
                user: List<dynamic>.from(ele["userId"].map((x) => x)),
                startTime: ele["time"],
                startDate: ele["date"],
                status: ele["status"],
              ),
            );
          } else {
            log("hey");
            physio.add(
              Consultation(
                id: ele["_id"],
                expertiseId: ele["expertiseId"] != null
                    ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
                    : [],
                expertId: ele["expertId"] == null
                    ? {}
                    : ele["expertId"][0] as Map<String, dynamic>,
                startTime: ele["time"],
                user: List<dynamic>.from(ele["userId"].map((x) => x)),
                startDate: ele["date"],
                status: ele["status"] ?? "",
              ),
            );
          }
        }

        for (var ele in wmConsultationsData) {
          wm.add(
            WmConsultation(
              id: ele["_id"],
              expert: ele["expertId"] != null
                  ? List<dynamic>.from(ele["expertId"].map((x) => x))
                  : [],
              userId: List<dynamic>.from(ele["userId"].map((x) => x)),
              startTime: ele["startTime"],
              startDate: ele["startDate"],
              status: ele["status"],
              durationInMinutes: ele["durationInMinutes"],
              type: ele["type"],
            ),
          );
        }

        for (var element in healthCareConsultationsData) {
          hc.add(
            HealthCareConsultations(
              id: element["_id"],
              expertiseId: List<ExpertiseId>.from(
                  element["expertiseId"].map((x) => ExpertiseId.fromJson(x))),
              startDate: element["startDate"],
              startTime: element["startTime"],
              userId:
                  List<Id>.from(element["userId"].map((x) => Id.fromJson(x))),
              description: element["description"],
              expertId: element["expertId"] == null
                  ? []
                  : List<Id>.from(
                      element["expertId"].map((x) => Id.fromJson(x))),
              startTimeMiliseconds: element["startTimeMiliseconds"],
              status: element["status"],
              meetingLink: element["meetingLink"],
              isActive: element["isActive"],
            ),
          );
        }

        log("len ${hc.length}");

        _physioConsultation = physio;
        _wmConsultation = wm;
        _healthCareConsultation = hc;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getUserAllEnquiryData(String userId, String flow,
      {String status = ""}) async {
    // String url = "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId";
    String url;

    if (flow == "") {
      url = "${ApiUrl.url}fetch/consultation?userId=$userId";
    } else {
      url = "${ApiUrl.url}fetch/consultation?userId=$userId&flow=$flow";
    }

    log("fetch all consultations url $url");

    final List<Enquiry> eL = [];

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
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        // log(data.toString());
        final enquiry = data["enquiries"] as List<dynamic>;

        for (var ele in enquiry) {
          // log(ele.toString());
          eL.add(
            Enquiry(
              enquiryId: ele["_id"],
              enquiryName: ele["name"],
              contactNumber: ele["contactNumber"],
              category: ele["category"] ?? "",
              status: ele["status"] ?? "",
              flow: ele["flow"] ?? "",
              ticketNumber: ele["ticketNumber"],
              date: ele["date"],
              time: ele["consultationTime"],
              comments: ele["comments"],
            ),
          );
        }

        log("len ${eL.length}");

        _enquiryList = eL;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getUserAllConsultationsData(
      String ticketNumber, String flow) async {
    // String url = "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId";
    String url;

    url =
        "${ApiUrl.url}fetch/consultation?ticketNumber=$ticketNumber&flow=$flow";

    log("fetch all consultations url $url");

    final List<AppointmentConsultation> cL = [];

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
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        // log(data.toString());
        final consult = data["consultationData"] as List<dynamic>;

        for (var ele in consult) {
          // log(ele.toString());
          cL.add(
            AppointmentConsultation(
              id: ele["_id"],
              expert: ele["expertId"] != null
                  ? List<dynamic>.from(ele["expertId"].map((x) => x))
                  : [],
              comments: ele["comments"] != null
                  ? List<dynamic>.from(ele["comments"].map((x) => x))
                  : [],
              subExpertiseId: ele["subExpertiseId"] != null
                  ? List<dynamic>.from(ele["subExpertiseId"].map((x) => x))
                  : [],
              expertiseId: ele["expertiseId"] != null
                  ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
                  : [],
              userId: List<dynamic>.from(ele["userId"].map((x) => x)),
              startTime: ele["time"],
              startDate: ele["date"],
              status: ele["status"],
              durationInMinutes: ele["durationInMinutes"],
              flow: ele["flow"],
              ticketNumber: ele["ticketNumber"],
              consultationCharge: ele["consultationCharge"],
              type: ele["type"],
              paymentLink: ele["paymentLink"] ?? "",
            ),
          );
        }

        log("len ${cL.length}");

        _consultationList = cL;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getUserPackageConsultationsData(
      String ticketNumber, String flow) async {
    String url;

    url =
        "${ApiUrl.url}fetch/subscription?ticketNumber=$ticketNumber&flow=$flow";

    log("fetch all consultations url $url");

    final List<AppointmentPackageConsultation> pL = [];

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
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        // log(data.toString());
        // final consult = data["consultationData"] as List<dynamic>;

        pL.add(
          AppointmentPackageConsultation(
            id: data["_id"],
            paymentLink: data["paymentLink"],
            ticketNumber: data["ticketNumber"],
            status: data["status"],
            expertId: data["expertId"] != null ? data["expertId"] as Map<String, dynamic> : null,
            userId: data["userId"] as Map<String, dynamic>,
            packageId: data["packageId"] as Map<String, dynamic>,
            serviceDetails: data["serviceDetails"] != null
                ? List<dynamic>.from(data["serviceDetails"].map((x) => x))
                : [],
          ),
        );

        log("len ${pL.length}");

        _packageConsultationList = pL;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getUserSessionConsultationsData(String ticketNumber,String flow) async {
    String url;

    url = "${ApiUrl.url}fetch/session?ticketNumber=$ticketNumber&flow=$flow";

    log("fetch all consultations url $url");

    final List<AppointmentSessionConsultation> sL = [];

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
        // log(data.toString());
        // final consult = data["consultationData"] as List<dynamic>;

        for (var ele in data) {
          // log(ele.toString());
          sL.add(
            AppointmentSessionConsultation(
                id: ele["_id"],
                order: ele["order"],
                sessionNumber: ele["sessionNumber"],
                status: ele["status"],
                startDate: ele["startDate"] ?? "",
                startTime: ele["startTime"] ?? "", comment: ele["comments"] != null
                ? List<dynamic>.from(ele["comments"].map((x) => x))
                : []),
          );
        }

        log("len ${sL.length}");

        _sessionConsultationList = sL;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> postSessionSchedule(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}expert/session/schedule';

    log(url);

    log(data.toString());

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
        Fluttertoast.showToast(msg: responseData['message']);
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
