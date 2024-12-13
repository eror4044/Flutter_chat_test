import 'package:web_socket_channel/web_socket_channel.dart';

class ChatApi {
  final WebSocketChannel _channel;

  ChatApi(String token)
      : _channel = WebSocketChannel.connect(
          Uri.parse('ws://10.0.2.2:8081'),
        );

  Stream<String> get messages =>
      _channel.stream.map((event) => event.toString());

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void dispose() {
    _channel.sink.close();
  }
}
