import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputField({super.key, required this.onSend});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.9,
      upperBound: 1.0,
    )..forward();
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = MediaQuery.of(context).size.width / 375;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 8 * scale),
        color: theme.colorScheme.surface,
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 40 * scale, maxHeight: 120 * scale),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _submit(),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 16 * scale),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.2),
                      borderRadius: BorderRadius.circular(24 * scale),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.2),
                      borderRadius: BorderRadius.circular(24 * scale),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
                      borderRadius: BorderRadius.circular(24 * scale),
                    ),

                  ),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(width: 8 * scale),
            ScaleTransition(
              scale: _scaleAnim,
              child: GestureDetector(
                onTapDown: (_) => _animController.reverse(),
                onTapUp: (_) {
                  _animController.forward();
                  _submit();
                },
                child: Container(
                  padding: EdgeInsets.all(12 * scale),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.send, size: 24 * scale, color: theme.colorScheme.onPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
