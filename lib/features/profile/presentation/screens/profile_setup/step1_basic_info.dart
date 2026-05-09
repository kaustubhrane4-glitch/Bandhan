import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_text_styles.dart';

class Step1BasicInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final String? selectedGender;
  final Function(String?) onGenderSelected;

  const Step1BasicInfo({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.onDateSelected,
    this.selectedDate,
    this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Basic Information', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          const Text('Tell us a bit about yourself to get started.', style: AppTextStyles.body),
          const SizedBox(height: 32),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Name is required' : null,
          ),
          const SizedBox(height: 24),
          const Text('Gender', style: AppTextStyles.body),
          const SizedBox(height: 8),
          Row(
            children: [
              _genderChip('Male', 'male'),
              const SizedBox(width: 12),
              _genderChip('Female', 'female'),
            ],
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
                firstDate: DateTime.now().subtract(const Duration(days: 365 * 50)),
                lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              );
              if (date != null) onDateSelected(date);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
              ),
              child: Text(
                selectedDate == null 
                    ? 'Select Date' 
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                style: AppTextStyles.body,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderChip(String label, String value) {
    final isSelected = selectedGender == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onGenderSelected(selected ? value : null),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
