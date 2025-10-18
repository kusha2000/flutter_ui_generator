import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Login'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Username',
    prefixIcon: const Icon(Icons.person),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    ),
    SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: const Icon(Icons.lock),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    ),
    SizedBox(height: 24),
    ElevatedButton(
    onPressed: () {
      // Handle login logic
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    child: const Text('Login'),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}