import 'package:flutter/material.dart';

class GroqGeneratedWidget extends StatelessWidget {
  const GroqGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
    appBar: AppBar(
    title: const Text('Register'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    const Text(
    'Create an Account',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
    ),
    const SizedBox(height: 24),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Full Name',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    ),
    const SizedBox(height: 16),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    keyboardType: TextInputType.emailAddress,
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Confirm Password',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    ),
    const SizedBox(height: 24),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    onPressed: () {},
    child: const Text('Register'),
    ),
    const SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text('Already have an account?'),
    TextButton(
    style: TextButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
    ),
    onPressed: () {},
    child: const Text('Login'),
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