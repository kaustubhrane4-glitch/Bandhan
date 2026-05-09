import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../core/errors/error_handler.dart';

class ProfileRepositoryImpl with SafeCallMixin implements ProfileRepository {
  final SupabaseClient _client;

  ProfileRepositoryImpl(this._client);

  @override
  Future<ProfileModel?> getMyProfile() => safeCall(() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromJson(response);
  });

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _client.from('profiles').upsert(
      profile.toJson()..addAll({'user_id': userId}),
      onConflict: 'user_id',
    );
  }

  @override
  Future<List<ProfileModel>> getDailyMatches() async {
    // In a real app, this would call an RPC or a specific table for daily matches
    final response = await _client
        .from('profiles')
        .select()
        .limit(10); // Placeholder logic

    return (response as List).map((json) => ProfileModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProfileModel>> searchProfiles({
    int? minAge,
    int? maxAge,
    List<String>? religions,
    List<String>? cities,
  }) async {
    var query = _client.from('profiles').select();

    if (religions != null && religions.isNotEmpty) {
      query = query.inFilter('religion', religions);
    }
    if (cities != null && cities.isNotEmpty) {
      query = query.inFilter('city', cities);
    }
    
    // Age filtering would require calculating age from DOB in Postgres or fetching and filtering
    // For production, we'd use a Postgres function or a view
    
    final response = await query;
    return (response as List).map((json) => ProfileModel.fromJson(json)).toList();
  }
}
