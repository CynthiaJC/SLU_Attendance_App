import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coordinator_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Placeholder test credentials — remove once real auth is connected
  static const String _testEmail = 'user@slu.com';
  static const String _testPassword = 'slu12345';

  final _emailController = TextEditingController(text: _testEmail);
  final _passwordController = TextEditingController(text: _testPassword);

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
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final isIntern = _selectedRoleIndex == 0;

      // Define our placeholder credentials
      const internEmail = 'intern@team.com';
      const internPassword = 'password123';

      const coordinatorEmail = 'coordinator@team.com';
      const coordinatorPassword = 'admin123';

      if (isIntern) {
        // Check Intern Credentials
        if (email == internEmail && password == internPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successful! Welcome Intern.'),
              backgroundColor: Colors.green,
            ),
          );
          // TODO: Navigate to Intern Dashboard screen here
        } else {
          _showErrorSnackBar('Invalid Intern credentials! Try intern@team.com / password123');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials. Use the pre-filled test login.')),
        );
      }
    }
  }