import 'dart:io';

const List<String> markers = ['X', 'O'];
const int boardSize = 3;

// Enum for game states
enum GameState { playing, winX, winO, draw }

// Tic-Tac-Toe board class
class Board {
  final List<List<String>> cells;

  Board() : cells = List.generate(boardSize, (i) => List.generate(boardSize, (_) => '', growable: false));

  // Check if a move is valid
  bool isValidMove(int move) => move >= 1 && move <= 9 && cells[(move - 1) ~/ boardSize][(move - 1) % boardSize] == '';

  // Make a move on the board
  void makeMove(int move, String marker) {
    cells[(move - 1) ~/ boardSize][(move - 1) % boardSize] = marker;
  }

  // Check for winning conditions
  GameState checkWin() {
    // Check rows and columns
    for (int i = 0; i < boardSize; i++) {
      if (cells[i].every((cell) => cell == markers[0]) ||
          cells.map((row) => row[i]).every((cell) => cell == markers[0])) {
        return GameState.winX;
      } else if (cells[i].every((cell) => cell == markers[1]) ||
          cells.map((row) => row[i]).every((cell) => cell == markers[1])) {
        return GameState.winO;
      }
    }

    // Check win by diagonal ----> for X 
    if (cells[0][0] == markers[0] && cells[1][1] == markers[0] && cells[2][2] == markers[0] ||
        cells[0][2] == markers[0] && cells[1][1] == markers[0] && cells[2][0] == markers[0]) {
      return GameState.winX;
    }// check win by diagonal ---> for O 
    else if (cells[0][0] == markers[1] && cells[1][1] == markers[1] && cells[2][2] == markers[1] ||
        cells[0][2] == markers[1] && cells[1][1] == markers[1] && cells[2][0] == markers[1]) {
      return GameState.winO;
    }

    // Check for draw
    // if the players use every cells and no one win then the result (draw)
    if (cells.every((row) => row.every((cell) => cell != ''))) {
      return GameState.draw;
    }

    return GameState.playing;
  }

  // To display the board with numbered cells
void showBoard() {
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      var cellNumber = i * boardSize + j + 1; // numbering the cells 1 to 9 
      var cellValue = cells[i][j];
      stdout.write(cellValue.isEmpty ? cellNumber : cellValue);
      if (j < boardSize - 1) {
        stdout.write(' | ');
      }
    }
    print('');
    if (i < boardSize - 1) {
      print('---------');
    }
  }
  print('');
}

}


void main() {
  bool playing = true;
  GameState gameState = GameState.playing;
  Board board = Board();
  String currentPlayer ; // Player 

  // the player to choose X or O
  print('Player 1, choose your marker (X/O): ');
  String player1Marker = stdin.readLineSync()!.toUpperCase();
  if (player1Marker != 'X' && player1Marker != 'O') {
    //player1Marker = 'X';
    print('Invalid choice ... ');
    return main();
  }
  currentPlayer = player1Marker == 'X' ? 'X' : 'O';

    while (playing) {
      
      board.showBoard();

      if (gameState == GameState.playing) {
        if (currentPlayer == markers[0]) { // Player 1 turn (X)
          int move;
          while (true) {
            try {
              print('Player X, enter your move (1-9): ');
              move = int.parse(stdin.readLineSync()!);
              if (!board.isValidMove(move)) {
                throw RangeError('Invalid move! Enter a number between 1 and 9.');
              }
              break;
            } on FormatException catch (e) {
              print(e.message);
            } on RangeError catch (e) {
              print(e.message);
            }
          }
          board.makeMove(move, currentPlayer);
        } else { // Player 2 turn (O)
          int move;
          while (true) {
            try {
              print('Player O, enter your move (1-9): ');
              move = int.parse(stdin.readLineSync()!);
              if (!board.isValidMove(move)) {
                throw RangeError('Invalid move! Enter a number between 1 and 9.');
              }
              break;
            } on FormatException catch (e) {
              print(e.message);
            } on RangeError catch (e) {
              print(e.message);
            }
          }
          board.makeMove(move, currentPlayer);
        }

        gameState = board.checkWin();
      }

      if (gameState != GameState.playing) {
      board.showBoard();
        switch(gameState) {
          case GameState.winX:
            print('Player X wins!');
            break;
          case GameState.winO:
            print('Player O wins!');
            break;
          default:
            print('It\'s a draw!');
            break;          
        }

        break;
      }

      // to Switch between players for next round
      currentPlayer = currentPlayer == markers[0] ? markers[1] : markers[0];
    }

    print('Thank you for playing!');
}
