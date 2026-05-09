import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover', style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingPage),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: 10,
              itemBuilder: (context, index) => _buildProfileGridCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingPage, vertical: 8),
      child: Row(
        children: [
          _filterChip("Age: 24-28"),
          _filterChip("City: Mumbai"),
          _filterChip("Religion: Hindu"),
          _filterChip("Verified only"),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.close, size: 14, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildProfileGridCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kajal, 25',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Designer • Delhi',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 8,
            left: 8,
            child: Icon(Icons.verified, color: AppColors.success, size: 16),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters', style: AppTextStyles.h2),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Reset')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Age Range', style: AppTextStyles.body),
            RangeSlider(
              values: const RangeValues(24, 30),
              min: 21,
              max: 50,
              divisions: 29,
              activeColor: AppColors.primary,
              labels: const RangeLabels('24', '30'),
              onChanged: (v) {},
            ),
            const SizedBox(height: 24),
            const Text('Religion', style: AppTextStyles.body),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(label: const Text('Hindu'), selected: true, onSelected: (v) {}),
                FilterChip(label: const Text('Muslim'), selected: false, onSelected: (v) {}),
                FilterChip(label: const Text('Sikh'), selected: false, onSelected: (v) {}),
                FilterChip(label: const Text('Christian'), selected: false, onSelected: (v) {}),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
