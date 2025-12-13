import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routiner/feature/common/presentation/widgets/image_button.dart';

class SelectProfileImageButton extends StatefulWidget {
  const SelectProfileImageButton({super.key});

  @override
  State<SelectProfileImageButton> createState() =>
      _SelectProfileImageButtonState();
}

class _SelectProfileImageButtonState extends State<SelectProfileImageButton> {
  File? selectedImage;

  Future<void> pickImage() async {
    final XFile? result =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result != null) {
      setState(() {
        selectedImage = File(result.path);
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ImageButton(
      onTap: pickImage,
      size: 120,
      borderRadius: 60,
      fileImage: selectedImage,
      imagePath: selectedImage == null ? null : null,
      isAsset: false,
      backgroundColor: Colors.grey.shade200,
      padding: EdgeInsets.zero,
    );
  }
}
