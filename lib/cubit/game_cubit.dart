import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import '../models/game_state.dart';

class GameCubit extends Cubit<GameState> {
  final Box<GameState> _gameBox;
  final Random _random = Random();

  GameCubit(this._gameBox) : super(GameState.initial()) {
    _loadGame();
  }

  void _loadGame() {
    final savedGame = _gameBox.get('current_game');
    if (savedGame != null) {
      emit(savedGame);
    } else {
      newGame();
    }
  }

  void _saveGame() {
    _gameBox.put('current_game', state);
  }

  void newGame() {
    final newState = GameState.initial();
    final boardWithTiles = _addRandomTile(_addRandomTile(newState.board));

    emit(newState.copyWith(
      board: boardWithTiles,
      bestScore: max(state.bestScore, state.score),
    ));
    _saveGame();
  }

  List<List<int>> _addRandomTile(List<List<int>> board) {
    final emptyCells = <List<int>>[];

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          emptyCells.add([i, j]);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final randomCell = emptyCells[_random.nextInt(emptyCells.length)];
      final newBoard = board.map((row) => List<int>.from(row)).toList();
      newBoard[randomCell[0]][randomCell[1]] = _random.nextDouble() < 0.9 ? 2 : 4;
      return newBoard;
    }

    return board;
  }

  void moveLeft() {
    final result = _moveAndMergeLeft(state.board);
    if (result['moved'] as bool) {
      _handleMove(result['board'] as List<List<int>>, result['scoreAdded'] as int);
    }
  }

  void moveRight() {
    final result = _moveAndMergeRight(state.board);
    if (result['moved'] as bool) {
      _handleMove(result['board'] as List<List<int>>, result['scoreAdded'] as int);
    }
  }

  void moveUp() {
    final result = _moveAndMergeUp(state.board);
    if (result['moved'] as bool) {
      _handleMove(result['board'] as List<List<int>>, result['scoreAdded'] as int);
    }
  }

  void moveDown() {
    final result = _moveAndMergeDown(state.board);
    if (result['moved'] as bool) {
      _handleMove(result['board'] as List<List<int>>, result['scoreAdded'] as int);
    }
  }

  void _handleMove(List<List<int>> newBoard, int scoreAdded) {
    final boardWithNewTile = _addRandomTile(newBoard);
    final newScore = state.score + scoreAdded;
    final hasWon = !state.hasWon && _checkWin(boardWithNewTile);
    final gameOver = _checkGameOver(boardWithNewTile);

    emit(state.copyWith(
      board: boardWithNewTile,
      score: newScore,
      bestScore: max(state.bestScore, newScore),
      gameOver: gameOver,
      hasWon: hasWon,
    ));
    _saveGame();
  }

  bool _checkWin(List<List<int>> board) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 2048) {
          return true;
        }
      }
    }
    return false;
  }

  bool _checkGameOver(List<List<int>> board) {
    // Check for empty cells
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) return false;
      }
    }

    // Check for possible merges
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        final current = board[i][j];
        if ((i < 3 && board[i + 1][j] == current) ||
            (j < 3 && board[i][j + 1] == current)) {
          return false;
        }
      }
    }
    return true;
  }

  Map<String, dynamic> _moveAndMergeLeft(List<List<int>> board) {
    final newBoard = board.map((row) => List<int>.from(row)).toList();
    bool moved = false;
    int scoreAdded = 0;

    for (int i = 0; i < 4; i++) {
      final row = _slideAndMergeRow(newBoard[i]);
      if (!_listsEqual(newBoard[i], row['row'] as List<int>)) {
        moved = true;
      }
      newBoard[i] = row['row'] as List<int>;
      scoreAdded += row['scoreAdded'] as int;
    }

    return {'board': newBoard, 'moved': moved, 'scoreAdded': scoreAdded};
  }

  Map<String, dynamic> _moveAndMergeRight(List<List<int>> board) {
    final newBoard = board.map((row) => List<int>.from(row)).toList();
    bool moved = false;
    int scoreAdded = 0;

    for (int i = 0; i < 4; i++) {
      final reversedRow = newBoard[i].reversed.toList();
      final result = _slideAndMergeRow(reversedRow);
      final finalRow = (result['row'] as List<int>).reversed.toList();

      if (!_listsEqual(newBoard[i], finalRow)) {
        moved = true;
      }
      newBoard[i] = finalRow;
      scoreAdded += result['scoreAdded'] as int;
    }

    return {'board': newBoard, 'moved': moved, 'scoreAdded': scoreAdded};
  }

  Map<String, dynamic> _moveAndMergeUp(List<List<int>> board) {
    final newBoard = board.map((row) => List<int>.from(row)).toList();
    bool moved = false;
    int scoreAdded = 0;

    for (int j = 0; j < 4; j++) {
      final column = [newBoard[0][j], newBoard[1][j], newBoard[2][j], newBoard[3][j]];
      final result = _slideAndMergeRow(column);
      final newColumn = result['row'] as List<int>;

      bool columnMoved = false;
      for (int i = 0; i < 4; i++) {
        if (newBoard[i][j] != newColumn[i]) {
          columnMoved = true;
        }
        newBoard[i][j] = newColumn[i];
      }

      if (columnMoved) moved = true;
      scoreAdded += result['scoreAdded'] as int;
    }

    return {'board': newBoard, 'moved': moved, 'scoreAdded': scoreAdded};
  }

  Map<String, dynamic> _moveAndMergeDown(List<List<int>> board) {
    final newBoard = board.map((row) => List<int>.from(row)).toList();
    bool moved = false;
    int scoreAdded = 0;

    for (int j = 0; j < 4; j++) {
      final column = [newBoard[3][j], newBoard[2][j], newBoard[1][j], newBoard[0][j]];
      final result = _slideAndMergeRow(column);
      final newColumn = result['row'] as List<int>;

      bool columnMoved = false;
      for (int i = 0; i < 4; i++) {
        if (newBoard[3-i][j] != newColumn[i]) {
          columnMoved = true;
        }
        newBoard[3-i][j] = newColumn[i];
      }

      if (columnMoved) moved = true;
      scoreAdded += result['scoreAdded'] as int;
    }

    return {'board': newBoard, 'moved': moved, 'scoreAdded': scoreAdded};
  }

  Map<String, dynamic> _slideAndMergeRow(List<int> row) {
    final newRow = List<int>.from(row);
    int scoreAdded = 0;

    // Remove zeros
    newRow.removeWhere((element) => element == 0);

    // Merge adjacent equal elements
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        scoreAdded += newRow[i];
        newRow.removeAt(i + 1);
      }
    }

    // Add zeros to make length 4
    while (newRow.length < 4) {
      newRow.add(0);
    }

    return {'row': newRow, 'scoreAdded': scoreAdded};
  }

  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}