import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Scaffold(
    appBar: AppBar(
    title: const Text('Login'),
    backgroundColor: primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    const Text(
    'Welcome Back',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
    ),
    const SizedBox(height: 24),
    TextFormField(
    decoration: const InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    ),
    keyboardType: TextInputType.emailAddress,
    ),
    const SizedBox(height: 16),
    TextFormField(
    decoration: const InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    suffixIcon: Icon(Icons.visibility_off),
    ),
    obscureText: true,
    ),
    const SizedBox(height: 24),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: onPrimary,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    onPressed: () {},
    child: const Text('Login'),
    ),
    const SizedBox(height: 12),
    TextButton(
    style: TextButton.styleFrom(
    foregroundColor: primary,
    ),
    onPressed: () {},
    child: const Text('Forgot Password?'),
    ),
    const SizedBox(height: 24),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text("Don't have an account?"),
    TextButton(
    style: TextButton.styleFrom(
    foregroundColor: primary,
    ),
    onPressed: () {},
    child: const Text('Sign Up'),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    );
  }
}