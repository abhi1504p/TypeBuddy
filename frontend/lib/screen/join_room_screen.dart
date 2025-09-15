import 'package:flutter/material.dart';

import '../core/widgets/app_button.dart';
import '../core/widgets/app_input_field.dart';
import '../core/widgets/app_text.dart';

class JoinRoomScreen extends StatefulWidget {
    const JoinRoomScreen({super.key});

    @override
    State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _gameController = TextEditingController();
    @override
    void dispose() {
        super.dispose();
        _nameController.dispose();
        _gameController.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final h = MediaQuery.of(context).size.height;
        return Scaffold(
            body: Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                AppText.heading("Join Room"),
                                SizedBox(height: h * 0.06),
                                AppInputField(
                                    obscureTexts: false,
                                    labeltext: "Enter your Nickname",
                                    controller: _nameController,
                                ),
                                SizedBox(height: h * 0.02),
                                AppInputField(
                                    obscureTexts: false,
                                    labeltext: "Enter game id",
                                    controller: _gameController,
                                ),
                                SizedBox(height: h * 0.04),
                                AppButton(
                                    type: ButtonType.filled,
                                    text: "Join",
                                    onPressed: () {},
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}
