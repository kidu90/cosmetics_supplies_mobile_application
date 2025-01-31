import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/screens/home_screen.dart';
import 'package:cosmetic_supplies_application/shared/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Static credentials
  final String correctEmail = "text@gmail.com";
  final String correctPassword = "masha123";

  void _login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print("Entered Email: $email"); // Debugging
    print("Entered Password: $password");

    if (email == correctEmail && password == correctPassword) {
      print("Login successful! Navigating to HomeScreen...");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      print("Invalid credentials entered.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid email or password"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Sign in to continue",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                CustomTextField(
                  label: 'Email',
                  placeholder: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  placeholder: 'Enter your password',
                  obscureText: true,
                  controller: passwordController,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login, // Call the login function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16),
                        selectionColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
