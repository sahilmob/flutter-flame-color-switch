import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import "package:color_switch/game.dart";

void main() {
  runApp(MaterialApp(home: Home(), theme: ThemeData.dark()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ColorSwitchGame _game;

  @override
  void initState() {
    _game = ColorSwitchGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          if (!_game.isGamePaused)
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _game.pauseGame();
                      setState(() {});
                    },
                    icon: const Icon(Icons.pause),
                  ),
                  SizedBox(width: 10),
                  ValueListenableBuilder(
                    valueListenable: _game.score,
                    builder:
                        (_, v, _) => Text(
                          v.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                  ),
                ],
              ),
            ),
          if (_game.isGamePaused)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "PAUSED!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: IconButton(
                      onPressed: () {
                        _game.resumeGame();
                        setState(() {});
                      },
                      icon: Icon(Icons.play_arrow, size: 140),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
