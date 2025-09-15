class GameState {
    final String id;
    final bool isJoin;
    final bool isOver;
    final List player;
    final List words;
    GameState({
        required this.id,
        required this.isJoin,
        required this.isOver,
        required this.player,
        required this.words,
    });
    Map<String, dynamic> toJson() => {
        'id': id,
        'isJoin': isJoin,
        'isOver': isOver,
        'player': player,
        'words': words,
    };
}
