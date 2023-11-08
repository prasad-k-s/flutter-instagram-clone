import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/utlis/snackBar.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource imageSource, BuildContext context) async {
  try {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: imageSource);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return null;
    }
  } catch (e) {
    if (context.mounted) {
      showSnackbar(
        context: context,
        text: e.toString(),
        contentType: ContentType.failure,
        title: 'Oh Snap!',
      );
    }
    return null;
  }
}
