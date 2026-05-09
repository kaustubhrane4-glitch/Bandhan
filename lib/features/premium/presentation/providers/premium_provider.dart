import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/premium_repository_impl.dart';
import '../../domain/repositories/premium_repository.dart';
import '../../../../core/network/supabase_client.dart';

part 'premium_provider.g.dart';

@riverpod
PremiumRepository premiumRepository(PremiumRepositoryRef ref) {
  return PremiumRepositoryImpl(SupabaseManager.client);
}
