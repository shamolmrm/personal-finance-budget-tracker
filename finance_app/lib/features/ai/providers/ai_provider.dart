import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/claude_ai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class AiChatNotifier extends StateNotifier<List<ChatMessage>> {
  AiChatNotifier() : super([ChatMessage(text: 'Hi there! Ask anything about your finances.', isUser: false)]);

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    state = [...state, ChatMessage(text: message, isUser: true)];
    final reply = await ClaudeAIService.instance.generateResponse(message);
    state = [...state, ChatMessage(text: reply, isUser: false)];
  }
}

final aiChatProvider = StateNotifierProvider<AiChatNotifier, List<ChatMessage>>((ref) => AiChatNotifier());
