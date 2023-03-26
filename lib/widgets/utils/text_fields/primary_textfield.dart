import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool isPassword;
  final String? initialValue;
  const PrimaryTextField({
    super.key,
    this.onChanged,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.isPassword = false,
    this.initialValue,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    InputDecorationTheme inputDecorationTheme =
        Theme.of(context).inputDecorationTheme;
    return TextFormField(
      initialValue: widget.initialValue,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        border: inputDecorationTheme.border,
        hintText: widget.label,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        focusColor: inputDecorationTheme.focusColor,
      ),
    );
  }
}
