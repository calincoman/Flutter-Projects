import 'dart:core';
import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({Key? key}) : super(key: key);

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
  List<List<GridElement>> matrix = makeMatrix(3, 3);

  bool whoseTurn = false;
  bool foundWinner = false;
  bool draw = false;

  int winnerRow = -1;
  int winnerCol = -1;
  int filledBoxes = 0;

  Color player1Color = Colors.blue;
  Color player2Color = Colors.green;
  Color winner = Colors.white;

  void updateState(GridElement element) {
    setState(() {
      if (element.tapped == false) {
        ++filledBoxes;
        final Color newColor = (whoseTurn == false) ? player1Color : player2Color;
        element.tapped = true;
        element.color = newColor;
      }
    });
  }

  Color showGridColor(GridElement element, int row, int col) {
    if (foundWinner) {
      return (element.color == winner && (row == winnerRow || col == winnerCol)) ? element.color : Colors.white;
    }
    return element.color;
  }

  Color checkWinner(int index, String indicator) {
    if (filledBoxes == 9) {
      setState(() {
        draw = true;
      });
      return Colors.white;
    }
    if (indicator == 'row') {
      return (matrix[index][0].color == matrix[index][1].color && matrix[index][1].color == matrix[index][2].color)
          ? matrix[index][0].color
          : Colors.white;
    }
    if (indicator == 'col') {
      return (matrix[0][index].color == matrix[1][index].color && matrix[1][index].color == matrix[2][index].color)
          ? matrix[0][index].color
          : Colors.white;
    }
    return Colors.white;
  }

  void findWinner() {
    final List<Color> checks = <Color>[
      checkWinner(0, 'row'),
      checkWinner(1, 'row'),
      checkWinner(2, 'row'),
      checkWinner(0, 'col'),
      checkWinner(1, 'col'),
      checkWinner(2, 'col'),
    ];

    setState(() {
      for (int i = 0; i < checks.length; ++i) {
        if (checks[i] != Colors.white) {
          foundWinner = true;
          winner = checks[i];
          if (i <= 2) {
            winnerRow = i;
          } else {
            winnerCol = i % 3;
          }
          break;
        }
      }
    });
  }

  void resetGame() {
    setState(() {
      foundWinner = false;
      draw = false;
      winner = Colors.white;
      whoseTurn = false;
      matrix.clear();
      matrix = makeMatrix(3, 3);
      winnerRow = -1;
      winnerCol = -1;
      filledBoxes = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Tic-Tac-Toe'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              itemCount: matrix.length * matrix[0].length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                final Coord coord = getCoordinates(index);
                final int row = coord.x;
                final int col = coord.y;

                final GridElement element = matrix[row][col];

                return GestureDetector(
                  onTap: () {
                    updateState(element);
                    setState(() {
                      whoseTurn = !whoseTurn;
                    });
                    findWinner();
                    if (foundWinner || draw) {
                      showAlertDialog(context, this);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: showGridColor(element, row, col),
                      border: Border.all(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            if (foundWinner || draw)
              ElevatedButton(
                onPressed: () {
                  resetGame();
                },
                child: const Text('Play again!'),
              ),
          ],
        )
    );
  }
}

Coord getCoordinates(int index) {
  return Coord((index / 3).floor(), index % 3);
}

List<List<GridElement>> makeMatrix(int rows, int cols) {
  return List<List<GridElement>>.generate(
      rows,
      (int rowIndex) =>
          List<GridElement>.generate(cols, (int colIndex) => GridElement(tapped: false, color: Colors.white)));
}

class GridElement {
  GridElement({required this.tapped, required this.color});

  Color color;
  bool tapped;
}

class Coord {
  Coord(this.x, this.y);

  int x;
  int y;
}

void showAlertDialog(BuildContext context, _HomePageState home) {
  const String alertDialogTitle = 'Game Over!';

  final AlertDialog alert;

  if (home.draw == false) {
    alert = AlertDialog(
      title: const Text(alertDialogTitle),
      content: Row(
        children: <Widget>[
          const Text('Winner is: '),
          const SizedBox(width: 20),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: home.winner,
            ),
          ),
        ],
      ),
    );
  } else {
    alert = const AlertDialog(
      title: Center(
        child: Text('Draw!'),
      ),
    );
  }

  showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
