import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/phone_login_screen.dart';
import '../features/auth/presentation/screens/otp_verify_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/presentation/screens/profile_setup/profile_setup_wizard.dart';
import '../features/discover/discover_screen.dart';
import '../features/matches/matches_screen.dart';
import '../features/messaging/conversation_list_screen.dart';
import '../features/profile/presentation/screens/my_profile_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpVerifyScreen(
          phoneNumber: state.extra as String? ?? '',
        ),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const ProfileSetupWizard(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/discover',
        builder: (context, state) => const DiscoverScreen(),
      ),
      GoRoute(
        path: '/matches',
        builder: (context, state) => const MatchesScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ConversationListScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const MyProfileScreen(),
      ),
    ],
  );
}
