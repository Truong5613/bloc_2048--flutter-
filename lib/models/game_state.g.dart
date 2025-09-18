// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStateAdapter extends TypeAdapter<GameState> {
  @override
  final int typeId = 0;

  @override
  GameState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameState(
      board: (fields[0] as List)
          .map((dynamic e) => (e as List).cast<int>())
          .toList(),
      score: fields[1] as int,
      bestScore: fields[2] as int,
      gameOver: fields[3] as bool,
      hasWon: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GameState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.board)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.bestScore)
      ..writeByte(3)
      ..write(obj.gameOver)
      ..writeByte(4)
      ..write(obj.hasWon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
      board: (json['board'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      score: (json['score'] as num).toInt(),
      bestScore: (json['bestScore'] as num).toInt(),
      gameOver: json['gameOver'] as bool,
      hasWon: json['hasWon'] as bool,
    );

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
      'board': instance.board,
      'score': instance.score,
      'bestScore': instance.bestScore,
      'gameOver': instance.gameOver,
      'hasWon': instance.hasWon,
    };
