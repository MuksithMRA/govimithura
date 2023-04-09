import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool isPassword;
  final String? initialValue;
  final String? label;
  final TextEditingController? controller;
  final Function()? onTap;
  final bool isFilled;
  const PrimaryTextField({
    super.key,
    this.onChanged,
    this.hintText = "",
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.isPassword = false,
    this.initialValue,
    this.label,
    this.controller,
    this.onTap,
    this.isFilled = false,
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
      onTap: widget.onTap,
      initialValue: widget.initialValue,
      controller: widget.controller,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        filled: widget.isFilled,
        label: widget.label != null ? Text(widget.label!) : null,
        border:
            widget.isFilled ? InputBorder.none : inputDecorationTheme.border,
        focusedBorder: widget.isFilled
            ? InputBorder.none
            : inputDecorationTheme.focusedBorder,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        focusColor: inputDecorationTheme.focusColor,
      ),
    );
  }
}
