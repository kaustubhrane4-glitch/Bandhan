abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('No internet connection. Please check your network.');
}

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}

class DuplicateFailure extends Failure {
  DuplicateFailure(String message) : super(message);
}

class PermissionFailure extends Failure {
  PermissionFailure() : super('You don\'t have permission to do this.');
}

class TimeoutFailure extends Failure {
  TimeoutFailure() : super('Request timed out. Please try again.');
}

class UnknownFailure extends Failure {
  UnknownFailure(String message) : super(message);
}
