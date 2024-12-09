import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AppUtil {
  static Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static void showToast(String message,
      {ToastGravity gravity = ToastGravity.BOTTOM,
      Color backgroundColor = Colors.black,
      Color textColor = Colors.white}) {

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0
    );

  }
}
