import 'package:flutter/material.dart';

import '../config/bkash_credentials.dart';
import '../models/create_payment_response.dart';
import '../models/execute_payment_response.dart';
import '../models/payment_response.dart';
import '../models/payment_status.dart';
import '../models/token_response.dart';
import '../utils/exception.dart';
import '../views/payment_screen.dart';
import 'api_client.dart';

class BkashApi {
  static BkashApi? _instance;
  static TokenResponse? _token;
  static late DateTime _tokenValidity;
  static late String _baseUrl;

  BkashApi._();

  factory BkashApi() => _instance ??= BkashApi._();

  Future<String> get _tokenString async {
    if (_token != null && _tokenValidity.isAfter(DateTime.now())) {
      return '${_token!.tokenType} ${_token!.idToken}';
    }

    _token = await _createOrRefreshToken();
    _tokenValidity = DateTime.now().add(Duration(seconds: _token!.expiresIn));
    return '${_token!.tokenType} ${_token!.idToken}';
  }

  /// Retrieve New Token
  Future<TokenResponse> _createOrRefreshToken() async {
    final headers = {
      "username": BkashCredentials.username,
      "password": BkashCredentials.password,
    };

    final body = {
      "app_key": BkashCredentials.appKey,
      "app_secret": BkashCredentials.appSecret,
      if (_token != null) "refresh_token": _token!.refreshToken,
    };

    final response = await apiClient.post(
      _token != null ? '$_baseUrl/tokenized/checkout/token/refresh' : '$_baseUrl/tokenized/checkout/token/grant',
      body: body,
      headers: headers,
    );
    final token = TokenResponse.fromJson(response.data);

    if (token.statusCode != "0000") {
      throw PaymentException(message: token.statusMessage);
    }

    return token;
  }

  /// Pay Without Agreement
  Future<CreatePaymentResponse> _createPayment({
    required String amount,
    required String payerReference,
    required String merchantInvoiceNumber,
  }) async {
    final headers = {
      "Authorization": await _tokenString,
      "X-APP-Key": BkashCredentials.appKey,
    };

    final body = {
      "mode": '0011',
      "payerReference": payerReference,
      "callbackURL": 'https://example.com/',
      "amount": amount,
      "currency": 'BDT',
      "intent": 'sale',
      "merchantInvoiceNumber": merchantInvoiceNumber,
    };

    final response = await apiClient.post(
      '$_baseUrl/tokenized/checkout/create',
      body: body,
      headers: headers,
    );
    final createPayment = CreatePaymentResponse.fromJson(response.data);

    if (createPayment.statusCode != "0000") {
      throw PaymentException(message: createPayment.statusMessage);
    }

    return createPayment;
  }

  /// Execute Pay Without Agreement
  Future<ExecutePaymentResponse> _executePayment({required String paymentId}) async {
    final headers = {
      "Authorization": await _tokenString,
      "X-APP-Key": BkashCredentials.appKey,
    };

    final body = {
      "paymentID": paymentId,
    };

    final response = await apiClient.post(
      '$_baseUrl/tokenized/checkout/execute',
      body: body,
      headers: headers,
    );
    final executePayment = ExecutePaymentResponse.fromJson(response.data);

    if (executePayment.statusCode != "0000") {
      throw PaymentException(message: executePayment.statusMessage);
    }

    return executePayment;
  }

  /// Pay With bKash
  Future<PaymentResponse> makePayment({
    required BuildContext context,
    required double amount,
    required String payerReference,
    required String merchantInvoiceNumber,
    bool isSandbox = true,
  }) async {

    _baseUrl = isSandbox
        ? 'https://tokenized.sandbox.bka.sh/v1.2.0-beta'
        : 'https://tokenized.pay.bka.sh/v1.2.0-beta';

    final resp = await _createPayment(
      amount: amount.toString(),
      payerReference: payerReference.isNotEmpty ? payerReference : " ",
      merchantInvoiceNumber: merchantInvoiceNumber.isNotEmpty ? merchantInvoiceNumber : "INV",
    );

    if (!context.mounted) {
      throw PaymentException(message: "Payment Failed");
    }

    final paymentStatus = await Navigator.push<PaymentStatus>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          bkashURL: resp.bkashURL,
          failureCallbackURL: resp.failureCallbackURL,
          successCallbackURL: resp.successCallbackURL,
          cancelledCallbackURL: resp.cancelledCallbackURL,
        ),
      ),
    ) ?? PaymentStatus.canceled;

    if (paymentStatus == PaymentStatus.success) {
      final result = await _executePayment(paymentId: resp.paymentID);
      return PaymentResponse(
        amount: result.amount,
        trxId: result.trxID,
        paymentId: result.paymentID,
        payerReference: result.payerReference,
        customerMsisdn: result.customerMsisdn,
        merchantInvoiceNumber: result.merchantInvoiceNumber,
        paymentExecuteTime: result.paymentExecuteTime,
      );
    } else if (paymentStatus == PaymentStatus.canceled) {
      throw PaymentException(message: "Payment Cancelled");
    } else {
      throw PaymentException(message: "Payment Failed");
    }
  }
}

final bkashApi = BkashApi();