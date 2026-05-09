import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/interest_model.dart';
import '../../domain/repositories/interest_repository.dart';
import '../../../../core/errors/error_handler.dart';

class InterestRepositoryImpl with SafeCallMixin implements InterestRepository {
  final SupabaseClient _client;

  InterestRepositoryImpl(this._client);

  @override
  Future<void> sendInterest(String toUserId, {String? message}) => safeCall(() async {
    final fromUserId = _client.auth.currentUser?.id;
    if (fromUserId == null) throw Exception('Not logged in');

    await _client.from('interests').insert({
      'from_user': fromUserId,
      'to_user': toUserId,
      'message': message,
      'status': 'sent',
    });
  });

  @override
  Future<void> updateInterestStatus(String interestId, String status) => safeCall(() async {
    await _client.from('interests').update({'status': status}).eq('id', interestId);
  });

  @override
  Stream<List<InterestModel>> watchReceivedInterests() {
    final userId = _client.auth.currentUser?.id;
    return _client
        .from('interests')
        .stream(primaryKey: ['id'])
        .eq('to_user', userId ?? '')
        .map((data) => data.map((json) => InterestModel.fromJson(json)).toList());
  }

  @override
  Stream<int> watchReceivedCount() {
    return watchReceivedInterests().map((list) => list.where((i) => i.status == 'sent').length);
  }
}
