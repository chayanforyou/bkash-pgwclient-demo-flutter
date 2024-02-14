class ExecutePaymentResponse {
  final String paymentID;
  final String customerMsisdn;
  final String payerReference;
  final String paymentExecuteTime;
  final String trxID;
  final String transactionStatus;
  final String amount;
  final String currency;
  final String intent;
  final String merchantInvoiceNumber;
  final String statusCode;
  final String statusMessage;

  ExecutePaymentResponse(
    this.paymentID,
    this.customerMsisdn,
    this.payerReference,
    this.paymentExecuteTime,
    this.trxID,
    this.transactionStatus,
    this.amount,
    this.currency,
    this.intent,
    this.merchantInvoiceNumber,
    this.statusCode,
    this.statusMessage,
  );

  ExecutePaymentResponse.fromJson(Map<String, dynamic> json)
      : paymentID = json['paymentID'] as String? ?? '',
        customerMsisdn = json['customerMsisdn'] as String? ?? '',
        payerReference = json['payerReference'] as String? ?? '',
        paymentExecuteTime = json['paymentExecuteTime'] as String? ?? '',
        trxID = json['trxID'] as String? ?? '',
        transactionStatus = json['transactionStatus'] as String? ?? '',
        amount = json['amount'] as String? ?? '',
        currency = json['currency'] as String? ?? '',
        intent = json['intent'] as String? ?? '',
        merchantInvoiceNumber = json['merchantInvoiceNumber'] as String? ?? '',
        statusCode = json['statusCode'] as String? ?? '',
        statusMessage = json['statusMessage'] as String? ?? '';

  Map<String, dynamic> toJson() => {
        'paymentID': paymentID,
        'customerMsisdn': customerMsisdn,
        'payerReference': payerReference,
        'paymentExecuteTime': paymentExecuteTime,
        'trxID': trxID,
        'transactionStatus': transactionStatus,
        'amount': amount,
        'currency': currency,
        'intent': intent,
        'merchantInvoiceNumber': merchantInvoiceNumber,
        'statusCode': statusCode,
        'statusMessage': statusMessage,
      };
}
