import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'intern_dashboard.dart'; // Make sure to import your InternDashboard file here
import 'coordinator_main_screen.dart';
import 'intern_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  

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

      // Check for valid credential (user@slu.com with any password)
      if (email == 'user@slu.com') {
        // Navigate to InternDashboard and replace current route
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InternDashboard(),
          ),
      final password = _passwordController.text.trim();

      // TODO: replace with real backend authentication
      if (email == _testEmail && password == _testPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logging in as $role...')),
        );

        if (_selectedRoleIndex == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CoordinatorMainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InternMainScreen()),
          );
        }
      } else {
        // Show error snackbar for invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials. Use user@slu.com to login.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically adjust accent color based on user role context
    final themeColor = _selectedRoleIndex == 0 ? Colors.indigo : Colors.teal;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // App Branding Area
                Icon(Icons.g_translate_outlined, size: 64, color: themeColor),
                const SizedBox(height: 16),
                Text(
                  'Global Intern Tracker',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage and track seamlessly across borders.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // 1. Role Selection Mechanism
                CupertinoSlidingSegmentedControl<int>(
                  groupValue: _selectedRoleIndex,
                  backgroundColor: Colors.grey.shade200,
                  thumbColor: themeColor,
                  children: {
                    0: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Intern Portal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedRoleIndex == 0 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    1: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Coordinator',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedRoleIndex == 1 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _selectedRoleIndex = value ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Email Input Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Work Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Input Field with Visibility Toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Remember Me & Forgot Password Layout row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: themeColor,
                          onChanged: (value) => setState(() => _rememberMe = value ?? false),
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle Forgot Password routing contextually
                      },
                      onPressed: () {},
                      child: Text('Forgot Password?', style: TextStyle(color: themeColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Primary Action Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedRoleIndex == 0 ? 'Sign In as Intern' : 'Sign In as Coordinator',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),

                // Divider line for social providers
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or continue with', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // OAuth Options (Google & LinkedIn)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text('Google'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.work_outline, size: 20),
                        label: const Text('LinkedIn'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Language Selector Simulation at Footer
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.language, size: 20, color: Colors.grey),
                  label: const Text('English (US)', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
}
