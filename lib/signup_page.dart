// Import necessary packages
import 'package:flutter/material.dart';
import 'custom_text_field.dart'; // Import the custom text field file
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication

class SignupPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const SignupPage({Key? key});

  // Function to handle the signup process
  Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
      // Check password strength
      if (!isPasswordStrong(password)) {
        // Show error message if password is not strong
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Weak Password'),
              content: const Text(
                  'Please enter a password containing at least 8 characters with a mix of letters, numbers, and special characters.'),
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
        return;
      }

      // Create user account with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification to the user
      User? user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();

      // Show success message and prompt user to verify their email
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup Successful'),
            content: const Text(
                'A verification email has been sent to your email address. Please verify your email to complete the signup process.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Navigate to login page
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error message if signup fails
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup Failed'),
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

  // Function to check password strength
  bool isPasswordStrong(String password) {
    // Define password strength criteria
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= 8;

    // Return true if all criteria are met
    return hasUppercase &&
        hasLowercase &&
        hasDigits &&
        hasSpecialCharacters &&
        hasMinLength;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false, // Hide the default back button
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
              label: 'Full Name',
              controller: TextEditingController(),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Validate user input
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (email.isEmpty ||
                    !email.contains('@') ||
                    !isPasswordStrong(password)) {
                  // Show error message if input is invalid
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Invalid Input'),
                        content: const Text(
                            'Please enter a valid email address and a password containing at least 8 characters with a mix of letters, numbers, and special characters.'),
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
                  signUp(context, email, password); // Call signUp function
                }
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 8), // Add spacing between buttons
            TextButton(
              onPressed: () {
                // Navigate back to the login page
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
