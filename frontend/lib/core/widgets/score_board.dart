import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/game_state_provider.dart';


class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: game.gameState['player'].length,
      itemBuilder: (context, index) {
        var playerData = game.gameState['player'][index];
        return ListTile(
          title: Text(
            playerData['nickname'],
          ),
          trailing: Text(
            playerData['WPM'].toString(),
          ),
        );
      },
    );
  }
}