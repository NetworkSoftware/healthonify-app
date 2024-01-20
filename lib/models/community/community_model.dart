class CommunityModel {
  bool? isApproved;
  String? likesCount;
  String? commentsCount;
  String? id;
  String? userId;
  String? userImage;
  String? userFirstName;
  String? userLastName;
  String? mediaLink;
  String? description;
  String? date;
  String? userType;
  bool? isActive;
  bool? isLiked;
  CommunityModel({
    this.commentsCount,
    this.date,
    this.description,
    this.id,
    this.isActive,
    this.userImage,
    this.isApproved,
    this.isLiked,
    this.likesCount,
    this.mediaLink,
    this.userFirstName,
    this.userId,
    this.userLastName,
    this.userType,
  });
}

class Comments {
  String? id, postId, comment;
  Map<String, dynamic>? commentBy;
  Comments({
    this.id,
    this.postId,
    this.comment,
    this.commentBy,
  });
}

class LikesAndComments {
  int? likesCount, commentsCount;
  LikesAndComments({
    this.commentsCount,
    this.likesCount,
  });
}

class Report {
  String? id;
  String? postId;
  String? flaggeBy;
  String? flaggedDate;
  String? createdAt;
  String? updatedAt;

  Report(
      {this.postId,
      this.flaggedDate,
      this.createdAt,
      this.flaggeBy,
      this.id,
      this.updatedAt});
}
