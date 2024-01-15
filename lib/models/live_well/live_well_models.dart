class LiveWellCategories {
  String? name;
  String? description;
  String? parentCategoryId;
  String? id;
  String? mediaLink;


  LiveWellCategories({
    this.description,
    this.name,
    this.parentCategoryId,
    this.id,
    this.mediaLink
  });
}

class ContentModel {
  String? id;
  String? title;
  String? description;
  String? mediaLink;
  String? type;
  String? thumbnail;
  String? format;

  ContentModel({
    this.id,
    this.description,
    this.mediaLink,
    this.thumbnail,
    this.title,
    this.type,
    this.format
  });
}
