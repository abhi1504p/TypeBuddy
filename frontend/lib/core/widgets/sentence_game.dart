import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/score_board.dart';
import 'package:provider/provider.dart';

import '../../providers/game_state_provider.dart';
import '../../utils/socket_client.dart';
import '../../utils/socket_metod.dart';

class SentenceGame extends StatefulWidget {
  const SentenceGame({Key? key}) : super(key: key);

  @override
  State<SentenceGame> createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  var playerMe = null;
  final SocketMethod _socketMethods = SocketMethod();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateGame(context);
  }

  void findPlayerMe(GameStateProvider game) {
    game.gameState['player'].forEach((players) {
      if (players['socketId'] == SocketClient.instance.socket!.id) {
        playerMe = players;
      }
    });
  }

  Widget getTypedWords(words, player) {
    var tempWords = words.sublist(0, player['currentWordIndex']);
    String typedWord = tempWords.join(' ');
    return Text(
      typedWord,
      style: const TextStyle(
        color: Color.fromRGBO(52, 235, 119, 1),
        fontSize: 30,
      ),
    );
  }

  Widget getCurrentWord(words, player) {
    return Text(
      words[player['currentWordIndex']],
      style: const TextStyle(
        decoration: TextDecoration.underline,
        fontSize: 30,
      ),
    );
  }

  Widget getWordsToBeTyped(words, player) {
    var tempWords = words.sublist(player['currentWordIndex'] + 1, words.length);
    String wordstoBeTyped = tempWords.join(' ');
    return Text(wordstoBeTyped, style: const TextStyle(fontSize: 30));
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    findPlayerMe(game);

    if (game.gameState['words'].length > playerMe['currentWordIndex']) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            textDirection: TextDirection.ltr,
            children: [
              getTypedWords(game.gameState['words'], playerMe),
              getCurrentWord(game.gameState['words'], playerMe),
              getWordsToBeTyped(game.gameState['words'], playerMe),
            ],
          ),
        ),
      );
    }
    return Scoreboard();
  }
}
