class PaymentResponse {
  final String trxId;
  final String paymentId;
  final String executeTime;
  final String payerReference;
  final String customerMsisdn;
  final String merchantInvoiceNumber;

  PaymentResponse({
    required this.trxId,
    required this.paymentId,
    required this.executeTime,
    required this.payerReference,
    required this.customerMsisdn,
    required this.merchantInvoiceNumber,
  });

  @override
  String toString() {
    return '''{
        "trxId": "$trxId",
        "paymentId": "$paymentId",
        "executeTime": "${executeTime.replaceAll(' GMT+0600', '')}",
        "payerReference": "$payerReference",
        "customerMsisdn": "$customerMsisdn",
        "merchantInvoiceNumber": "$merchantInvoiceNumber"
      }''';
  }
}
