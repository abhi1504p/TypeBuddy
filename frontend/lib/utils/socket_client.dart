import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketClient{
    IO.Socket? socket;
    static SocketClient? _instance;
    SocketClient._internal(){

        socket = IO.io(
            dotenv.env['SOCKET_IO_URL']!,
            IO.OptionBuilder()
                .setTransports(['websocket'])
                .disableAutoConnect()
                .build(),
        );

        socket!.connect();
    }
    static SocketClient get instance {
        _instance ??= SocketClient._internal();
        return _instance!;
    }

}