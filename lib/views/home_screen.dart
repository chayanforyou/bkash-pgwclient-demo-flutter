import 'dart:developer';

import 'package:flutter/material.dart';

import '../api/bkash_api.dart';
import '../models/payment_response.dart';
import '../models/payment_status.dart';
import '../utils/exception.dart';
import '../utils/utils.dart';
import 'payment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _invoiceController = TextEditingController();
  bool _isLoading = false;

  void showLoader() {
    setState(() => _isLoading = true);
  }

  void hideLoader() {
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bKash Demo')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "1500",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "01700000000",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Invoice Number', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _invoiceController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "invoice01",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      child: const Text("Checkout"),
                      onPressed: () async {
                        // Hide the keyboard
                        FocusScope.of(context).unfocus();

                        String amount = _amountController.text.trim();
                        String phoneNumber = _phoneController.text.trim();
                        String invoiceNumber = _invoiceController.text.trim();
                        if (amount.isEmpty) {
                          Utils.showSnackBar(message: "Amount is empty. You can't pay through bkash.");
                          return;
                        }

                        try {
                          showLoader();
                          final result = await makePayment(
                            amount: amount,
                            payerReference: phoneNumber.isNotEmpty ? phoneNumber : ' ',
                            merchantInvoiceNumber: invoiceNumber.isNotEmpty ? invoiceNumber : 'invoice01',
                          );

                          hideLoader();
                          // Print the payment response
                          log(result.toString());
                          Utils.showSnackBar(message: '(Payment Successful) tranId: ${result.trxId}');
                        } on PaymentException catch (e) {
                          hideLoader();
                          // Show error message
                          Utils.showSnackBar(message: e.message);
                        } catch (e, s) {
                          hideLoader();
                          log("Unknown exception: ", error: e, stackTrace: s);
                          Utils.showSnackBar(message: 'Something went wrong');
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<PaymentResponse> makePayment({
    required String amount,
    required String payerReference,
    required String merchantInvoiceNumber
  }) async {
    return bkashApi.createPayment(
      amount: amount,
      payerReference: payerReference,
      merchantInvoiceNumber: merchantInvoiceNumber
    ).then((resp) async {
      if (resp.statusCode != '0000') {
        throw PaymentException(message: resp.statusMessage);
      }

      final paymentStatus = await Navigator.push<PaymentStatus>(
              context,
              MaterialPageRoute(
                  builder: (_) => PaymentScreen(
                        bkashURL: resp.bkashURL,
                        failureCallbackURL: resp.failureCallbackURL,
                        successCallbackURL: resp.successCallbackURL,
                        cancelledCallbackURL: resp.cancelledCallbackURL,
                      ))) ??
          PaymentStatus.canceled;

      switch (paymentStatus) {
        case PaymentStatus.success:
          final result = await bkashApi.executePayment(paymentId: resp.paymentID);
          if (result.statusCode != '0000') {
            throw PaymentException(message: result.statusMessage);
          }

          return PaymentResponse(
            trxId: result.trxID,
            paymentId: result.paymentID,
            executeTime: result.paymentExecuteTime,
            payerReference: result.payerReference,
            customerMsisdn: result.customerMsisdn,
            merchantInvoiceNumber: result.merchantInvoiceNumber,
          );
        case PaymentStatus.canceled:
          throw PaymentException(message: "Payment Cancelled");
        default:
          throw PaymentException(message: "Payment Failed");
      }
    });
  }
}
