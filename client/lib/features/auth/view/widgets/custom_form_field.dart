import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscured;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscured = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is empty";
        } else {
          return null;
        }
      },
    );
  }
}
