import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
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
                  'Create Account 🚀',
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
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14 * scale),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8 * scale)),
                          ),
                          child: Text('Sign Up', style: theme.textTheme.titleMedium),
                        ),
                      ),
                      SizedBox(height: 16 * scale),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Already have an account? Login',
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
