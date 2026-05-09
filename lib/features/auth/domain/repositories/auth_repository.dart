import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<AuthResponse> verifyOtp(String phoneNumber, String token);
  Future<void> signOut();
  User? get currentUser;
  Stream<AuthState> get authStateChanges;
}
