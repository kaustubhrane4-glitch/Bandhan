import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerifyScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  void _handleVerify() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      setState(() => _isLoading = true);
      // Simulate verification
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // Navigate to profile setup (placeholder)
      context.go('/'); 
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingPage),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verify your number', style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text(
              'Enter the 6-digit code sent to +91 ${widget.phoneNumber}',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                      if (value.isNotEmpty && index == 5) {
                        _handleVerify();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: _isLoading 
                ? const CircularProgressIndicator(color: AppColors.primary)
                : TextButton(
                    onPressed: () {},
                    child: const Text('Resend OTP', style: TextStyle(color: AppColors.primary)),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
