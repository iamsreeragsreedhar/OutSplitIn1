import 'package:equatable/equatable.dart';
import 'package:out_split_in/feature/chatbot/model/chat_message_model.dart';

enum ChatbotStatus { initial, ready, loading, error }

class ChatbotState extends Equatable {
  final List<ChatMessageModel> messages;
  final ChatbotStatus status;
  final bool isTyping;
  final List<String> activeSuggestions;
  final String? errorMessage;

  const ChatbotState({
    this.messages = const [],
    this.status = ChatbotStatus.initial,
    this.isTyping = false,
    this.activeSuggestions = const [
      '📊 My financial summary',
      '🍔 Food expenses breakdown',
      '📶 How offline sync works',
      '⚡ How UPI detection works',
      '💡 Money saving tips',
    ],
    this.errorMessage,
  });

  ChatbotState copyWith({
    List<ChatMessageModel>? messages,
    ChatbotStatus? status,
    bool? isTyping,
    List<String>? activeSuggestions,
    String? errorMessage,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      isTyping: isTyping ?? this.isTyping,
      activeSuggestions: activeSuggestions ?? this.activeSuggestions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        status,
        isTyping,
        activeSuggestions,
        errorMessage,
      ];
}
