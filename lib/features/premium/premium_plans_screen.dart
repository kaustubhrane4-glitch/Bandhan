import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'presentation/providers/premium_provider.dart'; // I need to create this

class PremiumPlansScreen extends ConsumerStatefulWidget {
  const PremiumPlansScreen({super.key});

  @override
  ConsumerState<PremiumPlansScreen> createState() => _PremiumPlansScreenState();
}

class _PremiumPlansScreenState extends ConsumerState<PremiumPlansScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Call repository to verify
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed: ${response.message}")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Plans', style: AppTextStyles.h2)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingPage),
        child: Column(
          children: [
            _buildPlanCard(
              context,
              title: "Free",
              price: "₹0",
              features: ["Daily 3 matches", "Basic search", "Limited interests"],
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context,
              title: "Premium",
              price: "₹999/mo",
              features: ["Daily 10 matches", "Advanced filters", "Unlimited interests", "Verified badge priority", "See who liked you"],
              color: Colors.amber[700]!,
              isPopular: true,
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              context,
              title: "Concierge",
              price: "₹4,999/mo",
              features: ["Personal matchmaker", "Hand-picked profiles", "Background checks", "24/7 Support", "Profile boost"],
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required Color color,
    bool isPopular = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: isPopular ? Border.all(color: color, width: 2) : Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMd)),
              ),
              child: const Text(
                'MOST POPULAR',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTextStyles.h2.copyWith(color: color)),
                    Text(price, style: AppTextStyles.h2),
                  ],
                ),
                const SizedBox(height: 24),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: color, size: 20),
                      const SizedBox(width: 12),
                      Text(f, style: AppTextStyles.body),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                    ),
                    child: Text('Get $title', style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
