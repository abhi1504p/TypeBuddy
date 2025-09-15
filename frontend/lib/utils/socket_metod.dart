import 'package:flutter/material.dart';
import 'package:frontend/providers/game_state_provider.dart';
import 'package:frontend/utils/socket_client.dart';
import 'package:provider/provider.dart';

class SocketMethod {
  final _socketClient = SocketClient.instance.socket!;
  void createGame(String nickName) {
    if (nickName.isNotEmpty) {
      _socketClient.emit('create-game', {'nickname': nickName});
    }
  }

  updateGameListner(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider = Provider.of<GameStateProvider>(context,listen: false)
          .updateGameState(
            id: data['_id'],
            isJoin: data['isJoin'],
            isOver: data['isOver'],
            player: data['player'],
            words: data['words'],
          );

      print(data);
      if (data['_id'].isNotEmpty) {

        Navigator.pushNamed(context, '/game-screen');
      }
    });
  }
}
