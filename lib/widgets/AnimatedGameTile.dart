import 'package:flutter/material.dart';
import 'game_board.dart';

class AnimatedGameTile extends StatefulWidget {
  final int value;

  const AnimatedGameTile({super.key, required this.value});

  @override
  _AnimatedGameTileState createState() => _AnimatedGameTileState();
}

class _AnimatedGameTileState extends State<AnimatedGameTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GameTile(value: widget.value),
    );
  }
}