class LabsModel {
  List<dynamic>? coordinates;
  List<LabTestModel>? labTestCategories;
  String? labTestName;
  String? isLabTestActive;
  String? price;
  String? status;
  String? labId;
  String? vendorId;
  String? labName;
  String? labEmail;
  String? labMobileNo;
  String? address;
  String? agreement;
  int? gstPercent;
  int? homeServicePercent;
  int? hplCommission;
  int? platformCostProduct;
  String? id;

  LabsModel({
    this.address,
    this.agreement,
    this.coordinates,
    this.gstPercent,
    this.homeServicePercent,
    this.hplCommission,
    this.id,
    this.isLabTestActive,
    this.labEmail,
    this.labId,
    this.labMobileNo,
    this.labName,
    this.labTestCategories,
    this.labTestName,
    this.platformCostProduct,
    this.price,
    this.status,
    this.vendorId,
  });
}

class LabTestModel {
  String? labTestCategoryId;
  String? name;
  bool? isActive;
  int? price;

  LabTestModel({
    this.isActive,
    this.labTestCategoryId,
    this.name,
    this.price,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> json) => LabTestModel(
        name: json["name"],
        isActive: json["isActive"],
        price: json["price"],
        labTestCategoryId: json["id"],
      );
}
