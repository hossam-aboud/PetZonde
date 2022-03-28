import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.textSize,
    required this.size,
    required this.color,
    required this.textColor,
    required this.pressed, Color? borderColor,
  }) : super(key: key);

  final String text;
  final double textSize;
  final Size size;
  final Color color, textColor;
  final GestureTapCallback  pressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text,
        style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: FontWeight.bold
        ),),
      style: ElevatedButton.styleFrom(

        elevation: 0,
        fixedSize: size,
        primary: color,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: pressed,
    );
  }
}