import 'dart:developer';

class PaymentException implements Exception {
  final String message;

  PaymentException({
    String? message,
  }) : message = message ?? 'Something went wrong' {
    log(this.message);
  }
}
