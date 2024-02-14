class CreatePaymentResponse {
  final String paymentID;
  final String paymentCreateTime;
  final String transactionStatus;
  final String amount;
  final String currency;
  final String intent;
  final String merchantInvoiceNumber;
  final String bkashURL;
  final String callbackURL;
  final String successCallbackURL;
  final String failureCallbackURL;
  final String cancelledCallbackURL;
  final String statusCode;
  final String statusMessage;

  CreatePaymentResponse(
    this.paymentID,
    this.paymentCreateTime,
    this.transactionStatus,
    this.amount,
    this.currency,
    this.intent,
    this.merchantInvoiceNumber,
    this.bkashURL,
    this.callbackURL,
    this.successCallbackURL,
    this.failureCallbackURL,
    this.cancelledCallbackURL,
    this.statusCode,
    this.statusMessage,
  );

  CreatePaymentResponse.fromJson(Map<String, dynamic> json)
      : paymentID = json['paymentID'] as String? ?? '',
        paymentCreateTime = json['paymentCreateTime'] as String? ?? '',
        transactionStatus = json['transactionStatus'] as String? ?? '',
        amount = json['amount'] as String? ?? '',
        currency = json['currency'] as String? ?? '',
        intent = json['intent'] as String? ?? '',
        merchantInvoiceNumber = json['merchantInvoiceNumber'] as String? ?? '',
        bkashURL = json['bkashURL'] as String? ?? '',
        callbackURL = json['callbackURL'] as String? ?? '',
        successCallbackURL = json['successCallbackURL'] as String? ?? '',
        failureCallbackURL = json['failureCallbackURL'] as String? ?? '',
        cancelledCallbackURL = json['cancelledCallbackURL'] as String? ?? '',
        statusCode = json['statusCode'] as String? ?? '',
        statusMessage = json['statusMessage'] as String? ?? '';

  Map<String, dynamic> toJson() => {
        'paymentID': paymentID,
        'paymentCreateTime': paymentCreateTime,
        'transactionStatus': transactionStatus,
        'amount': amount,
        'currency': currency,
        'intent': intent,
        'merchantInvoiceNumber': merchantInvoiceNumber,
        'bkashURL': bkashURL,
        'callbackURL': callbackURL,
        'successCallbackURL': successCallbackURL,
        'failureCallbackURL': failureCallbackURL,
        'cancelledCallbackURL': cancelledCallbackURL,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
      };
}
