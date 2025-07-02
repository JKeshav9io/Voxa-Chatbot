import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/chat_screen.dart';
import '../screens/history_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final scale = MediaQuery.of(context).size.width / 375;
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16 * scale),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24 * scale),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28 * scale,
                    backgroundColor: colorScheme.onPrimary,
                    child: Icon(Icons.chat, size: 32 * scale, color: colorScheme.primary),
                  ),
                  SizedBox(width: 12 * scale),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.email ?? 'Guest User',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4 * scale),
                        Text(
                          'View Profile',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8 * scale),
                children: [
                  _buildTile(
                    icon: Icons.chat_bubble_outline,
                    label: 'New Chat',
                    color: colorScheme.primary,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ChatScreen(sessionId: null)),
                    ),
                    theme: theme,
                    scale: scale,
                  ),
                  _buildTile(
                    icon: Icons.history,
                    label: 'Chat History',
                    color: colorScheme.secondary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatHistoryScreen()),
                    ),
                    theme: theme,
                    scale: scale,
                  ),
                ],
              ),
            ),
            Divider(thickness: 1 * scale),
            _buildTile(
              icon: Icons.logout,
              label: 'Logout',
              color: colorScheme.error,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                );
              },
              theme: theme,
              scale: scale,
            ),
            SizedBox(height: 16 * scale),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required ThemeData theme,
    required double scale,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 4 * scale),
      leading: Icon(icon, size: 24 * scale, color: color),
      title: Text(label, style: theme.textTheme.bodyLarge),
      onTap: onTap,
      horizontalTitleGap: 8 * scale,
    );
  }
}
