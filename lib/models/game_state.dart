import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_state.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class GameState extends HiveObject {
  @HiveField(0)
  final List<List<int>> board;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final int bestScore;

  @HiveField(3)
  final bool gameOver;

  @HiveField(4)
  final bool hasWon;

  GameState({
    required this.board,
    required this.score,
    required this.bestScore,
    required this.gameOver,
    required this.hasWon,
  });

  factory GameState.initial() {
    return GameState(
      board: List.generate(4, (_) => List.generate(4, (_) => 0)),
      score: 0,
      bestScore: 0,
      gameOver: false,
      hasWon: false,
    );
  }

  GameState copyWith({
    List<List<int>>? board,
    int? score,
    int? bestScore,
    bool? gameOver,
    bool? hasWon,
  }) {
    return GameState(
      board: board ?? this.board.map((row) => List<int>.from(row)).toList(),
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      gameOver: gameOver ?? this.gameOver,
      hasWon: hasWon ?? this.hasWon,
    );
  }

  factory GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);
  Map<String, dynamic> toJson() => _$GameStateToJson(this);
}