import 'package:flutter/material.dart';
import 'package:frontend/providers/game_state_provider.dart';
import 'package:frontend/utils/socket_client.dart';
import 'package:provider/provider.dart';

import '../providers/client_state_provider.dart';

class SocketMethod {
  bool _isPlaying = false;
  final _socketClient = SocketClient.instance.socket!;
  // create game
  void createGame(String nickName) {
    if (nickName.isNotEmpty) {
      _socketClient.emit('create-game', {'nickname': nickName});
    }
  }

  // join game
  void joinGame(String gameId, String nickName) {
    if (nickName.isNotEmpty && gameId.isNotEmpty) {
      _socketClient.emit('join-game', {'nickname': nickName, 'gameId': gameId});
    }
  }

  sendUserInput(String value, String gameId) {
    _socketClient.emit('userInput', {'userInput': value, 'gameId': gameId});
  }

  void updateGameListner(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider =
          Provider.of<GameStateProvider>(
            context,
            listen: false,
          ).updateGameState(
            id: data['_id'],
            isJoin: data['isJoin'],
            isOver: data['isOver'],
            player: data['player'],
            words: data['words'],
          );

      if (data['_id'].isNotEmpty && !_isPlaying) {
        Navigator.pushNamed(context, '/game-screen');
        _isPlaying = true;
      }
    });
  }

  void startTimer(dynamic gameId, dynamic playerId) {
    print(gameId);
    _socketClient.emit('timer', {'gameId': gameId, 'playerId': playerId});
  }

  void updateTimer(BuildContext context) {
    final clientStateProvider = Provider.of<ClientStateProvider>(
      context,
      listen: false,
    );
    _socketClient.on('timer', (data) {
      clientStateProvider.setClientState(data);
    });
  }

  void updateGame(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider =
          Provider.of<GameStateProvider>(
            context,
            listen: false,
          ).updateGameState(
            id: data['_id'],
            player: data['player'],
            isJoin: data['isJoin'],
            words: data['words'],
            isOver: data['isOver'],
          );
    });
  }

  void notCorrectGame(BuildContext context) {
    _socketClient.on(
      'notCorrectGame',
      (data) => {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data))),
      },
    );
  }

  void gameFinishedListener() {
    _socketClient.on('done', (data) => _socketClient.off('timer'));
  }
}
