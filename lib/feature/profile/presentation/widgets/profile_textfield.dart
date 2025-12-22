import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/auth/presentation/widgets/obscure_toggle_button.dart';

class ProfileTextField extends StatefulWidget {
  const ProfileTextField({
    required this.controller,
    this.errorText,
    this.obscureText = false,
    super.key,
    this.onChanged,
  });

  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  State<ProfileTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<ProfileTextField> {
  late ValueNotifier<bool> obscureNotifier;

  @override
  void initState() {
    super.initState();
    obscureNotifier = ValueNotifier<bool>(widget.obscureText);
  }

  @override
  void dispose() {
    obscureNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureNotifier,
      builder: (final BuildContext context, final bool isObscured, _) {
        return TextField(
          onChanged: widget.onChanged,
          obscureText: isObscured,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: Colors.transparent,
            errorText: widget.errorText,

            /// Label style
            labelStyle: AppTextStyles.hintTxtStyle.copyWith(
              color: context.appColors.permanentBlack,
            ),

            /// Underlines
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.appColors.cCDCDD0,
                width: 1.4,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.appColors.cCDCDD0,
                width: 1.4,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.appColors.red, width: 1.4),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.appColors.red, width: 1.4),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.appColors.royalBlue,
                width: 1.4,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
              maxWidth: 32,
              maxHeight: 32,
            ),
            suffixIcon: widget.obscureText
                ? ObscureToggleButton(
                    isObscured: isObscured,
                    color: context.appColors.darkGrey,
                    onTap: () {
                      obscureNotifier.value = !obscureNotifier.value;
                    },
                  )
                : null,
          ),
          style: AppTextStyles.hintTxtStyle.copyWith(
            color: context.appColors.darkGrey,
          ),
        );
      },
    );
  }
}
