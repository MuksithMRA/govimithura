import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const PrimaryTextField(
      {super.key,
      this.onChanged,
      required this.label,
      this.prefixIcon,
      this.suffixIcon});

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    InputDecorationTheme inputDecorationTheme =
        Theme.of(context).inputDecorationTheme;
    return TextFormField(
      onChanged: (value) {},
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
