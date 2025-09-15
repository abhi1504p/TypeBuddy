import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_button.dart';
import 'package:frontend/core/widgets/app_input_field.dart';
import 'package:frontend/utils/socket_client.dart';
import 'package:frontend/utils/socket_metod.dart';

import '../core/widgets/app_text.dart';

class CreateRoomScreen extends StatefulWidget {
    const CreateRoomScreen({super.key});

    @override
    State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
    final TextEditingController _nameController = TextEditingController();
    final SocketMethod _socketMethod = SocketMethod();

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
        _socketMethod.updateGameListner(context);
    }

    @override
    void dispose() {
        super.dispose();
        _nameController.dispose();
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
                                AppText.heading("Create Room"),
                                SizedBox(height: h * 0.08),
                                AppInputField(
                                    obscureTexts: false,
                                    labeltext: "Room Name",
                                    controller: _nameController,
                                ),
                                SizedBox(height: h * 0.04),
                                AppButton(
                                    type: ButtonType.filled,
                                    text: "Create",
                                    onPressed: () =>
                                    _socketMethod.createGame(_nameController.text),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}
