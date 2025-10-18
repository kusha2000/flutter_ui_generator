import 'package:flutter/material.dart';

class CohereGeneratedWidget extends StatelessWidget {
  const CohereGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: const Text('Login'),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text(
    'Welcome Back!',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 16),
    TextFormField(
    decoration: const InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
    ),
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: const InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
    ),
    ),
    const SizedBox(height: 24),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    ),
    onPressed: () {},
    child: const Text('Login'),
    ),
    ],
    ),
    ),
    ),
    );
  }
}