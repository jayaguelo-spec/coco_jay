import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
