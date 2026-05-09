import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_text_styles.dart';

class Step2Background extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? religion;
  final String? motherTongue;
  final String? caste;
  final Function(String?) onReligionChanged;
  final Function(String?) onMotherTongueChanged;
  final Function(String) onCasteChanged;

  const Step2Background({
    super.key,
    required this.formKey,
    this.religion,
    this.motherTongue,
    this.caste,
    required this.onReligionChanged,
    required this.onMotherTongueChanged,
    required this.onCasteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Background Details', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          const Text('Your religious and cultural background helps in finding better matches.', style: AppTextStyles.body),
          const SizedBox(height: 32),
          DropdownButtonFormField<String>(
            value: religion,
            decoration: InputDecoration(
              labelText: 'Religion',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            items: ['Hindu', 'Muslim', 'Sikh', 'Christian', 'Jain', 'Buddhist', 'Other']
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: onReligionChanged,
            validator: (value) => value == null ? 'Please select religion' : null,
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: caste,
            decoration: InputDecoration(
              labelText: 'Caste / Community (Optional)',
              hintText: 'e.g. Brahmin, Sunni, etc.',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            onChanged: onCasteChanged,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: motherTongue,
            decoration: InputDecoration(
              labelText: 'Mother Tongue',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            items: ['Hindi', 'English', 'Marathi', 'Bengali', 'Tamil', 'Telugu', 'Gujarati', 'Kannada', 'Malayalam', 'Punjabi']
                .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                .toList(),
            onChanged: onMotherTongueChanged,
            validator: (value) => value == null ? 'Please select mother tongue' : null,
          ),
        ],
      ),
    );
  }
}
