import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isObscureText,
    required this.textInputAction,
    required this.keyboardType,
    required this.validator,
    this.maxLines = 1,
    this.maxcharacters,
  });
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final int maxLines;
  final int? maxcharacters;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      style: const TextStyle(
        fontSize: 18,
      ),
      maxLines: maxLines,
      inputFormatters: [
        if (maxcharacters != null)
          LengthLimitingTextInputFormatter(
            maxcharacters,
          ),
      ],
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          fontSize: 16,
        ),
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
