class ConsultForm {
  String? userId,
      expertId,
      expertiseId,
      startDate,
      startTime,
      grossAmount,
      discount,
      gstAmount,
      netAmount,
      amount,
      slotNumber;

  ConsultForm({
    this.userId,
    this.expertId,
    this.expertiseId,
    this.startDate,
    this.startTime,
    this.grossAmount,
    this.discount,
    this.gstAmount,
    this.netAmount,
    this.amount,
    this.slotNumber,
  });
}

class ConsultNow {
  String? consultationId;

  ConsultNow({
    this.consultationId,
  });
}

class SubscribePackage {
  String? subscriptionId, rzpOrderId;
  SubscribePackage({this.subscriptionId, this.rzpOrderId});
}
