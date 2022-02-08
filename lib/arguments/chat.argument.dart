import 'package:varenya_professionals/models/server_user/server_user.model.dart';

class ChatArgument {
  final ServerUser serverUser;
  final String threadId;

  ChatArgument({
    required this.serverUser,
    required this.threadId,
  });
}