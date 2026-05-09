import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Show splash for 1.5s
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    
    // TODO: Check auth session and profile completeness
    // For now, go to onboarding
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Bandhan',
              style: AppTextStyles.h1.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Find your person. The right way.',
              style: AppTextStyles.body.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
