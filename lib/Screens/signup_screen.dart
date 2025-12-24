import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatelessWidget {
  // Controllers to read user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Auth service instance
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Email input
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            // Password input
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            // Sign up button
            ElevatedButton(
              onPressed: () async {
                final error = await authService.signUp(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signup successful')),
                  );

                  // Go back to Login screen
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
