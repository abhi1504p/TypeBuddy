import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_button.dart';

import '../core/widgets/app_text.dart';

class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Scaffold(
            body: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            AppText.heading("Create /Join a room to play!"),
                            SizedBox(height: size.height * .1),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                    AppButton(
                                        type: ButtonType.filled,
                                        text: "Create",
                                        onPressed: () {
                                            Navigator.pushNamed(context, '/create_room');
                                        },
                                        isHome: true,
                                    ),
                                    AppButton(
                                        type: ButtonType.filled,
                                        text: "Join",
                                        onPressed: () {
                                            Navigator.pushNamed(context, '/join_room');
                                        },
                                        isHome: true,
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
