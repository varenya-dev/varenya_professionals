/*
 * Service implementation for chat module.
 */
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/models/chat/chat/chat_model.dart';
import 'package:varenya_professionals/models/chat/chat_thread/chat_thread_model.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/utils/logger.util.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid uuid = new Uuid();

  Future<String> createNewThread(String userId) async {
    DocumentReference threadDocumentReference =
        this._firestore.collection('threads').doc();

    String loggedInUserId = this._auth.currentUser!.uid;

    List<String> participants = [
      userId,
      loggedInUserId,
    ];

    ChatThread chatThread = new ChatThread(
      id: threadDocumentReference.id,
      participants: participants,
      messages: [],
    );

    await this
        ._firestore
        .collection('threads')
        .doc(chatThread.id)
        .set(chatThread.toJson());

    return threadDocumentReference.id;
  }

  /*
   * Method to fetch all threads the user is part of.
   */
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllThreads() => this
      ._firestore
      .collection('threads')
      .where("participants", arrayContains: this._auth.currentUser!.uid)
      .snapshots();

  /*
   * Method to fetch all chats in a given thread.
   * @param id Thread ID to be fetched.
   */
  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToThread(String id) =>
      this._firestore.collection('threads').doc(id).snapshots();

  /*
   * Method to save a chat message in a given thread.
   * @param message Message text to be saved.
   * @param thread Thread where the message is to be saved.
   */
  Future<void> sendMessage(String message, ChatThread thread) async {
    // Create the chat message object based on the message.
    Chat chatMessage = new Chat(
      id: uuid.v4(),
      userId: this._auth.currentUser!.uid,
      message: message,
      timestamp: DateTime.now(),
    );

    // Add it to the chat list in the thread.
    thread.messages.add(chatMessage);

    // Convert all to JSON and update the same in firestore.
    Map<String, dynamic> jsonData = thread.toJson();
    jsonData['messages'] =
        jsonData['messages'].map((Chat message) => message.toJson()).toList();
    await this._firestore.collection("threads").doc(thread.id).set(jsonData);

    await this._sendChatNotification(thread.id, message);
  }

  /*
   * Method to delete a chat message in a given thread.
   * @param id ID for the message to be deleted.
   * @param thread Thread from which the message is needed to be deleted.
   */
  Future<void> deleteMessage(String id, ChatThread thread) async {
    // Filter out the message list using the message ID.
    thread.messages = thread.messages.where((chat) => chat.id != id).toList();

    // Convert all to JSON and update the same in firestore.
    Map<String, dynamic> jsonData = thread.toJson();
    jsonData['messages'] =
        jsonData['messages'].map((Chat message) => message.toJson()).toList();
    await this._firestore.collection("threads").doc(thread.id).set(jsonData);
  }

  /*
   * Close chat thread in firestore.
   */
  Future<void> closeThread(ChatThread thread) async =>
      await this._firestore.collection("threads").doc(thread.id).delete();

  Future<void> openDummyThread() async {
    DocumentReference threadDocumentReference =
        this._firestore.collection('threads').doc();

    List<String> participants = [
      "2Mp0U8gyHISRWJlPklzcxnoTKCV2",
      "AogJeR814fgYkTzTvNSwnQx8o8p1"
    ];

    ChatThread chatThread = new ChatThread(
      id: threadDocumentReference.id,
      participants: participants,
      messages: [],
    );

    await this
        ._firestore
        .collection('threads')
        .doc(chatThread.id)
        .set(chatThread.toJson());
  }

  Future<void> _sendChatNotification(String threadId, String message) async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken = await this._auth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$ENDPOINT/notification/chat");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Preparing body for the request.
      Map<String, String> body = {
        "threadId": threadId,
        "message": message,
      };

      // Send the post request to the server.
      http.Response response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      // Check for any errors.
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }
    } catch (error, stackTrace) {
      log.e("ChatService:_sendChatNotification Error", error, stackTrace);
    }
  }
}
