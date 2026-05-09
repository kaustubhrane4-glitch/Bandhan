import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/models/profile_model.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../core/network/supabase_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'profile_provider.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepositoryImpl(SupabaseManager.client);
}

@riverpod
Future<ProfileModel?> myProfile(MyProfileRef ref) async {
  final authState = ref.watch(authStateProvider).value;
  if (authState?.user == null) return null;
  
  return ref.read(profileRepositoryProvider).getMyProfile();
}

@riverpod
Future<List<ProfileModel>> dailyMatches(DailyMatchesRef ref) {
  return ref.read(profileRepositoryProvider).getDailyMatches();
}
