import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/premium_repository.dart';
import '../../../../core/errors/error_handler.dart';

class PremiumRepositoryImpl with SafeCallMixin implements PremiumRepository {
  final SupabaseClient _client;

  PremiumRepositoryImpl(this._client);

  @override
  Future<String> createRazorpayOrder(String plan) => safeCall(() async {
    final response = await _client.functions.invoke(
      'create-razorpay-order',
      body: {'plan': plan},
    );
    return response.data['order_id'];
  });

  @override
  Future<bool> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String plan,
  }) => safeCall(() async {
    final response = await _client.functions.invoke(
      'verify-payment',
      body: {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
        'plan': plan,
      },
    );
    return response.data['success'] == true;
  });
}
