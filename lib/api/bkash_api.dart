import '../config/app_constants.dart';
import '../models/create_payment_response.dart';
import '../models/execute_payment_response.dart';
import '../models/token_response.dart';
import 'api_client.dart';

class BkashApi {
  static BkashApi? _instance;
  static TokenResponse? _token;
  static late DateTime _tokenValidity;

  BkashApi._();

  factory BkashApi() => _instance ??= BkashApi._();

  Future<String> get token async {
    if (_token == null) {
      final token = await _createToken();
      if (token.statusCode != '0000') {
        throw Exception(token.statusMessage);
      }

      _tokenValidity = DateTime.now().add(Duration(seconds: token.expiresIn));
      _token = token;
      return '${token.tokenType} ${token.idToken}';
    } else {
      if (_tokenValidity.isAfter(DateTime.now())) {
        return '${_token!.tokenType} ${_token!.idToken}';
      }

      final newToken = await _refreshToken(refreshToken: _token!.refreshToken);
      if (newToken.statusCode != '0000') {
        throw Exception(newToken.statusMessage);
      }

      _tokenValidity = DateTime.now().add(Duration(seconds: newToken.expiresIn));
      _token = newToken;
      return '${newToken.tokenType} ${newToken.idToken}';
    }
  }

  /// Create Token
  Future<TokenResponse> _createToken() async {
    final headers = {
      "username": AppConstants.username,
      "password": AppConstants.password,
    };

    final body = {
      "app_key": AppConstants.appKey,
      "app_secret": AppConstants.appSecret,
    };

    final response = await apiClient.post(AppConstants.createToken, body: body, headers: headers);
    return TokenResponse.fromJson(response.data);
  }

  /// Refresh Token
  Future<TokenResponse> _refreshToken({required String refreshToken}) async {
    final headers = {
      "username": AppConstants.username,
      "password": AppConstants.password,
    };

    final body = {
      "app_key": AppConstants.appKey,
      "app_secret": AppConstants.appSecret,
      "refresh_token": refreshToken,
    };

    final response = await apiClient.post(AppConstants.createToken, body: body, headers: headers);
    return TokenResponse.fromJson(response.data);
  }

  /// Pay Without Agreement
  Future<CreatePaymentResponse> createPayment({
    required String amount,
    required String payerReference,
    required String merchantInvoiceNumber,
  }) async {
    final headers = {
      "Authorization": await token,
      "X-APP-Key": AppConstants.appKey,
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

    final response = await apiClient.post(AppConstants.createPayment, body: body, headers: headers);
    return CreatePaymentResponse.fromJson(response.data);
  }

  /// Execute Pay Without Agreement
  Future<ExecutePaymentResponse> executePayment({required String paymentId}) async {
    final headers = {
      "Authorization": await token,
      "X-APP-Key": AppConstants.appKey,
    };

    final body = {
      "paymentID": paymentId,
    };

    final response = await apiClient.post(AppConstants.executePayment, body: body, headers: headers);
    return ExecutePaymentResponse.fromJson(response.data);
  }
}

final bkashApi = BkashApi();
