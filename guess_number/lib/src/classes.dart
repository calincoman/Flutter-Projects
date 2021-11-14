import 'dart:math';
import 'package:flutter/material.dart';

class RandomNumberGenerator {
  final int minValue;
  final int maxValue;
  const RandomNumberGenerator({required this.minValue, required this.maxValue});

  int getRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(maxValue - minValue + 1) + minValue;
    return randomNumber;
  }
}

class MyAlertDialog extends StatelessWidget {

  final String title;
  final String content;
  final String firstButtonText;
  final String secondButtonText;
  final ValueChanged<bool> updateHomePageState;
  final TextStyle textStyle = const TextStyle (fontSize: 18, color: Colors.black);

  const MyAlertDialog({
    required this.title,
    required this.content,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.updateHomePageState
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: textStyle,),
      content: Text(content, style: textStyle,),
      actions: <Widget>[
        TextButton(
          child: Text(firstButtonText),
          onPressed: () {
            updateHomePageState(false);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(secondButtonText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}