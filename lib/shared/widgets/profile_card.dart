import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final int age;
  final String city;
  final String profession;
  final String? imageUrl;
  final int? aiScore;
  final String? aiReason;
  final bool isVerified;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.name,
    required this.age,
    required this.city,
    required this.profession,
    this.imageUrl,
    this.aiScore,
    this.aiReason,
    this.isVerified = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
                    image: imageUrl != null
                        ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                        : null,
                    color: AppColors.border.withOpacity(0.3),
                  ),
                  child: imageUrl == null ? const Center(child: Icon(Icons.person, size: 80, color: Colors.white)) : null,
                ),
                if (aiScore != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _buildAiBadge(),
                  ),
                if (isVerified)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: _buildVerifiedBadge(),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name, $age',
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        Text(
                          '$profession • $city',
                          style: AppTextStyles.body.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (aiReason != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text('Why this match?', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      aiReason!,
                      style: AppTextStyles.body.copyWith(fontSize: 13, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, color: AppColors.primary, size: 14),
          const SizedBox(width: 4),
          Text(
            '$aiScore%',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(
            'Verified',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
