import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Placeholder test credentials — remove once real auth is connected
  static const String _internTestEmail = 'intern@slu.com';
  static const String _internTestPassword = 'intern123';
  static const String _coordinatorTestEmail = 'coordinator@slu.com';
  static const String _coordinatorTestPassword = 'coordinator123';

  final _emailController = TextEditingController(text: _internTestEmail);
  final _passwordController = TextEditingController(text: _internTestPassword);
  
  int _selectedRoleIndex = 0; // 0 = Intern, 1 = Coordinator
  bool _isPasswordObscured = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final role = _selectedRoleIndex == 0 ? 'Intern' : 'Coordinator';
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // TODO: replace with real backend authentication
      final expectedEmail = _selectedRoleIndex == 0 ? _internTestEmail : _coordinatorTestEmail;
      final expectedPassword = _selectedRoleIndex == 0 ? _internTestPassword : _coordinatorTestPassword;

      if (email == expectedEmail && password == expectedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logging in as $role...')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials. Use the pre-filled test login.')),
        );
      }
    }
  }