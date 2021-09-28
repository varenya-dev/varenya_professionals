/*
 * Service implementation for chat module.
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
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
