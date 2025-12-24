import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'inventory_screen.dart';

class LoginScreen extends StatelessWidget {
  // Controllers to read email & password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Auth service instance
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 32),
            ),

            const SizedBox(height: 20),

            // Email field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            // Password field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: () async {
                final error = await authService.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => InventoryScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
              child: const Text('Login'),
            ),

            // Go to signup screen
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupScreen()),
                );
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
