import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/auth/presentation/widgets/clear_button.dart';
import 'package:routiner/feature/auth/presentation/widgets/obscure_toggle_button.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
    this.enabled = true,
    this.onSubmitted,
    this.hintText,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.hintStyle,
    this.keyboardType,
    super.key,
  });

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  late ValueNotifier<bool> obscureNotifier;
  late ValueNotifier<bool> showClear;

  @override
  void initState() {
    super.initState();
    obscureNotifier = ValueNotifier<bool>(widget.obscureText);
    showClear = ValueNotifier<bool>(widget.controller.text.isNotEmpty);

    // Add listener to controller
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Check if widget is still mounted before updating
    if (mounted) {
      showClear.value = widget.controller.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    // Remove listener BEFORE disposing
    widget.controller.removeListener(_onTextChanged);
    obscureNotifier.dispose();
    showClear.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureNotifier,
      builder: (final BuildContext context, final bool isObscured, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: showClear,
          builder:
              (
                final BuildContext context,
                final bool shouldShowClear,
                final __,
              ) {
                return TextField(
                  controller: widget.controller,
                  obscureText: isObscured,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  enabled: widget.enabled,
                  cursorColor: context.appColors.black,
                  cursorHeight: 16,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    counterText: "",
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: Colors.transparent,
                    errorText: widget.errorText,
                    hintStyle:
                        widget.hintStyle ??
                        AppTextStyles.airbnbCerealW500S18Lh24.copyWith(
                          color: context.appColors.cCDCDD0,
                        ),
                    labelStyle: AppTextStyles.hintTxtStyle.copyWith(
                      color: context.appColors.permanentBlack,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.cCDCDD0,
                        width: 1.4,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.c3BA935,
                        width: 2,
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                      maxWidth: 20,
                      maxHeight: 20,
                    ),
                    suffixIcon: widget.obscureText
                        ? ObscureToggleButton(
                            isObscured: isObscured,
                            color: context.appColors.darkGrey,
                            onTap: () {
                              obscureNotifier.value = !obscureNotifier.value;
                            },
                          )
                        : shouldShowClear
                        ? ClearButton(
                            onTap: () {
                              widget.controller.clear();
                              showClear.value = false;
                            },
                            iconColor: context.appColors.black,
                            backgroundColor: context.appColors.cCDCDD0,
                          )
                        : null,
                  ),
                  style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                    color: context.appColors.black,
                  ),
                );
              },
        );
      },
    );
  }
}
