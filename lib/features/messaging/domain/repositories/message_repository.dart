import '../../../shared/models/message_model.dart';

abstract class MessageRepository {
  Future<void> sendMessage(String conversationId, String content);
  Stream<List<MessageModel>> watchMessages(String conversationId);
  Future<void> markAsRead(String conversationId);
}
