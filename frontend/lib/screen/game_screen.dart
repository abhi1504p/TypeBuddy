import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/widgets/app_text.dart';
import 'package:frontend/core/widgets/game_text_field.dart';
import 'package:frontend/providers/client_state_provider.dart';
import 'package:frontend/providers/game_state_provider.dart';
import 'package:frontend/utils/socket_metod.dart';
import 'package:provider/provider.dart';

import '../core/widgets/sentence_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethod _socketMethod = SocketMethod();
  @override
  void initState() {
    super.initState();
    _socketMethod.updateTimer(context);
    _socketMethod.updateGame(context);
    _socketMethod.gameFinishedListener();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);
    return Scaffold(
      body: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Chip(
                  label: AppText.caption(
                    clientStateProvider.clientState['timer']['msg'].toString(),

                    fontSize: 16,
                  ),
                ),
                AppText.caption(
                  clientStateProvider.clientState['timer']['countDown']
                      .toString(),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const SentenceGame(),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: game.gameState['player'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Chip(
                              label: Text(
                                game.gameState['player'][index]['nickname'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Slider(
                              value: (game.gameState['player'][index]
                              ['currentWordIndex'] /
                                  game.gameState['words'].length),
                              onChanged: (val) {},
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                game.gameState['isJoin']
                    ? ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: game.gameState['id']),
                            ).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: AppText.body(
                                    'Game Code copied to clickboard!',
                                  ),
                                    dismissDirection: DismissDirection.endToStart,
                                    backgroundColor: Colors.green,
                                ),
                              );
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            fillColor: const Color(0xffF5F5FA),
                            hintText: 'Click to Copy Game Code',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(child: const GameTextField()),
      ),
    );
  }
}
