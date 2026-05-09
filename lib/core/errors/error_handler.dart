import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'failure.dart';

class ErrorHandler {
  static Future<Failure> handle(dynamic error) async {
    if (error is PostgrestException) {
      if (error.code == '23505') return DuplicateFailure(error.message);
      if (error.code == '42501') return PermissionFailure();
      return ServerFailure(error.message);
    } else if (error is AuthException) {
      return AuthFailure(error.message);
    } else if (error is SocketException) {
      return NetworkFailure();
    } else if (error is TimeoutException) {
      return TimeoutFailure();
    } else {
      await Sentry.captureException(error);
      return UnknownFailure(error.toString());
    }
  }
}

mixin SafeCallMixin {
  Future<T> safeCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      final failure = await ErrorHandler.handle(e);
      throw failure;
    }
  }
}
