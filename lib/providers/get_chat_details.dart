import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/chat_details.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class GetChatDetails with ChangeNotifier {
  List<ChatDetails> _chatDetails = [];
  List<ChatDetails> get chatDetails {
    return [..._chatDetails];
  }

  Future<void> getChatDetails(String userId, String expId) async {
    String url = '${ApiUrl.url}get/chat';

    List<ChatDetails> tempData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'] as List<dynamic>;

        for (var ele in data) {
          tempData.add(
            ChatDetails(
              id: ele['_id'],
              channelId: ele['channelId'],
              userId: ele['userId'],
              expertId: ele['expertId'],
            ),
          );
        }

        // log(data[0]['channelId']);

        _chatDetails = tempData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
