import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  final _auth      = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  /// Save the user message, return its reference
  Future<DocumentReference?> saveUserMessage(
      String sessionId, MessageModel message) async {
    if (_uid == null) return null;
    final sessionRef = _firestore
        .collection('users').doc(_uid)
        .collection('sessions').doc(sessionId);

    await sessionRef.set({'startTime': message.timestamp}, SetOptions(merge: true));
    return sessionRef.collection('messages').add(message.toMap());
  }

  /// Update with bot response (including audioUrl)
  Future<void> updateBotReply(
      DocumentReference msgDoc, MessageModel botResponse) async {
    await msgDoc.update({
      'botMsg':     botResponse.botMsg,
      'emotion':    botResponse.emotion,
      'confidence': botResponse.confidence,
      'audioUrl':   botResponse.audioUrl,
    });
  }

  Future<List<MessageModel>> getMessages(String sessionId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final snapshot = await _firestore
        .collection('users').doc(uid)
        .collection('sessions').doc(sessionId)
        .collection('messages')
        .orderBy('timestamp')
        .get();
    return snapshot.docs
        .map((d) => MessageModel.fromMap(d.data()))
        .toList();
  }
}