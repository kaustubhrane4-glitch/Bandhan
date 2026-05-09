import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_colors.dart';

class BandhanApp extends StatelessWidget {
  const BandhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bandhan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.surface,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Poppins'),
          displayMedium: TextStyle(fontFamily: 'Poppins'),
          displaySmall: TextStyle(fontFamily: 'Poppins'),
          headlineLarge: TextStyle(fontFamily: 'Poppins'),
          headlineMedium: TextStyle(fontFamily: 'Poppins'),
          headlineSmall: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
