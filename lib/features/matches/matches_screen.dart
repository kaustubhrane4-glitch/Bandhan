import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Matches', style: AppTextStyles.h2),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
              Tab(text: 'Mutual'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMatchesList("Received Interests"),
            _buildMatchesList("Sent Interests"),
            _buildMatchesList("Mutual Matches"),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesList(String title) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingPage),
      itemCount: 4,
      itemBuilder: (context, index) => _buildMatchTile(index),
    );
  }

  Widget _buildMatchTile(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage("https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200"),
        ),
        title: const Text('Anjali, 26', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('Software Developer • Mumbai'),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
          ),
          child: const Text('Accept', style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
