import 'package:flutter/material.dart';

class GeminiGeneratedWidget extends StatelessWidget {
  const GeminiGeneratedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
    appBar: AppBar(
    title: const Text('Create Account'),
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    elevation: 0, // Modern apps often have flat app bars
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(24.0), // Increased padding for a spacious feel
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    // Header Text
    Text(
    'Join us today!',
    style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
    ),
    textAlign: TextAlign.center,
    ),
    const SizedBox(height: 16),
    Text(
    'Create an account to unlock exclusive features.',
    style: TextStyle(
    fontSize: 16,
    color: colorScheme.onSurfaceVariant,
    ),
    textAlign: TextAlign.center,
    ),
    const SizedBox(height: 32),

    // Name Field
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Full Name',
    hintText: 'Enter your full name',
    prefixIcon: const Icon(Icons.person_outline),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    keyboardType: TextInputType.name,
    textCapitalization: TextCapitalization.words,
    ),
    const SizedBox(height: 16),

    // Email Field
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Email Address',
    hintText: 'Enter your email',
    prefixIcon: const Icon(Icons.email_outlined),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    keyboardType: TextInputType.emailAddress,
    ),
    const SizedBox(height: 16),

    // Password Field
    TextFormField(
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Password',
    hintText: 'Enter your password',
    prefixIcon: const Icon(Icons.lock_outline),
    suffixIcon: IconButton(
    icon: const Icon(Icons.visibility_off_outlined), // Placeholder for toggle
    onPressed: () {
      // Implement password visibility toggle
    },
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    ),
    const SizedBox(height: 16),

    // Confirm Password Field
    TextFormField(
    obscureText: true,
    decoration: InputDecoration(
    labelText: 'Confirm Password',
    hintText: 'Re-enter your password',
    prefixIcon: const Icon(Icons.lock_reset_outlined),
    suffixIcon: IconButton(
    icon: const Icon(Icons.visibility_off_outlined), // Placeholder for toggle
    onPressed: () {
      // Implement password visibility toggle
    },
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    ),
    const SizedBox(height: 32),

    // Register Button
    ElevatedButton(
    onPressed: () {
      // Handle registration logic
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4, // Subtle elevation
    ),
    child: const Text(
    'Register',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
    ),
    const SizedBox(height: 24),

    // Login Link
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    'Already have an account?',
    style: TextStyle(color: colorScheme.onSurfaceVariant),
    ),
    TextButton(
    onPressed: () {
      // Navigate to login page
    },
    style: TextButton.styleFrom(
    foregroundColor: colorScheme.primary,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    ),
    child: const Text(
    'Login',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    );
  }
}