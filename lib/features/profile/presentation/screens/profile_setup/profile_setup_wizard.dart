import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_text_styles.dart';
import 'step1_basic_info.dart';
import 'step2_background.dart';
import 'step3_career.dart';
import 'step4_photos.dart';
import 'step5_about_preference.dart';
import 'step6_verification.dart';

class ProfileSetupWizard extends StatefulWidget {
  const ProfileSetupWizard({super.key});

  @override
  State<ProfileSetupWizard> createState() => _ProfileSetupWizardState();
}

class _ProfileSetupWizardState extends State<ProfileSetupWizard> {
  int _currentStep = 0;
  final int _totalSteps = 6;
  
  // Step 1 State
  final _step1Key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _dob;
  String? _gender;

  // Step 2 State
  final _step2Key = GlobalKey<FormState>();
  String? _religion;
  String? _motherTongue;
  String? _caste;

  // Step 3 State
  final _step3Key = GlobalKey<FormState>();
  String? _education;
  String? _profession;
  String? _income;

  // Step 4 State
  final List<File> _photos = [];

  // Step 5 State
  final _step5Key = GlobalKey<FormState>();
  final _aboutController = TextEditingController();
  RangeValues _ageRange = const RangeValues(24, 30);
  String? _timeline;

  // Step 6 State
  String? _verificationType;

  void _nextStep() {
    bool isValid = false;
    switch (_currentStep) {
      case 0: isValid = _step1Key.currentState?.validate() ?? false; break;
      case 1: isValid = _step2Key.currentState?.validate() ?? false; break;
      case 2: isValid = _step3Key.currentState?.validate() ?? false; break;
      case 3: isValid = _photos.isNotEmpty; if (!isValid) _showError('At least one photo is required'); break;
      case 4: isValid = _step5Key.currentState?.validate() ?? false; break;
      case 5: isValid = _verificationType != null; if (!isValid) _showError('Please select a verification method'); break;
    }

    if (isValid) {
      if (_currentStep < _totalSteps - 1) {
        setState(() => _currentStep++);
      } else {
        _submitProfile();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
  }

  void _submitProfile() {
    // Show success and go home
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of $_totalSteps', style: AppTextStyles.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: AppColors.border,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingPage),
                child: _buildStepContent(),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Step1BasicInfo(
          formKey: _step1Key,
          nameController: _nameController,
          onDateSelected: (date) => setState(() => _dob = date),
          selectedDate: _dob,
          selectedGender: _gender,
          onGenderSelected: (g) => setState(() => _gender = g),
        );
      case 1:
        return Step2Background(
          formKey: _step2Key,
          religion: _religion,
          motherTongue: _motherTongue,
          caste: _caste,
          onReligionChanged: (v) => setState(() => _religion = v),
          onMotherTongueChanged: (v) => setState(() => _motherTongue = v),
          onCasteChanged: (v) => _caste = v,
        );
      case 2:
        return Step3Career(
          formKey: _step3Key,
          education: _education,
          profession: _profession,
          income: _income,
          onEducationChanged: (v) => setState(() => _education = v),
          onProfessionChanged: (v) => setState(() => _profession = v),
          onIncomeChanged: (v) => setState(() => _income = v),
        );
      case 3:
        return Step4Photos(
          photos: _photos,
          onPhotoAdded: (file) => setState(() => _photos.add(file)),
          onPhotoRemoved: (index) => setState(() => _photos.removeAt(index)),
        );
      case 4:
        return Step5AboutPreferences(
          formKey: _step5Key,
          aboutController: _aboutController,
          ageRange: _ageRange,
          onAgeRangeChanged: (v) => setState(() => _ageRange = v),
          marriageTimeline: _timeline,
          onTimelineChanged: (v) => setState(() => _timeline = v),
        );
      case 5:
        return Step6Verification(
          selectedType: _verificationType,
          onVerificationTypeSelected: (v) => setState(() => _verificationType = v),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingPage),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
              ),
              child: Text(_currentStep == _totalSteps - 1 ? 'Complete Setup' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
