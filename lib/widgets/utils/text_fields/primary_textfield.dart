import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  const PrimaryTextField(
      {super.key,
      this.onChanged,
      required this.label,
      this.prefixIcon,
      this.suffixIcon,
      this.validator});

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    InputDecorationTheme inputDecorationTheme =
        Theme.of(context).inputDecorationTheme;
    return TextFormField(
      onChanged: widget.onChanged,
      validator: widget.validator,
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
