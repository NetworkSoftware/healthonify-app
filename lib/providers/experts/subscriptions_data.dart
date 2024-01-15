import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:healthonify_mobile/models/experts/subscriptions.dart';

class SubscriptionsData with ChangeNotifier {
  List<Subscriptions> _subsData = [];
  List<Subscriptions> get subsData {
    return [..._subsData];
  }
  List<Subscriptions> _subsFitnessData = [];
  List<Subscriptions> get subsFitnessData {
    return [..._subsFitnessData];
  }

  List<Subscriptions> _hcSubsData = [];
  List<Subscriptions> get hcSubsData {
    return [..._hcSubsData];
  }
  List<Subscriptions> _subsPhysioData = [];
  List<Subscriptions> get subsPhysioData {
    return [..._subsPhysioData];
  }

  List<Subscriptions> _subsLiveWellData = [];
  List<Subscriptions> get subsLiveWellData {
    return [..._subsLiveWellData];
  }

  List<Subscriptions> _subsAyurvedaData = [];
  List<Subscriptions> get subsAyurvedaData {
    return [..._subsAyurvedaData];
  }


  Future<void> getSubsFitnessData(String params) async {
    String url = '${ApiUrl.url}get/subscription?$params';

    log(url);

    final List<Subscriptions> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      // log(response.body.toString());

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody["error"]);
        throw HttpException(responseBody["message"]);
      }

      if (responseBody['status'] == 1) {
        final responseData =
        json.decode(response.body)['data'] as List<dynamic>;

        for (var element in responseData) {
          loadedData.add(
            Subscriptions(
                id: element['_id'],
                expertId: element['expertId'],
                userId: element['userId'],
                packageId: element['packageId'],
                startDate: element['date'],
                grossAmount: element['grossAmount'],
                gstAmount: element['gstAmount'],
                discount: element['discount'],
                netAmount: element['netAmount'],
                status: element['status'],
                ticketNumber: element["ticketNumber"],
                isActive: element["isActive"] ?? "false",
                packageName: element['packageName']),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _subsFitnessData = loadedData;
        // log(_loadedData[0].grossAmount.toString());
        // log('Fetched subscription data');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      _subsFitnessData.clear();
      log(e.toString());
    }
  }

  Future<void> getSubsData(String params) async {
    String url = '${ApiUrl.url}fetch/subscription?$params';

    log(url);

    final List<Subscriptions> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      // log(response.body.toString());

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody["error"]);
        throw HttpException(responseBody["message"]);
      }

      if (responseBody['status'] == 1) {
        final responseData =
        json.decode(response.body)['data'] as List<dynamic>;

        for (var element in responseData) {
          loadedData.add(
            Subscriptions(
                id: element['_id'],
                expertId: element['expertId'],
                userId: element['userId'],
                //packageId: element['packageId'],
                startDate: element['date'],
               // grossAmount: element['grossAmount'],
              //  gstAmount: element['gstAmount'],
               // discount: element['discount'],
               // netAmount: element['netAmount'],
                status: element['status'],
                ticketNumber: element["ticketNumber"],
                isActive: element["isActive"] ?? "false",
                packageName: element['packageName'],
                flow: element['flow']),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _subsFitnessData = loadedData;
        // log(_loadedData[0].grossAmount.toString());
        // log('Fetched subscription data');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      _subsFitnessData.clear();
      log(e.toString());
    }
  }

  Future<void> getSubsPhysioData(String params) async {
    String url = '${ApiUrl.url}get/subscription?$params';

    log(url);

    final List<Subscriptions> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      // log(response.body.toString());

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody["error"]);
        throw HttpException(responseBody["message"]);
      }

      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var element in responseData) {
          loadedData.add(
            Subscriptions(
                id: element['_id'],
                expertId: element['expertId'],
                userId: element['userId'],
                packageId: element['packageId'],
                startDate: element['startDate'],
                grossAmount: element['grossAmount'],
                gstAmount: element['gstAmount'],
                discount: element['discount'],
                netAmount: element['netAmount'],
                status: element['status'],
                isActive: element["isActive"] ?? false,
                packageName: element['packageName']),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _subsPhysioData = loadedData;
        // log(_loadedData[0].grossAmount.toString());
        // log('Fetched subscription data');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e,trace) {
      _subsPhysioData.clear();
      log(e.toString());
      log(trace.toString());
    }
  }

  Future<void> getSubsLiveWellData(String params) async {
    String url = '${ApiUrl.url}get/subscription?$params';

    log(url);

    final List<Subscriptions> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      // log(response.body.toString());

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody["error"]);
        throw HttpException(responseBody["message"]);
      }

      if (responseBody['status'] == 1) {
        final responseData =
        json.decode(response.body)['data'] as List<dynamic>;

        for (var element in responseData) {
          loadedData.add(
            Subscriptions(
                id: element['_id'],
                expertId: element['expertId'],
                userId: element['userId'],
                packageId: element['packageId'],
                startDate: element['startDate'],
                grossAmount: element['grossAmount'],
                gstAmount: element['gstAmount'],
                discount: element['discount'],
                netAmount: element['netAmount'],
                status: element['status'],
                isActive: element["isActive"] ?? false,
                packageName: element['packageName']),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _subsLiveWellData = loadedData;
        // log(_loadedData[0].grossAmount.toString());
        // log('Fetched subscription data');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e,trace) {
      _subsLiveWellData.clear();
      log(e.toString());
      log(trace.toString());
    }
  }

  Future<void> getSubsAyurvedaData(String params) async {
    String url = '${ApiUrl.url}get/subscription?$params';

    log(url);

    final List<Subscriptions> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      // log(response.body.toString());

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody["error"]);
        throw HttpException(responseBody["message"]);
      }

      if (responseBody['status'] == 1) {
        final responseData =
        json.decode(response.body)['data'] as List<dynamic>;

        for (var element in responseData) {
          loadedData.add(
            Subscriptions(
                id: element['_id'],
                expertId: element['expertId'],
                userId: element['userId'],
                packageId: element['packageId'],
                startDate: element['startDate'],
                grossAmount: element['grossAmount'],
                gstAmount: element['gstAmount'],
                discount: element['discount'],
                netAmount: element['netAmount'],
                status: element['status'],
                isActive: element["isActive"] ?? false,
                packageName: element['packageName']),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _subsAyurvedaData = loadedData;
        // log(_loadedData[0].grossAmount.toString());
        // log('Fetched subscription data');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e,trace) {
      _subsAyurvedaData.clear();
      log(e.toString());
      log(trace.toString());
    }
  }

  Future<void> getHcSubs(String params) async {
    String url = '${ApiUrl.url}get/subscription?$params';

    log(url);

    final List<Subscriptions> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      // log(response.body.toString());

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody["error"]);
        throw HttpException(responseBody["message"]);
      }

      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var element in responseData) {
          loadedData.add(
            Subscriptions(
                id: element['_id'],
                expertId: element['expertId'],
                userId: element['userId'],
                packageId: element['packageId'],
                startDate: element['startDate'],
                grossAmount: element['grossAmount'],
                gstAmount: element['gstAmount'],
                discount: element['discount'],
                netAmount: element['netAmount'],
                status: element['status'],
                isActive: element["isActive"] ?? "false",
                packageName: element['packageName']),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _hcSubsData = loadedData;
        // log(_loadedData[0].grossAmount.toString());
        // log('Fetched subscription data');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      _hcSubsData.clear();
      log(e.toString());
    }
  }
}
