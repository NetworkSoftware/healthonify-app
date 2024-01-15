class InsuranceModel {
  String? id;
  String? userId;
  String? insuranceType;
  String? insuranceCompanyName;
  String? mediaLink;
  String? expiryDate;
  String? entryDateTime;

  InsuranceModel({
    this.entryDateTime,
    this.expiryDate,
    this.insuranceCompanyName,
    this.insuranceType,
    this.mediaLink,
    this.userId,
    this.id,
  });
}
