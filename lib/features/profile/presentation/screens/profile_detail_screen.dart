import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingPage),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildAboutSection(),
                  const SizedBox(height: 24),
                  _buildInfoGrid(),
                  const SizedBox(height: 24),
                  _buildPreferencesSection(),
                  const SizedBox(height: 100), // Spacer for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomActions(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Priya Sharma, 27', style: AppTextStyles.h1),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: AppColors.success, size: 24),
          ],
        ),
        const SizedBox(height: 4),
        const Text('Software Engineer • Mumbai', style: AppTextStyles.body),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text('92% Compatibility', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About Me', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text(
          'I am a passionate software engineer who loves solving complex problems. In my free time, I enjoy reading, traveling, and experimenting with new recipes. I value honesty and a good sense of humor.',
          style: AppTextStyles.body.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _infoChip(Icons.home, "Hindu, Brahmin"),
        _infoChip(Icons.language, "Marathi, English"),
        _infoChip(Icons.school, "B.Tech, IIT Bombay"),
        _infoChip(Icons.work, "Google, 25 LPA"),
        _infoChip(Icons.height, "165 cm"),
        _infoChip(Icons.restaurant, "Vegetarian"),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.body.copyWith(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Partner Preferences', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        _preferenceRow("Age", "25 - 30 years"),
        _preferenceRow("Religion", "Hindu"),
        _preferenceRow("Education", "Masters or PhD"),
        _preferenceRow("City", "Mumbai, Pune, Bangalore"),
      ],
    );
  }

  Widget _preferenceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                ),
                child: const Text('Pass', style: TextStyle(color: AppColors.textMuted)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                ),
                child: const Text('Send Interest', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
