class PaymentModel {
  String? razorpayOrderId;
  String? amountDue;
  String? amountPaid;
  String? currency;
  String? discount;
  String? grossAmount;
  String? gstAmount;
  String? invoiceNumber;
  String? labTestId;
  String? subscriptionId;
  String? netAmount;
  String? status;
  String? userId;
  String? id;
  String? flow;
  String? ticketNumber;

  PaymentModel(
      {this.amountDue,
      this.amountPaid,
      this.currency,
      this.discount,
      this.grossAmount,
      this.gstAmount,
      this.id,
      this.invoiceNumber,
      this.subscriptionId,
      this.labTestId,
      this.netAmount,
      this.razorpayOrderId,
      this.status,
      this.userId,
      this.flow,
      this.ticketNumber});
}

class StorePaymentResponse {
  String? message;
  String? ticketNumber;

  StorePaymentResponse({this.message, this.ticketNumber});
}
