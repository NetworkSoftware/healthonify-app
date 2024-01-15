class PackagesModel {
  final String name;
  final String packageId;
  final double price;
  Map<String, dynamic>? expertiseId;
  Map<String, dynamic>? subExpertiseId;

  // final String subCategoryId;
  // final List<dynamic> needToDo;
  // final String category;
  // final String subCategory;

  PackagesModel({
    required this.name,
    required this.packageId,
    required this.price,
    required this.expertiseId,
    required this.subExpertiseId,
    // required this.subCategoryId,
    // required this.needToDo,
    // required this.category,
    // required this.subCategory,
  });
}


