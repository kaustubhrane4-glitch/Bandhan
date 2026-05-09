import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_text_styles.dart';

class Step3Career extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? education;
  final String? profession;
  final String? income;
  final Function(String?) onEducationChanged;
  final Function(String?) onProfessionChanged;
  final Function(String?) onIncomeChanged;

  const Step3Career({
    super.key,
    required this.formKey,
    this.education,
    this.profession,
    this.income,
    required this.onEducationChanged,
    required this.onProfessionChanged,
    required this.onIncomeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Education & Career', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          const Text('Your professional journey is an important part of your identity.', style: AppTextStyles.body),
          const SizedBox(height: 32),
          DropdownButtonFormField<String>(
            value: education,
            decoration: InputDecoration(
              labelText: 'Highest Education',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            items: ['Bachelors', 'Masters', 'PhD', 'MBA', 'MBBS', 'CA', 'Others']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onEducationChanged,
            validator: (value) => value == null ? 'Please select education' : null,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: profession,
            decoration: InputDecoration(
              labelText: 'Profession',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            items: ['Software Engineer', 'Doctor', 'Manager', 'Business Owner', 'Teacher', 'Designer', 'Other']
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: onProfessionChanged,
            validator: (value) => value == null ? 'Please select profession' : null,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: income,
            decoration: InputDecoration(
              labelText: 'Annual Income (LPA)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            items: ['0-5 LPA', '5-10 LPA', '10-20 LPA', '20-40 LPA', '40-70 LPA', '70+ LPA']
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
            onChanged: onIncomeChanged,
            validator: (value) => value == null ? 'Please select income range' : null,
          ),
        ],
      ),
    );
  }
}
