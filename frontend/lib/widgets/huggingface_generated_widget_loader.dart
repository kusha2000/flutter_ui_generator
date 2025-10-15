import 'package:flutter/material.dart';

class HuggingFaceGeneratedWidget extends StatelessWidget {
  const HuggingFaceGeneratedWidget({super.key});

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
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    const SizedBox(height: 32),
    Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Username',
    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Password',
    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: TextStyle(fontSize: 16),
    ),
    child: const Text('Register'),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 32),
    TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
    padding: const EdgeInsets.all(0),
    ),
    child: const Text('Already have an account? Login'),
    ),
    ],
    ),
    ),
    ),
    );
  }
}