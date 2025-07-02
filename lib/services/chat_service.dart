import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class ChatService {
  static const String _baseUrl = 'http://192.168.203.154:5000';

  Future<MessageModel> sendMessage(String userInput) async {
    final url = Uri.parse('$_baseUrl/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': userInput}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MessageModel(
        userMsg: userInput,
        botMsg: data['response'] ?? '',
        emotion: data['emotion'] ?? 'neutral',
        confidence: (data['confidence'] ?? 0.0).toDouble(),
        audioUrl: data['audio'] ?? '',
        timestamp: DateTime.now(),
      );
    } else {
      throw Exception('Backend Error: ${response.body}');
    }
  }
}
