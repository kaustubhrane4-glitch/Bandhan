import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages', style: AppTextStyles.h2),
      ),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) => _buildConversationTile(context, index),
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, int index) {
    final names = ["Meera", "Kajal", "Priya", "Ananya", "Riya"];
    final messages = ["Hey, I really liked your profile!", "Hello!", "How are you doing?", "Can we talk more?", "Hi!"];
    
    return ListTile(
      onTap: () {
        // Navigate to chat
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingPage, vertical: 8),
      leading: Stack(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200"),
          ),
          if (index % 2 == 0)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(names[index], style: AppTextStyles.h3.copyWith(fontSize: 16)),
      subtitle: Text(
        messages[index],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body.copyWith(color: index == 0 ? AppColors.textPrimary : AppColors.textMuted, fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('2:30 PM', style: AppTextStyles.caption),
          const SizedBox(height: 4),
          if (index == 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
