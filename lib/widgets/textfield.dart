import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isObscureText,
    required this.textInputAction,
    required this.keyboardType,
    required this.validator,
  });
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      style: const TextStyle(
        fontSize: 18,
      ),
      validator: validator,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      obscureText: isObscureText,
    );
  }
}
