import 'package:flutter/material.dart';

class OpenRouterGeneratedWidget extends StatelessWidget {
  const OpenRouterGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Register'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    const SizedBox(height: 24),
    const Text(
    'Create an account',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16),
    TextFormField(
    decoration: const InputDecoration(
    labelText: 'Name',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.person),
    ),
    ),
    const SizedBox(height: 16),
    TextFormField(
    decoration: const InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.email),
    ),
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: const InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
    ),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    onPressed: () {},
    child: const Text('Register'),
    ),
    const SizedBox(height: 8),
    TextButton(
    style: TextButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
    ),
    onPressed: () {},
    child: const Text('Already have an account? Login'),
    ),
    ],
    ),
    ),
    ),
    );
  }
}