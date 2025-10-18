import 'package:flutter/material.dart';
import 'package:frontend/Screens/home_page.dart';
import 'package:frontend/widgets/huggingface_generated_widget.dart';
import 'package:frontend/widgets/openrouter_generated_widget.dart';
import 'package:frontend/widgets/gemini_generated_widget.dart';
import 'package:frontend/widgets/cohere_generated_widget.dart';
import 'package:frontend/widgets/groq_generated_widget.dart';
import 'package:frontend/widgets/training_model_widget.dart';
import 'package:frontend/theme/app_colors_light.dart';
import 'package:frontend/theme/app_colors_dark.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AITypeSection extends StatelessWidget {
  const AITypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final backgroundColor =
        isDark ? AppColorsDark.background : AppColorsLight.background;
    final primaryGradient =
        isDark ? AppColorsDark.primaryGradient : AppColorsLight.primaryGradient;
    final textPrimary =
        isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary =
        isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColorsDark.background,
                    AppColorsDark.surface,
                  ]
                : [
                    AppColorsLight.surface,
                    AppColorsLight.background,
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
                            colors: primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? AppColorsDark.shadowMedium
                                  : AppColorsLight.shadowMedium,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: isDark
                              ? AppColorsDark.textOnPrimary
                              : AppColorsLight.textOnPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: textSecondary,
                            ),
                          ),
                          Text(
                            'AI Assistant',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 80,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: primaryGradient,
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
                          isDark,
                          'Gemini',
                          'gemini-2.5-flash-preview-05-20',
                          Icons.auto_awesome,
                          LinearGradient(
                            colors: isDark
                                ? [
                                    AppColorsDark.primary,
                                    AppColorsDark.primaryDark
                                  ]
                                : [
                                    AppColorsLight.primary,
                                    AppColorsLight.primaryDark
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
                          isDark,
                          'Groq',
                          'groq/compound',
                          Icons.chat_bubble_outline,
                          LinearGradient(
                            colors: isDark
                                ? [Color(0xFF14B8A6), Color(0xFF0F766E)]
                                : [Color(0xFF14B8A6), Color(0xFF0D9488)],
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
                          isDark,
                          'Cohere',
                          'command-r-plus-08-2024',
                          Icons.psychology,
                          LinearGradient(
                            colors: isDark
                                ? [Color(0xFF06B6D4), Color(0xFF0891B2)]
                                : [Color(0xFF22D3EE), Color(0xFF06B6D4)],
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
                          isDark,
                          'HuggingFace',
                          'Qwen2.5-Coder-7B-Instruct',
                          Icons.smart_toy,
                          LinearGradient(
                            colors: isDark
                                ? [AppColorsDark.warning, Color(0xFFF97316)]
                                : [
                                    AppColorsLight.warning,
                                    AppColorsLight.warningLight
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
                          isDark,
                          'OpenRouter',
                          'llama-3.3-70b-instruct',
                          Icons.code,
                          LinearGradient(
                            colors: isDark
                                ? [
                                    AppColorsDark.secondary,
                                    AppColorsDark.secondaryDark
                                  ]
                                : [
                                    AppColorsLight.secondary,
                                    AppColorsLight.secondaryDark
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
                          isDark,
                          'My Training Model',
                          'Training Model',
                          Icons.psychology_alt,
                          LinearGradient(
                            colors: isDark
                                ? [AppColorsDark.accent, Color(0xFFDC2626)]
                                : [
                                    AppColorsLight.accent,
                                    AppColorsLight.accentLight
                                  ],
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
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    final cardBackground =
        isDark ? AppColorsDark.cardBackground : AppColorsLight.cardBackground;
    final textPrimary =
        isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary =
        isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final cardBorder =
        isDark ? AppColorsDark.cardBorder : AppColorsLight.cardBorder;
    final shadowColor =
        isDark ? AppColorsDark.shadowLight : AppColorsLight.shadowLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorder),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
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
                        color: isDark
                            ? AppColorsDark.textOnPrimary
                            : AppColorsLight.textOnPrimary,
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
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: textSecondary,
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
                        color: isDark
                            ? AppColorsDark.textOnPrimary
                            : AppColorsLight.textOnPrimary,
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
