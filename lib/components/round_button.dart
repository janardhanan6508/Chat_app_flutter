import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {super.key,
      required this.title,
      required this.colour,
      required this.onPressed});
  final String title;
  final Color colour;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: onPressed,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
