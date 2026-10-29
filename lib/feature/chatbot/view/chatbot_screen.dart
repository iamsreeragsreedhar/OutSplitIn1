import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:out_split_in/core/service_locator/di.dart';
import 'package:out_split_in/core/services/network_service.dart';
import 'package:out_split_in/feature/chatbot/view_model/chatbot/chatbot_bloc.dart';
import 'package:out_split_in/feature/chatbot/view_model/chatbot/chatbot_event.dart';
import 'package:out_split_in/feature/chatbot/view_model/chatbot/chatbot_state.dart';
import 'package:out_split_in/feature/chatbot/widgets/chat_input_field.dart';
import 'package:out_split_in/feature/chatbot/widgets/chat_message_bubble.dart';
import 'package:out_split_in/feature/chatbot/widgets/chat_quick_suggestion_chips.dart';
import 'package:out_split_in/feature/chatbot/widgets/chat_typing_indicator.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context, String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    context.read<ChatbotBloc>().add(ChatbotSendMessageEvent(trimmed));
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final networkService = sl<NetworkService>();
    final isConnected = networkService.isConnected;

    return BlocProvider(
      create: (context) => sl<ChatbotBloc>()..add(const ChatbotInitEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: isDark
                  ? const Color(0xFF141E1A)
                  : Colors.white,
              elevation: 0,
              scrolledUnderElevation: 1,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: isDark ? Colors.white : const Color(0xFF18231F),
                ),
                onPressed: () => context.pop(),
              ),
              titleSpacing: 0,
              title: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0BA874), Color(0xFF067A55)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OutSplitIn Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF18231F),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isConnected
                                  ? const Color(0xFF0BA874)
                                  : const Color(0xFFF59E0B),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isConnected
                                ? 'AI Financial Guide • Online'
                                : 'Local Assistant • Offline Ready',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFA1AFA9)
                                  : const Color(0xFF84918B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Clear Chat',
                  icon: Icon(
                    Icons.restart_alt_rounded,
                    size: 22,
                    color: isDark ? Colors.white70 : const Color(0xFF84918B),
                  ),
                  onPressed: () {
                    context.read<ChatbotBloc>().add(const ChatbotClearHistoryEvent());
                  },
                ),
                const SizedBox(width: 6),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatbotBloc, ChatbotState>(
                      builder: (context, state) {
                        return ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (state.isTyping && index == 0) {
                              return ChatTypingIndicator(isDark: isDark);
                            }
                            final messageIndex =
                                state.isTyping ? index - 1 : index;
                            final message = state.messages[messageIndex];
                            return ChatMessageBubble(
                              message: message,
                              isDark: isDark,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  BlocBuilder<ChatbotBloc, ChatbotState>(
                    buildWhen: (prev, curr) =>
                        prev.activeSuggestions != curr.activeSuggestions,
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 4),
                        child: ChatQuickSuggestionChips(
                          suggestions: state.activeSuggestions,
                          isDark: isDark,
                          onSelect: (prompt) => _sendMessage(context, prompt),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<ChatbotBloc, ChatbotState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: ChatInputField(
                          controller: _textController,
                          isDark: isDark,
                          isTyping: state.isTyping,
                          onSend: () => _sendMessage(
                            context,
                            _textController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
