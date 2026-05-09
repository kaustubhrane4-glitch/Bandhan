import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/app_text_styles.dart';

class Step4Photos extends StatefulWidget {
  final List<File> photos;
  final Function(File) onPhotoAdded;
  final Function(int) onPhotoRemoved;

  const Step4Photos({
    super.key,
    required this.photos,
    required this.onPhotoAdded,
    required this.onPhotoRemoved,
  });

  @override
  State<Step4Photos> createState() => _Step4PhotosState();
}

class _Step4PhotosState extends State<Step4Photos> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Compress image
    );
    if (image != null) {
      widget.onPhotoAdded(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add Photos', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        const Text(
          'Profiles with at least 2 photos get 3x more interests. Add clear, recent photos.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: 6, // Max 6 photos
          itemBuilder: (context, index) {
            if (index < widget.photos.length) {
              return _buildPhotoTile(index);
            }
            if (index == widget.photos.length) {
              return _buildAddTile();
            }
            return _buildEmptyTile();
          },
        ),
      ],
    );
  }

  Widget _buildPhotoTile(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            image: DecorationImage(
              image: FileImage(widget.photos[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => widget.onPhotoRemoved(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
        if (index == 0)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusMd),
                  bottomRight: Radius.circular(AppDimensions.radiusMd),
                ),
              ),
              child: const Text(
                'Main',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddTile() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
        ),
        child: const Icon(Icons.add_a_photo, color: AppColors.primary),
      ),
    );
  }

  Widget _buildEmptyTile() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Icon(Icons.image, color: AppColors.border.withOpacity(0.5)),
    );
  }
}
