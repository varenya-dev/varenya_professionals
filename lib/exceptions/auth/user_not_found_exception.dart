class UserNotFoundException implements Exception {
  String message;

  UserNotFoundException({required this.message});
}
