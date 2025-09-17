import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/providers/client_state_provider.dart';
import 'package:frontend/providers/game_state_provider.dart';
import 'package:frontend/screen/create_room_screen.dart';
import 'package:frontend/screen/game_screen.dart';
import 'package:frontend/screen/home_screen.dart';
import 'package:frontend/screen/join_room_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make sure fileName matches your file
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameStateProvider()),
        ChangeNotifierProvider(create: (context) => ClientStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TypeBuddy',
        theme: ThemeData(
          colorScheme: ColorScheme.of(context).copyWith(primary: Colors.blue),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // use your color
              foregroundColor: Colors.white, // text color
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/create_room': (context) => CreateRoomScreen(),
          '/join_room': (context) => JoinRoomScreen(),
          '/game-screen': (context) => GameScreen(),
        },
      ),
    );
  }
}
