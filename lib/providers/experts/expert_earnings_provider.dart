import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/experts/expert_earnings_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class ExpertEarningsProvider with ChangeNotifier {
  Future<HcRevenue> getHealthCareExpertEarnings(
      String userId, String dateFilter) async {
    String url = "${ApiUrl.hc}fetch/hcRevenues?specialExpertId=$userId";
    log(url);
    HcRevenue earningsModel = HcRevenue();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'];

        log(data.toString());

        earningsModel = HcRevenue(
          data: RevenueListData(
              revenuesData: List<RevenuesData>.from(
            data["revenuesData"].map((x) => RevenuesData.fromJson(x)),
            // totalPayout: data["totalPayout"],
          )),
        );

        log('fetched experts earnings');
        return earningsModel;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Future<ExpertEarningsModel> getExpertEarnings(
  //     String userId, String dateFilter) async {
  //   String url =
  //       "${ApiUrl.url}fetch/revenue?specialExpertId=$userId&$dateFilter";
  //   log(url);
  //   ExpertEarningsModel earningsModel = ExpertEarningsModel();
  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     final responseData = json.decode(response.body);
  //     log(responseData);
  //     if (response.statusCode >= 400) {
  //       throw HttpException(responseData["message"]);
  //     }
  //     if (responseData['status'] == 1) {
  //       final data = json.decode(response.body)['data'];

  //       log(data.toString());

  //       earningsModel = ExpertEarningsModel(
  //         revenuesData: List<RevenuesDatum>.from(
  //           data["revenueDetails"].map((x) => RevenuesDatum.fromJson(x)),
  //         ),
  //         totalPayout: data["totalPayout"],
  //       );

  //       log('fetched experts earnings');
  //       return earningsModel;
  //     } else {
  //       throw HttpException(responseData["message"]);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
}
