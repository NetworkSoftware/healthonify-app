import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/community/community_model.dart';

class CommunityProvider with ChangeNotifier {
  Future<List<CommunityModel>> getCommunityPosts(
      String id, String pageNo, String params) async {
    String url = '${ApiUrl.url}user/getAllPosts?$params';
    log(url);

    List<CommunityModel> commentsData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      var categoryResponse = json.decode(response.body) as Map<String, dynamic>;

      if (categoryResponse['status'] == 0) {
        throw HttpException(categoryResponse['message']);
      }

      if (categoryResponse['status'] == 1) {
        var data = categoryResponse["data"] as List<dynamic>;
        for (var ele in data) {
          commentsData.add(
            CommunityModel(
              isApproved: ele["isApproved"] ?? "",
              format: ele["format"] ?? "",
              likesCount: ele["likesCount"].toString(),
              commentsCount: ele["commentsCount"].toString(),
              id: ele["_id"],
              userImage: ele["userId"]["imageUrl"],
              userId: ele["userId"]["_id"] ?? "",
              mediaLink: ele["mediaLink"] ?? "",
              userType: ele["userType"] ?? "",
              userFirstName: ele["userId"]["firstName"],
              userLastName: ele["userId"]["lastName"],
              isActive: ele["isActive"] ?? "",
              description: ele["description"] ?? "",
              date: ele["date"] ?? "",
              isLiked: ele["isLiked"] ?? "",
            ),
          );
        }
        return commentsData;
      } else {
        throw HttpException(categoryResponse['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPost(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}post/communityPost';
    log(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      var categoryResponse = json.decode(response.body) as Map<String, dynamic>;

      if (categoryResponse['status'] == 0) {
        throw HttpException(categoryResponse['message']);
      }

      if (categoryResponse['status'] == 1) {
        var data = categoryResponse["data"];
        log(data.toString());
      } else {
        throw HttpException(categoryResponse['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likePost(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}user/addLike';
    log(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      var responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData['status'] == 0) {
        throw HttpException(responseData['message']);
      }

      if (responseData['status'] == 1) {
        var data = responseData["data"];
        log(data.toString());
      } else {
        throw HttpException(responseData['message']);
      }
      log(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Comments> postComment(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}user/addComment';
    log(url);

    Comments commentsData = Comments();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      var categoryResponse = json.decode(response.body) as Map<String, dynamic>;
      log(categoryResponse.toString());

      if (categoryResponse['status'] == 0) {
        throw HttpException(categoryResponse['message']);
      }

      if (categoryResponse['status'] == 1) {
        // var data = categoryResponse["data"] as Map<String, dynamic>;

        return commentsData;
      } else {
        throw HttpException(categoryResponse['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Report> reportPost(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}communityPosts/addFlag';
    log(url);

    Report reportData = Report();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      var categoryResponse = json.decode(response.body) as Map<String, dynamic>;
      log(categoryResponse.toString());

      if (categoryResponse['status'] == 0) {
        throw HttpException(categoryResponse['message']);
      }

      if (categoryResponse['status'] == 1) {
        // var data = categoryResponse["data"] as Map<String, dynamic>;

        return reportData;
      } else {
        throw HttpException(categoryResponse['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Comments>> getLikesAndComments(String postId) async {
    String url = '${ApiUrl.url}user/getLikesAndComments?postId=$postId';
    log(url);

    List<Comments> commentsData = [];
    // List<LikesAndComments> _likesData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      var categoryResponse = json.decode(response.body) as Map<String, dynamic>;

      if (categoryResponse['status'] == 0) {
        throw HttpException(categoryResponse['message']);
      }

      if (categoryResponse['status'] == 1) {
        var data = categoryResponse["data"]["commentsData"] as List<dynamic>;
        // var likesCommentsData =
        //     categoryResponse["data"] as Map<String, dynamic>;
        for (var ele in data) {
          commentsData.add(
            Comments(
              id: ele["_id"],
              commentBy: ele["commentBy"] ?? [],
              postId: ele["postId"] ?? "",
              comment: ele["comment"] ?? "",
            ),
          );
        }
        // _likesData.add(
        //   LikesAndComments(
        //     likesCount: likesCommentsData["likesCount"],
        //     commentsCount: likesCommentsData["commentsCount"],
        //   ),
        // );
        // log('likes - > ' + _likesData[0].likesCount.toString());
        // log('comments - > ' + _likesData[0].commentsCount.toString());
        return commentsData;
      } else {
        throw HttpException(categoryResponse['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
