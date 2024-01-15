class BlogsModel {
  String? id;
  String? mediaLink;
  bool? isActive;
  String? description;
  String? date;
  String? blogTitle;
  String? expertiseId;

  BlogsModel({
    this.blogTitle,
    this.date,
    this.description,
    this.expertiseId,
    this.id,
    this.isActive,
    this.mediaLink,
  });
}
