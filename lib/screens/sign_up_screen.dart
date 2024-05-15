import 'package:flutter/material.dart';
import 'package:persona_plan/db_helper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  String _errorMessage = '';

  void _signUp() async {
    final dbHelper = DatabaseHelper.instance;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    final userExists = await dbHelper.getUser(username);
    if (userExists != null) {
      setState(() {
        _errorMessage = 'User already exists. Please log in.';
      });
      return; // Exit the method if user already exists
    }

    try {
      final id = await dbHelper.insertUser({
        'username': username,
        'password': password,
        'email': email,
      });
      if (id != null) {
        _showSuccessMessage(); // Show success message
        Navigator.of(context).pop(); // Go back to the login screen
      }
    } catch (e) {
      setState(() {
        if (userExists != null) {
          setState(() {
            _errorMessage = 'User already exists. Please log in.';
          });
          return; // Exit the method if user already exists
        } else {
          _errorMessage = 'Sign up failed. Please try again.';
        }
      });
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User successfully added!'),
        backgroundColor: Colors.green, // You can customize the color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText
: true,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
