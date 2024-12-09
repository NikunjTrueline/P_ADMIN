import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String title;
  Color backgroundColor;
  Color foregroundColor;
  VoidCallback callback;
  bool isLoading = false;

  CustomButton(
      {required this.title,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.callback,
      isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                title,
                style: TextStyle(color: foregroundColor, fontSize: 24,fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
