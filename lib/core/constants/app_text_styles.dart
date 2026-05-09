import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const h1 = TextStyle(
    fontSize: 28, 
    fontWeight: FontWeight.w700, 
    fontFamily: 'Poppins',
    color: AppColors.textPrimary,
  );
  static const h2 = TextStyle(
    fontSize: 22, 
    fontWeight: FontWeight.w600, 
    fontFamily: 'Poppins',
    color: AppColors.textPrimary,
  );
  static const h3 = TextStyle(
    fontSize: 18, 
    fontWeight: FontWeight.w600, 
    fontFamily: 'Poppins',
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.w400, 
    fontFamily: 'Inter',
    color: AppColors.textPrimary,
  );
  static const caption = TextStyle(
    fontSize: 12, 
    fontWeight: FontWeight.w400, 
    fontFamily: 'Inter', 
    color: AppColors.textMuted,
  );
  static const button = TextStyle(
    fontSize: 15, 
    fontWeight: FontWeight.w600, 
    fontFamily: 'Poppins',
    color: Colors.white,
  );
}
