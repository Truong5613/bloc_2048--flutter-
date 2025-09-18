import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cubit/game_cubit.dart';
import 'models/game_state.dart';
import 'widgets/game_board.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(GameStateAdapter());

  final gameBox = await Hive.openBox<GameState>('game_box');

  runApp(MyApp(gameBox: gameBox));
}

class MyApp extends StatelessWidget {
  final Box<GameState> gameBox;

  const MyApp({super.key, required this.gameBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Game',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Arial',
      ),
      home: BlocProvider(
        create: (context) => GameCubit(gameBox),
        child: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      appBar: AppBar(
        title: const Text(
          '2048',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF776E65),
          ),
        ),
        backgroundColor: const Color(0xFFFAF8EF),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Score Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ScoreCard(title: 'SCORE', value: state.score),
                    ScoreCard(title: 'BEST', value: state.bestScore),
                  ],
                ),
                const SizedBox(height: 20),

                // Game Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Vuốt để di chuyển các ô. Khi hai ô có cùng số chạm vào nhau, chúng sẽ hợp nhất thành một!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF776E65),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Game Board
                const Center(child: GameBoard()),
                const SizedBox(height: 20),

                // New Game Button
                ElevatedButton(
                  onPressed: () => context.read<GameCubit>().newGame(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F7A66),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Trò chơi mới',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final String title;
  final int value;

  const ScoreCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBBADA0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEEE4DA),
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}