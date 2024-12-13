import 'package:chat_app/domain/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatScreen extends ConsumerStatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  WebSocketChannel? _channel;
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  bool _isReconnecting = false;
  bool _isTyping = false;
  String _typingUser = "";
  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() {
    setState(() {
      _isLoading = true;
      _isReconnecting = false;
    });

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8081'),
    );

    _channel?.stream.listen(
      (data) {
        final decoded = jsonDecode(data);
        switch (decoded['type']) {
          case 'history':
            setState(() {
              _messages.clear();
              _messages
                  .addAll(List<Map<String, dynamic>>.from(decoded['messages']));
              _isLoading = false;
            });
            break;
          case 'message':
            setState(() {
              _messages.add(decoded['message']);
              _isTyping = false;
            });
            break;
          case 'typing':
            setState(() {
              _isTyping = true;
              _typingUser = decoded['sender'];
            });

            Future.delayed(Duration(seconds: 5), () {
              if (_isTyping) {
                setState(() {
                  _isTyping = false;
                });
              }
            });
            break;
          default:
        }
      },
      onError: (error) {
        print('Connection error: $error');
        _reconnect();
      },
      onDone: () {
        print('Connection closed');
        _reconnect();
      },
    );
  }

  void _reconnect() async {
    if (_isReconnecting) return;
    setState(() {
      _isReconnecting = true;
    });

    print('Reconnection...');
    await Future.delayed(Duration(seconds: 2));
    _connect();
  }

  void _sendMessage() {
    final currentUser = ref.read(authStateProvider);
    if (_controller.text.isNotEmpty &&
        _channel != null &&
        currentUser != null) {
      final message = {
        'sender': currentUser.username,
        'content': _controller.text,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      };
      setState(() {
        _messages.add(message);
      });

      _channel?.sink.add(jsonEncode(message));
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text(_isReconnecting
              ? 'Reconnecting...'
              : currentUser != null
                  ? 'Chat (${currentUser.username})'
                  : 'Chat'),
          _isTyping ? Text(_typingUser + "is typing") : Text("")
        ],
      )),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = _messages.reversed.toList()[index];
                      final isMine =
                          message['sender'] == (currentUser?.username ?? '');

                      return Align(
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isMine ? Colors.blueAccent : Colors.grey[800],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: isMine
                                  ? Radius.circular(12)
                                  : Radius.circular(0),
                              bottomRight: isMine
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['content'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                _formatTimestamp(message['timestamp']),
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Enter message...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
