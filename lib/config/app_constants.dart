class AppConstants {
  AppConstants._();

  static const bool isProduction = false;

  static const String baseUrl = isProduction
      ? 'https://tokenized.pay.bka.sh/v1.2.0-beta'
      : 'https://tokenized.sandbox.bka.sh/v1.2.0-beta';

  static const String createToken = '$baseUrl/tokenized/checkout/token/grant';
  static const String refreshToken = '$baseUrl/tokenized/checkout/token/refresh';
  static const String createPayment = '$baseUrl/tokenized/checkout/create';
  static const String executePayment = '$baseUrl/tokenized/checkout/execute';

  /// TODO bKash credentials (Need to change in production)
  static const String username = 'sandboxTokenizedUser02';
  static const String password = 'sandboxTokenizedUser02@12345';
  static const String appKey = '4f6o0cjiki2rfm34kfdadl1eqq';
  static const String appSecret = '2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b';
}
