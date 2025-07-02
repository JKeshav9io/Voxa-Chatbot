import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String userMsg;
  final String botMsg;
  final String emotion;
  final double confidence;
  final String audioUrl;
  final DateTime timestamp;

  MessageModel({
    required this.userMsg,
    required this.botMsg,
    required this.emotion,
    required this.confidence,
    required this.audioUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userMsg':    userMsg,
      'botMsg':     botMsg,
      'emotion':    emotion,
      'confidence': confidence,
      'audioUrl':   audioUrl,
      'timestamp':  timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      userMsg:    map['userMsg']     ?? '',
      botMsg:     map['botMsg']      ?? '',
      emotion:    map['emotion']     ?? 'neutral',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      audioUrl:   map['audioUrl']    ?? '',
      timestamp:  (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
