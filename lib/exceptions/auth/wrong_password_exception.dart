class WrongPasswordException implements Exception {
  String message;

  WrongPasswordException({required this.message});
}
