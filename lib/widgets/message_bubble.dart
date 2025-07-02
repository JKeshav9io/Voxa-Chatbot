import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../themes/light_theme.dart';

class MessageBubble extends StatefulWidget {
  final bool isUser;
  final String userMsg;
  final String botMsg;
  final String emotion;
  final double confidence;
  final String audioUrl;

  const MessageBubble({
    super.key,
    required this.isUser,
    required this.userMsg,
    required this.botMsg,
    required this.emotion,
    required this.confidence,
    required this.audioUrl,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerComplete.listen((_) => setState(() => _isPlaying = false));

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  Future<void> _togglePlay() async {
    final url = widget.audioUrl.trim();
    if (url.isEmpty) return;

    final fullUrl = url.startsWith('http') ? url : 'http://192.168.203.154:5000$url';

    if (_isPlaying) {
      await _player.stop();
      setState(() => _isPlaying = false);
    } else {
      try {
        await _player.play(UrlSource(fullUrl));
        setState(() => _isPlaying = true);
      } catch (e) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = MediaQuery.of(context).size.width / LightTheme.designWidth;
    final text = widget.isUser ? widget.userMsg : widget.botMsg;
    final alignment = widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = widget.isUser
        ? theme.colorScheme.primary.withOpacity(0.1)
        : theme.colorScheme.secondary.withOpacity(0.1);

    return SlideTransition(
      position: _slideAnim,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 4 * scale,
              bottom: 2 * scale,
              left: widget.isUser ? 60 * scale : 12 * scale,
              right: widget.isUser ? 12 * scale : 60 * scale,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 8 * scale),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16 * scale),
                topRight: Radius.circular(16 * scale),
                bottomLeft: Radius.circular(widget.isUser ? 16 * scale : 4 * scale),
                bottomRight: Radius.circular(widget.isUser ? 4 * scale : 16 * scale),
              ),
            ),
            child: Text(text, style: theme.textTheme.bodyLarge),
          ),
          if (!widget.isUser && widget.audioUrl.isNotEmpty)
            GestureDetector(
              onTap: _togglePlay,
              child: Padding(
                padding: EdgeInsets.only(left: 12 * scale, top: 4 * scale, right: 60 * scale),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_isPlaying ? Icons.stop_circle : Icons.play_circle, size: 20 * scale, color: theme.colorScheme.primary),
                    SizedBox(width: 6 * scale),
                    Text('Play', style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
