import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
import 'custom_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  // Function to handle password reset
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show success message
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset Email Sent'),
            content:
                const Text('Please check your inbox to reset your password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error message if email not found or other error occurs
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgotten Password'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Image.asset(
                'assets/logo.png', // Path to your logo image
                width: 150, // Adjust width as needed
                height: 150, // Adjust height as needed
              ),
            ),
            CustomTextField(
              label: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Validate user input
                String email = emailController.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Invalid Email'),
                        content:
                            const Text('Please enter a valid email address.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  resetPassword(context, email); // Call resetPassword function
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 8), // Add spacing between buttons
            TextButton(
              onPressed: () {
                // Navigate back to the login page
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
