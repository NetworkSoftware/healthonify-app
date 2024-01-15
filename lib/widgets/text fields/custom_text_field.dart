import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final Color? areaColor;
  final Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Color hintBorderColor;
  final TextInputType? keyboard;
  final bool? isEnabled;
  final int? maxLines;
  final Widget? suffixIcon;
  final String? initialValue;
  const CustomTextField({
    required this.hint,
    required this.hintBorderColor,
    this.areaColor,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.controller,
    this.maxLines,
    this.isEnabled,
    this.keyboard,
    this.suffixIcon,
    this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int textFieldSize = maxLines ?? 1;
    return TextFormField(
      initialValue: initialValue,
      enabled: isEnabled,
      keyboardType: keyboard,
      textCapitalization: TextCapitalization.words,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: false,
        enabledBorder: textFieldSize >= 2
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: hintBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hintBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
        focusedBorder: textFieldSize >= 2
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: hintBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hintBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
        errorBorder: textFieldSize >= 2
            ? OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : UnderlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
        disabledBorder: textFieldSize >= 2
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: hintBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hintBorderColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: areaColor ?? hintBorderColor,
            ),
        contentPadding: textFieldSize >= 2
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 10),
        suffixIcon: suffixIcon,
      ),
      style: Theme.of(context).textTheme.bodySmall,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      controller: controller,
    );
  }
}
