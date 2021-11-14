import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import './classes.dart';
import './constants.dart' as constants;

void main() {
  runApp(const GuessNumber());
}

class GuessNumber extends StatelessWidget {
  const GuessNumber({Key? key}) : super(key: key);

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

  final TextEditingController textFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RandomNumberGenerator rng = const RandomNumberGenerator(minValue: 1, maxValue: 100);
  int randomNumber = 1;
  int inputNumber = 0, inputNumberCopy = 0;
  String? errorText;
  String elevatedButtonText = constants.elevatedButtonText_1;
  bool foundNumber = false;
  bool buttonClickedAfterReset = false;
  bool enableTextField = true;
  bool reset = false;

  _HomePageState() {
    randomNumber = rng.getRandomNumber();
  }

  void updateHomePageState(bool reset) {
    setState(() {
      this.reset = reset;
      foundNumber = false;
      enableTextField = true;
      resetRandomNumber();
      elevatedButtonText = constants.elevatedButtonText_1;
      buttonClickedAfterReset = false;
    });
  }

  void resetRandomNumber() {
    setState(() {
      randomNumber = rng.getRandomNumber();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(constants.appTitle),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              "I'm thinking of a number between 1 and 100",
              style: TextStyle(fontSize: 26, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 17),
            const Text(
              "Guess my number!",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 20),
            if (!foundNumber && !reset && buttonClickedAfterReset)
              Column(
                children: [
                  Text(
                    "You tried $inputNumberCopy",
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  if (inputNumberCopy < randomNumber)
                    const Text(
                      "Try higher!",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    )
                  else
                    if (inputNumberCopy > randomNumber)
                      const Text(
                        "Try lower!",
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      )
                ],
              ),
            Card(
              elevation: 3.0,
              child: Column(
                children: <Widget>[
                  const ListTile(
                    title: Text(
                      "Try a number!",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.all(25),
                    child: TextField(
                      enabled: enableTextField,
                      focusNode: focusNode,
                      controller: textFieldController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Enter a number",
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
                        int? intValue = getNumber(value!);
                        setState(() {
                          errorText = (intValue == null && value.isNotEmpty) ? constants.errorNotValidNumber : null;
                          if (intValue != null) {
                            inputNumber = intValue;
                          } else {
                            inputNumber = 0;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        textFieldController.clear();
                        if (inputNumber == 0) {
                            return;
                        }
                        if (inputNumber == randomNumber && reset == false) {
                          showAlertDialog(context, this);
                        }
                        setState(() {
                          inputNumberCopy = inputNumber;
                          if (reset == false) {
                            buttonClickedAfterReset = true;
                          }
                          if (reset == true) {
                            reset = false;
                            foundNumber = false;
                            enableTextField = true;
                            resetRandomNumber();
                            buttonClickedAfterReset = false;
                          }
                          if (inputNumber == randomNumber) {
                            foundNumber = true;
                            reset = true;
                          }
                          if (reset) {
                            elevatedButtonText = constants.elevatedButtonText_2;
                            enableTextField = false;
                          } else {
                            elevatedButtonText = constants.elevatedButtonText_1;
                          }
                        });
                      },
                      child: Text(elevatedButtonText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// shows the Alert Dialog on the screen
showAlertDialog(BuildContext context, _HomePageState home) {

  // instantiate an Alert Dialog
  MyAlertDialog alert = MyAlertDialog(
      title: "You guessed right",
      content: "It was ${home.randomNumber}",
      firstButtonText: "Try again!",
      secondButtonText: "Ok",
      updateHomePageState: home.updateHomePageState,
  );

  // show the alert dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
