import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/arguments/chat.argument.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/chat/chat/chat.model.dart' as CM;
import 'package:varenya_professionals/models/chat/thread/thread.model.dart';
import 'package:varenya_professionals/models/server_user/server_user.model.dart';
import 'package:varenya_professionals/services/chat.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/chat/chat_bubble.widget.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';
import 'package:varenya_professionals/widgets/common/custom_text_area.widget.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  static const routeName = "/chat";

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late ChatService _chatService;
  late Thread _chatThread;
  List<Chat> _chats = [];

  final TextEditingController _chatController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey();

  String? _threadId;
  ServerUser? _serverUser;

  @override
  void initState() {
    super.initState();

    // Injecting the required services.
    this._chatService = Provider.of<ChatService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the text controllers.
    this._chatController.dispose();
  }

  /*
   * Method to handle chat message submission.
   */
  Future<void> onMessageSubmit() async {
    // Check the validity of the form.
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    // Save the message in database in the given thread.
    try {
      await this
          ._chatService
          .sendMessage(this._chatController.text, this._chatThread);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("Chat:onMessageSubmit", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  /*
   * Method to handle deleting chat message.
   */
  Future<void> onMessageDelete(String id) async {
    try {
      // Delete the message from the thread.
      await this._chatService.deleteMessage(id, this._chatThread);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("Chat:onMessageDelete", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  void _openThreadDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Do you want to delete this thread?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await this._onThreadClose();
            },
            child: Text('YES'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('NO'),
          ),
        ],
      ),
    );
  }

  /*
   * Method to handle closing a thread.
   */
  Future<void> _onThreadClose() async {
    // Close the thread and pop off from the chat screen.
    await this._chatService.closeThread(this._chatThread);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (this._serverUser == null || this._threadId == null) {
      ChatArgument chatArgument =
          ModalRoute.of(context)!.settings.arguments as ChatArgument;

      this._serverUser = chatArgument.serverUser;
      this._threadId = chatArgument.threadId;
    }

    AppBar appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.black54,
      leading: null,
      automaticallyImplyLeading: false,
      title: ListTile(
        leading: ProfilePictureWidget(
          imageUrl: _getImageUrl(),
          size: MediaQuery.of(context).size.width * 0.1,
        ),
        title: _getUserName(),
      ),
      actions: [
        IconButton(
          onPressed: () => this._openThreadDeleteDialog(context),
          icon: Icon(
            Icons.delete_outline,
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: this._chatService.listenToThread(this._threadId!),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasError) {
                log.e("Chat Error", snapshot.error, snapshot.stackTrace);
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              this._chats.clear();

              if (snapshot.data!.data() != null) {
                this._chatThread = Thread.fromJson(snapshot.data!.data()!);
                this._chatThread.messages.sort(
                    (CM.Chat a, CM.Chat b) => a.timestamp.compareTo(b.timestamp));
              }

              ScrollController controller = ScrollController();

              SchedulerBinding.instance!.addPostFrameCallback((_) {
                controller.jumpTo(controller.position.maxScrollExtent);
              });

              return Expanded(
                child: ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  itemCount: this._chatThread.messages.length,
                  itemBuilder: (context, index) {
                    CM.Chat chat = this._chatThread.messages[index];
                    return ChatBubble(
                      chat: chat,
                      onDelete: this.onMessageDelete,
                    );
                  },
                ),
              );
            },
          ),
          Container(
            child: Form(
              key: this._formKey,
              child: CustomTextArea(
                textFieldController: this._chatController,
                helperText: "Message...",
                validators: [
                  RequiredValidator(errorText: "Please type in your message")
                ],
                textInputType: TextInputType.text,
                suffixIcon: OfflineBuilder(
                  connectivityBuilder:
                      (BuildContext context, ConnectivityResult result, _) {
                    final bool connected = result != ConnectivityResult.none;

                    return IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Palette.primary,
                      ),
                      onPressed: connected ? this.onMessageSubmit : null,
                    );
                  },
                  child: SizedBox(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _getUserName() {
    return this._serverUser!.role == Roles.MAIN
        ? Text(
            this._serverUser!.randomName!.randomName,
            style: TextStyle(
              color: Colors.white,
            ),
          )
        : Text(
            "Dr. ${this._serverUser!.doctor!.fullName}",
            style: TextStyle(
              color: Colors.white,
            ),
          );
  }

  String _getImageUrl() => this._serverUser!.role == Roles.MAIN
      ? ''
      : this._serverUser!.doctor!.imageUrl;
}
