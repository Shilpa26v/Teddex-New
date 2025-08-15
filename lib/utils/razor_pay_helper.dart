import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/pref/app_pref.dart';

class RazorPayHelper {
  final Razorpay _razorpay = Razorpay();
  void Function(String paymentId, String orderId)? onSuccess;
  void Function(String message)? onError;

  RazorPayHelper() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void clear() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    response.success();
    response.orderId.success();
    response.paymentId.success();
    if (response.orderId != null && response.paymentId != null) {
      onSuccess?.call(response.paymentId!, response.orderId!);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //commented by shilpa
    // response.error();
    if (response.message != null) {
      onError?.call(response.message!);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    response.debug();
  }

  void checkout({
    required final String key,
    required final double price,
    required final String currency,
    required final String orderId,
    required final String title,
    required void Function(String paymentId, String orderId) onSuccess,
    void Function(String message)? onError,
  }) {
    final user = AppPref.user!;
    if (user.name == null && user.name == null) return;

    this.onSuccess = onSuccess;
    this.onError = onError;
    var options = {
      'key': key,
      'order_id': orderId,
      'amount': price * 100,
      "currency": currency,
      'name': 'Tedeex',
      'description': title,
      'prefill': {
        if (user.name!.isNotEmpty) 'name': user.name,
        'email': user.email,
        if (user.mobile!.isNotEmpty) 'contact': "+${user.countryCode!} ${user.mobile!}",
      }
    };
    _razorpay.open(options);
  }
}
