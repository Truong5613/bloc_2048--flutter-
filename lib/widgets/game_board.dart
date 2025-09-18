import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import '../cubit/game_cubit.dart';
import '../models/game_state.dart';
import 'AnimatedGameTile.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return SwipeDetector(
          onSwipeLeft: (offset) => context.read<GameCubit>().moveLeft(),
          onSwipeRight: (offset) => context.read<GameCubit>().moveRight(),
          onSwipeUp: (offset) => context.read<GameCubit>().moveUp(),
          onSwipeDown: (offset) => context.read<GameCubit>().moveDown(),
          child: Container(
            width: 320,
            height: 320,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFBBADA0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [

                // Background grid
                ...List.generate(16, (index) {
                  final row = index ~/ 4;
                  final col = index % 4;
                  return Positioned(
                    left: col * 76.0 + 4,
                    top: row * 76.0 + 4,
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCDC1B4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),

                ...List.generate(16, (index) {
                  final row = index ~/ 4;
                  final col = index % 4;
                  final value = state.board[row][col];

                  if (value == 0) return const SizedBox();

                  return AnimatedPositioned(
                    key: ValueKey('$row-$col-$value'),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    left: col * 76.0 + 4,
                    top: row * 76.0 + 4,
                    child: AnimatedGameTile(value: value),
                  );
                }),

                // Game Over Overlay
                if (state.gameOver)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Game Over!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF776E65),
                        ),
                      ),
                    ),
                  ),

                // Win Overlay
                if (state.hasWon)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'You Win!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF776E65),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GameTile extends StatelessWidget {
  final int value;

  const GameTile({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = _getTileColors(value);

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: TextStyle(
            fontSize: _getFontSize(value),
            fontWeight: FontWeight.bold,
            color: colors['text'],
          ),
        ),
      ),
    );
  }

  Map<String, Color> _getTileColors(int value) {
    switch (value) {
      case 2:
        return {'background': const Color(0xFFEEE4DA), 'text': const Color(0xFF776E65)};
      case 4:
        return {'background': const Color(0xFFEDE0C8), 'text': const Color(0xFF776E65)};
      case 8:
        return {'background': const Color(0xFFF2B179), 'text': Colors.white};
      case 16:
        return {'background': const Color(0xFFF59563), 'text': Colors.white};
      case 32:
        return {'background': const Color(0xFFF67C5F), 'text': Colors.white};
      case 64:
        return {'background': const Color(0xFFF65E3B), 'text': Colors.white};
      case 128:
        return {'background': const Color(0xFFEDCF72), 'text': Colors.white};
      case 256:
        return {'background': const Color(0xFFEDCC61), 'text': Colors.white};
      case 512:
        return {'background': const Color(0xFFEDC850), 'text': Colors.white};
      case 1024:
        return {'background': const Color(0xFFEDC53F), 'text': Colors.white};
      case 2048:
        return {'background': const Color(0xFFEDC22E), 'text': Colors.white};
      default:
        return {'background': const Color(0xFF3C3A32), 'text': Colors.white};
    }
  }

  double _getFontSize(int value) {
    if (value < 100) return 32;
    if (value < 1000) return 28;
    return 24;
  }
}
