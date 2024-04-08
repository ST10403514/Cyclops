import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'forgot_password.dart';
import 'signup_page.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ignore: use_key_in_widget_constructors
  LoginPage({Key? key});

  // Function to handle the login process
  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      // Sign in user with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user's email is verified
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        // Navigate to home page if email is verified
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message if email is not verified
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Email Not Verified'),
              content: const Text(
                  'Please verify your email before logging in. Check your inbox for the verification email.'),
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
    } catch (e) {
      // Show error message if login fails
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
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
        title: const Text('Welcome to Cyclops'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to password reset page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: const Text('Forgot my password'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Validate user input
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  if (email.isNotEmpty && password.isNotEmpty) {
                    signIn(context, email, password); // Call signIn function
                  } else {
                    // Show error message if input is invalid
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Invalid Input'),
                          content: const Text(
                              'Please enter your email and password.'),
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
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text('Sign Up'),
              ),
              const Spacer(), // Add a spacer below the buttons
            ],
          ),
        ),
      ),
    );
  }
}
