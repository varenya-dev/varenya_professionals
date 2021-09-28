/*
 * Service implementation for chat module.
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:varenya_professionals/models/chat/chat/chat_model.dart';
import 'package:varenya_professionals/models/chat/chat_thread/chat_thread_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid uuid = new Uuid();

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
}
