import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/core/services/network_service.dart';
import 'package:out_split_in/feature/chatbot/model/chat_message_model.dart';
import 'package:out_split_in/feature/chatbot/services/chatbot_service.dart';
import 'package:out_split_in/feature/chatbot/view_model/chatbot/chatbot_event.dart';
import 'package:out_split_in/feature/chatbot/view_model/chatbot/chatbot_state.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotService chatbotService;
  final HomeBloc homeBloc;
  final NetworkService networkService;

  ChatbotBloc({
    required this.chatbotService,
    required this.homeBloc,
    required this.networkService,
  }) : super(const ChatbotState()) {
    on<ChatbotInitEvent>(_onInit);
    on<ChatbotSendMessageEvent>(_onSendMessage);
    on<ChatbotClearHistoryEvent>(_onClearHistory);
  }

  void _onInit(ChatbotInitEvent event, Emitter<ChatbotState> emit) {
    if (state.messages.isNotEmpty) return;

    final welcomeMessage = ChatMessageModel(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      text:
          'Hello! 👋 I am your **OutSplitIn Financial Assistant**.\n\n'
          'I can help you monitor your spending, breakdown categories, discover money-saving tips, and guide you through app features like UPI auto-detection and offline auto-sync.\n\n'
          'Tap a quick prompt below or type your question!',
      isUser: false,
      timestamp: DateTime.now(),
      suggestions: const [
        '📊 My financial summary',
        '🍔 Food expenses breakdown',
        '📶 How offline sync works',
        '⚡ How UPI detection works',
        '💡 Money saving tips',
      ],
    );

    emit(
      state.copyWith(
        status: ChatbotStatus.ready,
        messages: [welcomeMessage],
      ),
    );
  }

  Future<void> _onSendMessage(
    ChatbotSendMessageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    final text = event.message.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessageModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // 1. Add user message and set typing indicator
    emit(
      state.copyWith(
        messages: [userMessage, ...state.messages],
        isTyping: true,
      ),
    );

    try {
      final transactions =
          homeBloc.state.transactions.whereType<TransactionModel>().toList();
      final isConnected = networkService.isConnected;

      final response = await chatbotService.generateResponse(
        prompt: text,
        transactions: transactions,
        isConnected: isConnected,
      );

      final replyText = response['text'] as String;
      final suggestions = (response['suggestions'] as List<String>?) ?? [];

      final assistantMessage = ChatMessageModel(
        id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
        text: replyText,
        isUser: false,
        timestamp: DateTime.now(),
        suggestions: suggestions,
      );

      emit(
        state.copyWith(
          messages: [assistantMessage, ...state.messages],
          isTyping: false,
          activeSuggestions:
              suggestions.isNotEmpty ? suggestions : state.activeSuggestions,
        ),
      );
    } catch (e) {
      final errorMessage = ChatMessageModel(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Sorry, I ran into an issue processing that. Please try again!',
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [errorMessage, ...state.messages],
          isTyping: false,
        ),
      );
    }
  }

  void _onClearHistory(
    ChatbotClearHistoryEvent event,
    Emitter<ChatbotState> emit,
  ) {
    emit(const ChatbotState());
    add(const ChatbotInitEvent());
  }
}
