class PillsReminderModel {
  String? id;
  String? medicineName;
  String? time;
  String? userId;
  
  String? createdAt;
  String? updatedAt;

  PillsReminderModel({
    this.id,
    this.time,
    
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.medicineName,
  });
}