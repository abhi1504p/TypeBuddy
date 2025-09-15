import 'package:flutter/cupertino.dart';
import 'package:frontend/models/game_state.dart';

class GameStateProvider extends ChangeNotifier {
    GameState _gameState = GameState(
        id: '',
        isJoin: true,
        isOver: false,
        player: [],
        words: [],
    );
    Map<String, dynamic> get gameState => _gameState.toJson();
    void updateGameState({
        required id,
        required isJoin,
        required isOver,
        required player,
        required words,
    }) {
        _gameState = GameState(
            id: id,
            isJoin: isJoin,
            isOver: isOver,
            player: player,
            words: words,
        );
        notifyListeners();
    }
}
