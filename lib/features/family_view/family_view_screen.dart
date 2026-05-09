import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class FamilyViewScreen extends StatelessWidget {
  final String token;
  const FamilyViewScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Preview', style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingPage),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWatermark(),
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400"),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Column(
                    children: [
                      Text('Priya Sharma', style: AppTextStyles.h2),
                      Text('Software Engineer • Mumbai', style: AppTextStyles.body),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),
                const Text('About the Match', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                const Text(
                  'Priya is a well-educated professional currently working in Mumbai. She comes from a middle-class background with strong family values.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 24),
                _buildInfoRow("Education", "B.Tech, IIT Bombay"),
                _buildInfoRow("Religion", "Hindu, Brahmin"),
                _buildInfoRow("Marriage Timeline", "Within 1 year"),
                const SizedBox(height: 40),
                _buildSafetyNotice(),
              ],
            ),
          ),
          _buildWatermarkOverlay(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWatermark() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: const Row(
        children: [
          Icon(Icons.family_restroom, color: AppColors.primary, size: 16),
          SizedBox(width: 8),
          Text('FAMILY READ-ONLY VIEW', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSafetyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          const Icon(Icons.security, color: AppColors.textMuted),
          const SizedBox(height: 8),
          const Text(
            'This link is private and will expire in 30 days. For security reasons, contact details are hidden.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildWatermarkOverlay() {
    return IgnorePointer(
      child: Center(
        child: RotationTransition(
          turns: const AlwaysStoppedAnimation(-45 / 360),
          child: Text(
            'BANDHAN FAMILY VIEW',
            style: TextStyle(
              color: Colors.grey.withOpacity(0.1),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
