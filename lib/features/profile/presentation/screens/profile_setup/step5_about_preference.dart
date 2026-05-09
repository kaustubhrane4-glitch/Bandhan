import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_text_styles.dart';

class Step5AboutPreferences extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController aboutController;
  final RangeValues ageRange;
  final Function(RangeValues) onAgeRangeChanged;
  final String? marriageTimeline;
  final Function(String?) onTimelineChanged;

  const Step5AboutPreferences({
    super.key,
    required this.formKey,
    required this.aboutController,
    required this.ageRange,
    required this.onAgeRangeChanged,
    this.marriageTimeline,
    required this.onTimelineChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About & Preferences', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          const Text('Describe yourself and what you are looking for in a partner.', style: AppTextStyles.body),
          const SizedBox(height: 32),
          TextFormField(
            controller: aboutController,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              labelText: 'About Me',
              hintText: 'Share your interests, values, and what makes you unique...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ),
            validator: (value) => (value == null || value.length < 50) ? 'Please write at least 50 characters' : null,
          ),
          const SizedBox(height: 32),
          const Text('Marriage Timeline', style: AppTextStyles.body),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _timelineChip('Within 6 months', 'within_6_months'),
              _timelineChip('Within 1 year', 'within_1_year'),
              _timelineChip('Within 2 years', 'within_2_years'),
              _timelineChip('Not sure', 'not_sure'),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Partner Age Preference', style: AppTextStyles.body),
              Text('${ageRange.start.round()} - ${ageRange.end.round()}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          RangeSlider(
            values: ageRange,
            min: 21,
            max: 50,
            divisions: 29,
            activeColor: AppColors.primary,
            labels: RangeLabels(ageRange.start.round().toString(), ageRange.end.round().toString()),
            onChanged: onAgeRangeChanged,
          ),
        ],
      ),
    );
  }

  Widget _timelineChip(String label, String value) {
    final isSelected = marriageTimeline == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onTimelineChanged(selected ? value : null),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}
