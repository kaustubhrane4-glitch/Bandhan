import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  const ChatScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage("https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200"),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Online', style: TextStyle(fontSize: 12, color: AppColors.success)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingPage),
              children: [
                _buildMessageBubble("Hey there! I really liked your profile and interests.", false),
                _buildMessageBubble("Hi! Thank you so much. I liked yours too! 😊", true),
                _buildMessageBubble("What do you do for work?", false),
                _buildMessageBubble("I am a Software Engineer at Google.", true),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.border.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppDimensions.radiusMd),
            topRight: const Radius.circular(AppDimensions.radiusMd),
            bottomLeft: Radius.circular(isMe ? AppDimensions.radiusMd : 0),
            bottomRight: Radius.circular(isMe ? 0 : AppDimensions.radiusMd),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: AppColors.border.withOpacity(0.2),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
