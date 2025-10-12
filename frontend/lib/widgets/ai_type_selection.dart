import 'package:flutter/material.dart';
import 'package:frontend/widgets/chatgpt_generated_widget_loader.dart';
import 'package:frontend/widgets/claude_generated_widget_loader.dart';
import 'package:frontend/widgets/copilot_generated_widget_loader.dart';
import 'package:frontend/widgets/deepseek_generated_widget_loader.dart';
import 'package:frontend/widgets/gemini_generated_widget_loader.dart';
import 'package:frontend/widgets/grok_generated_widget_loader.dart';
import 'package:frontend/widgets/groq_generated_widget_loader.dart';

class AITypeSection extends StatelessWidget {
  const AITypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
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
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
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
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        const Text(
                          'Choose Your',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                          ),
                        ),
                        const Text(
                          'AI Assistant',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF3F51B5)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 48),

                // AI Assistant Buttons
                Expanded(
                  child: Column(
                    children: [
                      _buildAIButton(
                        context,
                        'Gemini',
                        'Google\'s powerful AI',
                        Icons.auto_awesome,
                        const LinearGradient(
                          colors: [Color(0xFF4285F4), Color(0xFF34A853)],
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
                        'Groq\'s conversational AI',
                        Icons.chat_bubble_outline,
                        const LinearGradient(
                          colors: [Color(0xFF10A37F), Color(0xFF1A7F64)],
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
                        'Grok',
                        'X\'s witty AI assistant',
                        Icons.psychology,
                        const LinearGradient(
                          colors: [Color(0xFF1DA1F2), Color(0xFF0D8BD9)],
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GrokGeneratedWidget(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildAIButton(
                        context,
                        'Claude',
                        'Anthropic\'s helpful AI',
                        Icons.smart_toy,
                        const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClaudeGeneratedWidget(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildAIButton(
                        context,
                        'Copilot',
                        'Microsoft\'s coding companion',
                        Icons.code,
                        const LinearGradient(
                          colors: [Color(0xFF0078D4), Color(0xFF106EBE)],
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CopilotGeneratedWidget(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildAIButton(
                        context,
                        'DeepSeek',
                        'Advanced reasoning AI',
                        Icons.psychology_alt,
                        const LinearGradient(
                          colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeepSeekGeneratedWidget(),
                            ),
                          );
                        },
                      ),
                    ],
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
          borderRadius: BorderRadius.circular(16),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
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
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
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
