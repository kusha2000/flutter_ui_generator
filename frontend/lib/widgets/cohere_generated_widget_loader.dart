import 'package:flutter/material.dart';

class CohereGeneratedWidget extends StatelessWidget {
  const CohereGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Register'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    child: Column(
    children: [
    const Text(
    'Create an Account',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 24),
    TextFormField(
    decoration: const InputDecoration(labelText: 'Username'),
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: const InputDecoration(labelText: 'Password'),
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: const InputDecoration(labelText: 'Confirm Password'),
    ),
    const SizedBox(height: 24),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    onPressed: () {},
    child: const Text('Register'),
    ),
    const SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text('Already have an account?'),
    const SizedBox(width: 8),
    InkWell(
    onTap: () {},
    child: const Text(
    'Log In',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
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