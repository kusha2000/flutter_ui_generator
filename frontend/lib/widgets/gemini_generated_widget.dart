import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
    appBar: AppBar(
    title: Text(
    'Login',
    style: TextStyle(color: colorScheme.onPrimary),
    ),
    backgroundColor: colorScheme.primary,
    elevation: 0,
    centerTitle: true,
    ),
    body: SingleChildScrollView(
    child: ConstrainedBox(
    constraints: BoxConstraints(
    minHeight: screenSize.height - (AppBar().preferredSize.height + MediaQuery.of(context).padding.top),
    ),
    child: Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [colorScheme.primary.withOpacity(0.8), colorScheme.surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),
    padding: const EdgeInsets.all(24.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Icon(
    Icons.lock_outline,
    size: 96,
    color: colorScheme.onPrimary,
    ),
    const SizedBox(height: 24),
    Text(
    'Welcome Back!',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: colorScheme.onPrimary,
    ),
    ),
    const SizedBox(height: 32),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
    prefixIcon: Icon(Icons.email_outlined, color: colorScheme.onSurfaceVariant),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: colorScheme.surfaceVariant.withOpacity(0.7),
    floatingLabelStyle: TextStyle(color: colorScheme.primary),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide.none,
    ),
    ),
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(color: colorScheme.onSurface),
    cursorColor: colorScheme.primary,
    ),
    const SizedBox(height: 16),
    TextFormField(
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Password',
    hintText: 'Enter your password',
    prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: colorScheme.surfaceVariant.withOpacity(0.7),
    floatingLabelStyle: TextStyle(color: colorScheme.primary),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide.none,
    ),
    ),
    style: TextStyle(color: colorScheme.onSurface),
    cursorColor: colorScheme.primary,
    ),
    const SizedBox(height: 8),
    Align(
    alignment: Alignment.centerRight,
    child: TextButton(
    onPressed: () {
      // Handle forgot password
    },
    style: TextButton.styleFrom(
    foregroundColor: colorScheme.onPrimary,
    textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
    child: const Text('Forgot Password?'),
    ),
    ),
    const SizedBox(height: 24),
    ElevatedButton(
    onPressed: () {
      // Handle login
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.secondary,
    foregroundColor: colorScheme.onSecondary,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
    ),
    elevation: 4,
    ),
    child: const Text(
    'Login',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    ),
    const SizedBox(height: 24),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    "Don't have an account?",
    style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.8)),
    ),
    TextButton(
    onPressed: () {
      // Handle sign up
    },
    style: TextButton.styleFrom(
    foregroundColor: colorScheme.onPrimary,
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    child: const Text('Sign Up'),
    ),
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