// lib/screens/chat_screen.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';
import '../services/firestore_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/app_drawer.dart';

class ChatScreen extends StatefulWidget {
  final String? sessionId;
  const ChatScreen({super.key, this.sessionId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const _apiHost = 'http://192.168.203.154:5000';
  final _auth = FirebaseAuth.instance;
  final _scrollController = ScrollController();
  final _firestoreService = FirestoreService();

  late String _sessionId;
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _sessionId = widget.sessionId
        ?? DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _sendMessage(String userInput) async {
    if (userInput.trim().isEmpty) return;
    setState(() => _isBotTyping = true);
    _scrollToBottom();

    final userMsg = MessageModel(
      userMsg: userInput,
      botMsg: '',
      emotion: '',
      confidence: 0,
      audioUrl: '',
      timestamp: DateTime.now(),
    );
    final docRef = await _firestoreService.saveUserMessage(_sessionId, userMsg);
    if (docRef == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please log in')));
      setState(() => _isBotTyping = false);
      return;
    }

    try {
      final allMsgs = await _firestoreService.getMessages(_sessionId);
      final history = allMsgs
          .where((m) => m.botMsg.isNotEmpty)
          .toList()
          .reversed
          .take(8)
          .toList()
          .reversed
          .map((m) => {'user': m.userMsg, 'bot': m.botMsg})
          .toList();

      final res = await http
          .post(
        Uri.parse('$_apiHost/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userInput, 'history': history}),
      )
          .timeout(const Duration(seconds: 20));

      print('API RESPONSE: ${res.statusCode} ${res.body}');

      final data = jsonDecode(res.body);

      final botMsg = MessageModel(
        userMsg: '',
        botMsg: data['response'] ?? '',
        emotion: data['emotion'] ?? 'neutral',
        confidence: (data['confidence'] ?? 0.0).toDouble(),
        audioUrl: data['audio'] ?? '',
        timestamp: DateTime.now(),
      );

      await _firestoreService.updateBotReply(docRef, botMsg);
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('⚠️ Request timed out')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isBotTyping = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        backgroundColor: theme.colorScheme.primary,
      ),
      drawer: const AppDrawer(),
      body: uid == null
          ? Center(child: Text('Please log in', style: theme.textTheme.displayMedium))
          : Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface.withOpacity(0.9),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: _buildMessageList(uid),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ChatInputField(onSend: _sendMessage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(String uid) {
    final theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .doc(_sessionId)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final exchanges = snap.data!.docs
            .map((d) => MessageModel.fromMap(d.data()! as Map<String, dynamic>))
            .toList();

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: exchanges.length + (_isBotTyping ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) {
            if (i == exchanges.length && _isBotTyping) {
              return Align(
                alignment: Alignment.centerLeft,
                child: AnimatedOpacity(
                  opacity: _isBotTyping ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Typing…', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                  ),
                ),
              );
            }
            final m = exchanges[i];
            return Column(
              crossAxisAlignment: m.userMsg.isNotEmpty
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                MessageBubble(
                  isUser: true,
                  userMsg: m.userMsg,
                  botMsg: '',
                  emotion: '',
                  confidence: 0,
                  audioUrl: '',
                ),
                if (m.botMsg.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  MessageBubble(
                    isUser: false,
                    userMsg: '',
                    botMsg: m.botMsg,
                    emotion: m.emotion,
                    confidence: m.confidence,
                    audioUrl: m.audioUrl,
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
