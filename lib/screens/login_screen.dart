import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ChatScreen(sessionId: null),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = MediaQuery.of(context).size.width / 375;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24 * scale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40 * scale),
                Text(
                  'Welcome Back 👋',
                  style: theme.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32 * scale),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, size: 20 * scale),
                        ),
                        validator: (val) =>
                        val == null || !val.contains('@') ? 'Enter a valid email' : null,
                      ),
                      SizedBox(height: 16 * scale),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, size: 20 * scale),
                        ),
                        obscureText: true,
                        validator: (val) =>
                        val == null || val.length < 6 ? 'Password must be at least 6 characters' : null,
                      ),
                      SizedBox(height: 24 * scale),
                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14 * scale),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8 * scale)),
                          ),
                          child: Text('Login', style: theme.textTheme.titleMedium),
                        ),
                      ),
                      SizedBox(height: 16 * scale),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignupScreen()),
                        ),
                        child: Text(
                          "Don't have an account? Sign up",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(height: 40 * scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}