class PaymentResponse {
  final String amount;
  final String trxId;
  final String paymentId;
  final String payerReference;
  final String customerMsisdn;
  final String merchantInvoiceNumber;
  final String paymentExecuteTime;

  PaymentResponse({
    required this.amount,
    required this.trxId,
    required this.paymentId,
    required this.payerReference,
    required this.customerMsisdn,
    required this.merchantInvoiceNumber,
    required this.paymentExecuteTime,
  });

  @override
  String toString() {
    return '''{
        "amount": "$amount",
        "trxId": "$trxId",
        "paymentId": "$paymentId",
        "payerReference": "$payerReference",
        "customerMsisdn": "$customerMsisdn",
        "merchantInvoiceNumber": "$merchantInvoiceNumber",
        "paymentExecuteTime": "${paymentExecuteTime.replaceAll(' GMT+0600', '')}"
      }''';
  }
}
