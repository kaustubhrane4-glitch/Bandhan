abstract class PremiumRepository {
  Future<String> createRazorpayOrder(String plan);
  Future<bool> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String plan,
  });
}
