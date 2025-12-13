import 'dart:io';
import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    required this.onTap, super.key,
    this.imagePath,
    this.fileImage,
    this.isAsset = true,
    this.size = 48,
    this.borderRadius = 12,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(12),
  });

  /// Use this when selected image comes from file picker
  final File? fileImage;

  /// Use this for assets or network images
  final String? imagePath;
  final bool isAsset;

  final double size;
  final double borderRadius;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final EdgeInsets padding;

  @override
  Widget build(final BuildContext context) {
    ImageProvider? provider;

    if (fileImage != null) {
      provider = FileImage(fileImage!);
    } else if (imagePath != null) {
      provider = isAsset
          ? AssetImage(imagePath!)
          : NetworkImage(imagePath!) as ImageProvider;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade200,
          borderRadius: BorderRadius.circular(borderRadius),
          image: provider != null
              ? DecorationImage(
            image: provider,
            fit: BoxFit.cover,
          )
              : null,
        ),
        height: size,
        width: size,
        child: provider == null
            ? const Icon(
          Icons.image,
          size: 24,
          color: Colors.grey,
        )
            : null,
      ),
    );
  }
}
