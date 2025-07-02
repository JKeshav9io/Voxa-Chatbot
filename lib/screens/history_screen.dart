import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = MediaQuery.of(context).size.width / 375;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "User not logged in",
            style: theme.textTheme.displayMedium,
          ),
        ),
      );
    }

    final sessionsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .orderBy('startTime', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat History'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 2 * scale,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: sessionsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No previous chats found.',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          final sessions = snapshot.data!.docs;
          return Padding(
            padding: EdgeInsets.all(12 * scale),
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final sessionId = session.id;
                final time = (session['startTime'] as Timestamp).toDate();
                final formatted = DateFormat.yMMMd().add_jm().format(time);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8 * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * scale),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12 * scale,
                      horizontal: 16 * scale,
                    ),
                    leading: Icon(
                      Icons.chat_bubble_outline,
                      size: 28 * scale,
                      color: theme.colorScheme.secondary,
                    ),
                    title: Text(
                      'Session ${sessions.length - index}',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      formatted,
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20 * scale,
                      color: theme.colorScheme.onSurface,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(sessionId: sessionId),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}