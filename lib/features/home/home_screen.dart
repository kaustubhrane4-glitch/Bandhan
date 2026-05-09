import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/profile_card.dart';
import '../../shared/widgets/error_view.dart';
import '../profile/presentation/providers/profile_provider.dart';
import '../../shared/widgets/shimmer_loading.dart'; // I need to create this

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyMatches = ref.watch(dailyMatchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bandhan', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('2'),
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: dailyMatches.when(
        loading: () => const ShimmerLoading(),
        error: (err, stack) => ErrorView(message: err.toString(), onRetry: () => ref.refresh(dailyMatchesProvider)),
        data: (matches) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingPage),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Today's Matches", "${matches.length} matches found"),
              const SizedBox(height: 16),
              if (matches.isEmpty)
                const Center(child: Text("No matches today. Check back later!"))
              else
                ...matches.map((match) => ProfileCard(
                  name: match.fullName,
                  age: DateTime.now().year - match.dateOfBirth.year,
                  city: match.city,
                  profession: match.profession,
                  imageUrl: match.profilePhotoUrl,
                  aiScore: 85, // Logic for this would be in the model or a separate provider
                  aiReason: match.aboutMe,
                  isVerified: match.isVerified,
                  onTap: () {},
                )),
              const SizedBox(height: 24),
              _buildSectionHeader("Recently Active", "Profiles online now"),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) => _buildActiveAvatar(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3),
        Text(subtitle, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildActiveAvatar() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.border,
              backgroundImage: const NetworkImage("https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200"),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Meera', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
