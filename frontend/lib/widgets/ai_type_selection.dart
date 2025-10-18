import 'package:flutter/material.dart';
import 'package:frontend/Screens/home_page.dart';
import 'package:frontend/widgets/huggingface_generated_widget.dart';
import 'package:frontend/widgets/openrouter_generated_widget.dart';
import 'package:frontend/widgets/gemini_generated_widget.dart';
import 'package:frontend/widgets/cohere_generated_widget.dart';
import 'package:frontend/widgets/groq_generated_widget.dart';
import 'package:frontend/widgets/training_model_widget.dart';

class AITypeSection extends StatelessWidget {
  const AITypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const SizedBox(height: 5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UIGeneratorHomePage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo.shade400,
                              Colors.indigo.shade600
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.shade200.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose Your',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          const Text(
                            'AI Assistant',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 80,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo.shade400,
                                  Colors.deepPurple.shade400
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // AI Assistant Buttons
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildAIButton(
                          context,
                          'Gemini',
                          'gemini-2.5-flash-preview-05-20',
                          Icons.auto_awesome,
                          LinearGradient(
                            colors: [
                              Colors.indigo.shade400,
                              Colors.indigo.shade600
                            ],
                          ),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GeminiGeneratedWidget(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAIButton(
                          context,
                          'Groq',
                          'groq/compound',
                          Icons.chat_bubble_outline,
                          LinearGradient(
                            colors: [
                              Colors.teal.shade400,
                              Colors.teal.shade600
                            ],
                          ),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroqGeneratedWidget(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAIButton(
                          context,
                          'Cohere',
                          'command-r-plus-08-2024',
                          Icons.psychology,
                          LinearGradient(
                            colors: [
                              Colors.cyan.shade400,
                              Colors.cyan.shade600
                            ],
                          ),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CohereGeneratedWidget(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAIButton(
                          context,
                          'HuggingFace',
                          'Qwen2.5-Coder-7B-Instruct',
                          Icons.smart_toy,
                          LinearGradient(
                            colors: [
                              Colors.amber.shade400,
                              Colors.orange.shade500
                            ],
                          ),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HuggingFaceGeneratedWidget(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAIButton(
                          context,
                          'OpenRouter',
                          'llama-3.3-70b-instruct',
                          Icons.code,
                          LinearGradient(
                            colors: [
                              Colors.deepPurple.shade400,
                              Colors.deepPurple.shade600
                            ],
                          ),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OpenRouterGeneratedWidget(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAIButton(
                          context,
                          'My Training Model',
                          'Training Model',
                          Icons.psychology_alt,
                          LinearGradient(
                            colors: [Colors.pink.shade400, Colors.red.shade400],
                          ),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GeneratedWidget(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: gradient.colors.first.withOpacity(0.1),
              highlightColor: gradient.colors.first.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.colors.first.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
