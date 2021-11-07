import 'package:flutter/material.dart';
import './constants.dart' as constants;

void main() {
  runApp(const CurrencyConverter());
}

class CurrencyConverter extends StatelessWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

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
  String? errorText;
  String elevatedButtonText = constants.elevatedButtonText1;
  double? valueInRon = 0.0;
  bool pressedElevatedButton = false;

  // verifies if the number starts with 0
  bool checkIfValid(String? inputText) {
    return !(inputText!.length >= 2 && inputText[0] == '0' && inputText[1] != '.');
  }

  // converts the number to double, verifies if it's valid and returns it
  double? getNumber(String? inputText) {
    double? doubleValue = double.tryParse(inputText!);
    if (!checkIfValid(inputText)) {
      doubleValue = null;
    }
    return doubleValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(constants.appTitle),
      ),
      body: Column(
        children: <Widget>[
          Container(
            // height: MediaQuery.of(context).size.height / 2,
            // width: MediaQuery.of(context).size.width,
            margin: const EdgeInsetsDirectional.all(20.0),
            child: TextField(
              controller: textFieldController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: constants.textFieldLabel,
                hintText: "Enter a number",
                errorText: errorText,
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    textFieldController.clear();
                    setState(() {
                      valueInRon = 0.0;
                    });
                  },
                ),
              ),
              onChanged: (String? value) {
                double? doubleValue = getNumber(value!);
                setState(() {
                  errorText = (doubleValue == null && value.isNotEmpty) ? constants.errorNotValidNumber : null;
                  if (doubleValue != null) {
                    if (doubleValue != 0) {
                     valueInRon = doubleValue * constants.ronInEuro;
                    }
                  } else {
                    valueInRon = 0.0;
                  }
                });
              },
            ),
          ),
          const Text(
            "Value in RON",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "${valueInRon!.toStringAsFixed(4)}",
            style: TextStyle(fontSize: 20)
          ),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: () {
                pressedElevatedButton = !pressedElevatedButton;
                setState(() {
                  if (pressedElevatedButton) {
                    elevatedButtonText = constants.elevatedButtonText2;
                  } else {
                    elevatedButtonText = constants.elevatedButtonText1;
                  }
                });
              },
              child: Text(elevatedButtonText),
          ),
          SizedBox(height: 30),
          pressedElevatedButton ? const Text(
            "1 EURO = ${constants.ronInEuro} RON",
            style: TextStyle(fontSize: 20),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
