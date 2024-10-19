## Easy bKash integration with Flutter

[![GitHub license](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)]()  [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)]() [![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) [![made-with-love](https://img.shields.io/badge/Made%20with-Love-1f425f.svg)](https://chayanforyou.github.io/)


A simple implementation of bKash payment gateway in flutter with tokenized checkout feature.

## Features

* A Simple App with a button to `Checkout`
* Pressing the button initiates bKash payment dialogs
* Returns a success message with tranId if payment is successful

## Usage

Official link for API documentation and demo checkout

* [bKash API Specifications](https://developer.bka.sh/v1.2.0-beta/reference)
* [bKash Checkout Demo](https://merchantdemo.sandbox.bka.sh)

### Production

Replace the credentials for production uses in `bkash_credentials.dart` with your own bKash credentials and change the parameter `isSandbox: false`.

```dart
  static const String username = 'app_username';
  static const String password = 'app_password';
  static const String appKey = 'app_key';
  static const String appSecret = 'app_secret';
```
### Pay With bKash

Basically this the implementation of payment without an agreement. Use the `makePayment` method to pay

#### Request

```dart
final result = await bkashApi.makePayment(
    context: context,
    amount: 50.0,
    payerReference: "01770618575",
    merchantInvoiceNumber: "INV-123",
    isSandbox: false,
  );
```
#### Response

```json
{
  "amount": "50.0",
  "trxId": "BJJ90KGFBH",
  "paymentId": "TR0011HjY1p6A1729311405472",
  "payerReference": "01770618575",
  "customerMsisdn": "01770618575",
  "merchantInvoiceNumber": "INV-123",
  "paymentExecuteTime": "2024-10-19T10:17:14:333"
}
```

## Error Handling

In case of any error it's throw `PaymentException`. You can handle the exception using a try-catch block.

```dart
try {
  // Make a payment
} on PaymentException catch (e) {
  // Handle the error
  log(e.message);
}
```

## Video Demo

https://github.com/chayanforyou/bkash-pgwclient-demo-flutter/assets/12654289/9f81977b-b6f8-45c2-9746-93f1a1ad987c

## Contributing

Contributions to this project you always are welcome. Please note the standard guidelines before submitting your pull request.
