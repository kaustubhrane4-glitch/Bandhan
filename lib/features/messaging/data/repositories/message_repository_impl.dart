import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/message_model.dart';
import '../../domain/repositories/message_repository.dart';
import '../../../../core/errors/error_handler.dart';

class MessageRepositoryImpl with SafeCallMixin implements MessageRepository {
  final SupabaseClient _client;

  MessageRepositoryImpl(this._client);

  @override
  Future<void> sendMessage(String conversationId, String content) => safeCall(() async {
    final senderId = _client.auth.currentUser?.id;
    if (senderId == null) throw Exception('Not logged in');

    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
    });
  });

  @override
  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((data) => data.map((json) => MessageModel.fromJson(json)).toList());
  }

  @override
  Future<void> markAsRead(String conversationId) => safeCall(() async {
    final userId = _client.auth.currentUser?.id;
    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .neq('sender_id', userId ?? '');
  });
}
