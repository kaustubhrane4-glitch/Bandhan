import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile', style: AppTextStyles.h2)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingPage),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildCompletionCard(),
            const SizedBox(height: 24),
            _buildMenuSection("Account Settings", [
              _menuItem(Icons.person_outline, "Edit Profile"),
              _menuItem(Icons.verified_user_outlined, "Verification Status", trailing: _badge("Verified", AppColors.success)),
              _menuItem(Icons.star_outline, "Premium Plan", trailing: _badge("Free", AppColors.textMuted)),
            ]),
            const SizedBox(height: 24),
            _buildMenuSection("Family Mode", [
              _menuItem(Icons.family_restroom, "Family Login Link", subtitle: "Share profile with parents"),
              _menuItem(Icons.visibility_outlined, "Who viewed my profile"),
            ]),
            const SizedBox(height: 24),
            _buildMenuSection("Support", [
              _menuItem(Icons.help_outline, "Help & FAQ"),
              _menuItem(Icons.security, "Privacy Policy"),
              _menuItem(Icons.logout, "Logout", textColor: AppColors.error),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200"),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Rahul Kumar', style: AppTextStyles.h2),
        const Text('rahul.k@example.com', style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Profile Completion', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('70%', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: AppColors.border,
            color: AppColors.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
            child: const Text('Complete missing info to get 3x more matches >', style: TextStyle(fontSize: 12, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, {String? subtitle, Widget? trailing, Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
      title: Text(title, style: TextStyle(color: textColor ?? AppColors.textPrimary, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.caption) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: AppColors.border),
      onTap: () {},
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
