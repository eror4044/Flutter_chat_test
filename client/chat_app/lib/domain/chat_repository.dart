import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_api.dart';

final chatRepositoryProvider = Provider.family<ChatRepository, String>(
  (ref, token) => ChatRepository(ChatApi(token)),
);

class ChatRepository {
  final ChatApi _chatApi;

  ChatRepository(this._chatApi);

  Stream<String> get messages => _chatApi.messages;

  void sendMessage(String message) => _chatApi.sendMessage(message);

  void dispose() => _chatApi.dispose();
}
