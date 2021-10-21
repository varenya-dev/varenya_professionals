import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/models/chat/chat/chat_model.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';

class ChatBubbleWidget extends StatelessWidget {
  final Chat chat;
  final Function onDelete;

  const ChatBubbleWidget({
    Key? key,
    required this.chat,
    required this.onDelete,
  }) : super(key: key);

  void _openDeleteDialog(BuildContext context) {
    String formattedMessage = this.chat.message.length > 15
        ? "${this.chat.message.substring(0, 15)}..."
        : this.chat.message;
    displayBottomSheet(
      context,
      Wrap(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    formattedMessage,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Do you want to delete this message?',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await this.onDelete(this.chat.id);
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
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider state, _) {
        bool userCheck = this.chat.userId == state.user.uid;
        return GestureDetector(
          onLongPress: userCheck
              ? () {
            this._openDeleteDialog(context);
          }
              : null,
          child: Container(
            margin: EdgeInsets.all(
              10.0,
            ),
            alignment: userCheck ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment:
              userCheck ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    10.0,
                  ),
                  decoration: BoxDecoration(
                    color: userCheck ? Colors.black38 : Colors.yellow,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Text(
                    this.chat.message,
                    style: TextStyle(
                      color: userCheck ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  child: Text(
                    DateFormat.yMd()
                        .add_jm()
                        .format(
                      this.chat.timestamp.toLocal(),
                    )
                        .toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}