import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class ChatbotInitEvent extends ChatbotEvent {
  const ChatbotInitEvent();
}

class ChatbotSendMessageEvent extends ChatbotEvent {
  final String message;

  const ChatbotSendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatbotClearHistoryEvent extends ChatbotEvent {
  const ChatbotClearHistoryEvent();
}
