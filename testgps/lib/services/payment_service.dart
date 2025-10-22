import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  static const String _stripePublishableKey = 'pk_test_...'; // Replace with your Stripe publishable key
  
  static Future<void> initializeStripe() async {
    Stripe.publishableKey = _stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  static Future<PaymentResult> processPayment({
    required String amount,
    required String currency,
    required String description,
  }) async {
    try {
      // Create payment intent on your backend
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('createPaymentIntent');
      
      final result = await callable.call({
        'amount': amount,
        'currency': currency,
        'description': description,
      });

      final clientSecret = result.data['clientSecret'] as String;

      // Confirm payment with Stripe
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(),
          ),
        ),
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        // Save Pro status locally
        await _saveProStatus(true);
        return PaymentResult.success();
      } else {
        return PaymentResult.failure('Payment failed: ${paymentIntent.status}');
      }
    } catch (e) {
      return PaymentResult.failure('Payment error: $e');
    }
  }

  static Future<bool> isProUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_pro_user') ?? false;
  }

  static Future<void> _saveProStatus(bool isPro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pro_user', isPro);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_pro_user');
  }
}

class PaymentResult {
  final bool isSuccess;
  final String? errorMessage;

  PaymentResult._(this.isSuccess, this.errorMessage);

  factory PaymentResult.success() => PaymentResult._(true, null);
  factory PaymentResult.failure(String error) => PaymentResult._(false, error);
}
