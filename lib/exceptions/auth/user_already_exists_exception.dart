class UserAlreadyExistsException implements Exception {
  String message;

  UserAlreadyExistsException({required this.message});
}
