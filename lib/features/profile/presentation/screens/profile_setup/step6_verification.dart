import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_text_styles.dart';

class Step6Verification extends StatefulWidget {
  final Function(String) onVerificationTypeSelected;
  final String? selectedType;

  const Step6Verification({
    super.key,
    required this.onVerificationTypeSelected,
    this.selectedType,
  });

  @override
  State<Step6Verification> createState() => _Step6VerificationState();
}

class _Step6VerificationState extends State<Step6Verification> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Get Verified', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        const Text(
          'Verified profiles get 3x more responses and higher trust. Choose a method to verify your identity.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 32),
        _buildOption(
          'aadhaar',
          'Aadhaar Verification',
          'Fastest way to get the verified badge. Upload a clear photo of your Aadhaar.',
          Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        _buildOption(
          'linkedin',
          'LinkedIn Verification',
          'Verify via your professional network. We will check your profile link.',
          Icons.link,
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.border.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your documents are stored securely and never shared with other users.',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(String type, String title, String subtitle, IconData icon) {
    final isSelected = widget.selectedType == type;
    return GestureDetector(
      onTap: () => widget.onVerificationTypeSelected(type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
