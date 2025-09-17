import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_button.dart';
import 'package:frontend/providers/game_state_provider.dart';
import 'package:frontend/utils/socket_client.dart';
import 'package:frontend/utils/socket_metod.dart';
import 'package:provider/provider.dart';

class GameTextField extends StatefulWidget {
  const GameTextField({super.key});

  @override
  State<GameTextField> createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  final SocketMethod _socketMethod = SocketMethod();
  var playerMe = null;
  bool isBtn = true;
  late GameStateProvider? game;

  final TextEditingController _wordsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayerMe(game!);
  }

  void handleTextChange(String value, String gameID) {
    var lastChar = value[value.length - 1];

    if (lastChar == " ") {
      _socketMethod.sendUserInput(value, gameID);
      setState(() {
        _wordsController.text = "";
      });
    }
  }

  void findPlayerMe(GameStateProvider game) {
    game.gameState['player'].forEach((players) {
      if (players['socketId'] == SocketClient.instance.socket!.id) {
        playerMe = players;
      }
    });
  }

  void handleStart(GameStateProvider game) {
    _socketMethod.startTimer(
      game.gameState['id'], // gameId
      playerMe['_id'],
    );
    setState(() {
      isBtn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);
    return playerMe['isPartyLeader'] && isBtn
        ? AppButton(
            type: ButtonType.filled,
            text: 'START',
            onPressed: () => handleStart(gameData),
          )
        : TextFormField(
            readOnly: gameData.gameState['isJoin'],
            controller: _wordsController,
            onChanged: (val) => handleTextChange(val, gameData.gameState['id']),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              fillColor: const Color(0xffF5F5FA),
              hintText: 'Type here',
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
  }
}
