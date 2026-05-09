import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/network/supabase_client.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(SupabaseManager.client);
}

@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@riverpod
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.user ?? ref.watch(authRepositoryProvider).currentUser;
}
