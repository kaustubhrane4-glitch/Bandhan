import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await _client.auth.signInWithOtp(
      phone: phoneNumber,
    );
  }

  @override
  Future<AuthResponse> verifyOtp(String phoneNumber, String token) async {
    return await _client.auth.verifyOTP(
      phone: phoneNumber,
      token: token,
      type: OtpType.sms,
    );
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
