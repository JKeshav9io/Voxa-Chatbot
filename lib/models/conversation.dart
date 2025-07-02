import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  final String sessionId;
  final DateTime startTime;

  ConversationModel({
    required this.sessionId,
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'startTime': startTime,
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      sessionId: map['sessionId'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
    );
  }
}
