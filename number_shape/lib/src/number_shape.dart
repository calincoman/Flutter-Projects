import 'dart:core';
import 'package:flutter/material.dart';

void main() {
  runApp(const NumberShape());
}

class NumberShape extends StatelessWidget {
  const NumberShape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // verifies if the number starts with 0
  bool checkIfValid(String? inputText) {
    return !(inputText!.length >= 2 && inputText[0] == '0' && inputText[1] != '.');
  }

  // converts the input string to an integer
  // returns the number if it's valid, null otherwise
  int? getNumber(String? inputText) {
    int? intValue = int.tryParse(inputText!);
    if (!checkIfValid(inputText)) {
      intValue = null;
    }
    return intValue;
  }

  bool checkIfPerfectSquare(int number) {
    int left = 1;
    int right = number;

    while (left <= right) {
      final double mid = (left + right) / 2;
      final int middle = mid.floor();

      if (middle * middle == number) {
        return true;
      }
      if (middle * middle < number) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }
    return false;
  }

  bool checkIfPerfectCube(int number) {
    int left = 1;
    int right = number;

    while (left <= right) {
      final double mid = (left + right) / 2;
      final int middle = mid.floor();

      if (middle * middle * middle == number) {
        return true;
      }
      if (middle * middle * middle < number) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }
    return false;
  }

  final TextEditingController textFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();
  int inputNumber = 0;
  String? errorText;
  bool isPerfectSquare = false, isPerfectCube = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Text("Check"),
            onPressed: () {
              if (inputNumber == 0 || textFieldController.text == "") {
                return;
              }
              setState(() {
                isPerfectSquare = checkIfPerfectSquare(inputNumber);
                isPerfectCube = checkIfPerfectCube(inputNumber);
              });

              showAlertDialog(context, this);
              textFieldController.clear();
            },
          ),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Number Shapes"),
          ),
          body: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                "Input a number to see if it is square or triangular",
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsetsDirectional.all(20),
                child: TextField(
                  controller: textFieldController,
                  focusNode: focusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "Enter a positive number",
                    errorText: errorText,
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        textFieldController.clear();
                        focusNode.requestFocus();
                        setState(() {
                          inputNumber = 0;
                        });
                      },
                    ),
                  ),
                  onChanged: (String? value) {
                    final int? intValue = getNumber(value);
                    setState(() {
                      errorText = (intValue == null && value != null && value.isNotEmpty)
                          ? "This is not a valid number!"
                          : null;
                      if (intValue != null) {
                        inputNumber = intValue;
                      } else {
                        inputNumber = 0;
                      }
                    });
                  },
                ),
              ),
            ],
          )),
    );
  }
}

// shows the Alert Dialog on the screen
void showAlertDialog(BuildContext context, _HomePageState home) {
  final String alertDialogTitle = "${home.inputNumber}";
  String alertDialogContent = "";

  final int inputNumber = home.inputNumber;
  final bool isPerfectSquare = home.isPerfectSquare;
  final bool isPerfectCube = home.isPerfectCube;

  if (isPerfectSquare && isPerfectCube) {
    alertDialogContent = "Number $inputNumber is both SQUARE and CUBE";
  } else if (isPerfectSquare) {
    alertDialogContent = "Number $inputNumber is perfect SQUARE";
  } else if (isPerfectCube) {
    alertDialogContent = "Number $inputNumber is perfect CUBE";
  } else {
    alertDialogContent = "Number $inputNumber is neither SQUARE nor CUBE";
  }

  // instantiate an Alert Dialog
  final AlertDialog alert = AlertDialog(
    title: Text(alertDialogTitle),
    content: Text(alertDialogContent),
  );

  // show the alert dialog
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
