import 'package:flutter/material.dart';
import 'package:frontend/widgets/ai_type_selection.dart';
import 'package:frontend/theme/app_colors_light.dart';
import 'package:frontend/theme/app_colors_dark.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class UIGeneratorHomePage extends StatefulWidget {
  const UIGeneratorHomePage({super.key});

  @override
  _UIGeneratorHomePageState createState() => _UIGeneratorHomePageState();
}

class _UIGeneratorHomePageState extends State<UIGeneratorHomePage>
    with SingleTickerProviderStateMixin {
  String _generatedCode = '';
  Map<String, dynamic> _uiJson = {};
  String _error = '';
  final TextEditingController _promptController = TextEditingController();

  // Voice recognition
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isAvailable = false;
  String _voiceText = '';
  bool _isGenerating = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _initSpeech() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      setState(() {
        _error = 'Microphone permission denied';
      });
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      setState(() => _isAvailable = true);
    }
  }

  void _listen() async {
    if (!_isListening) {
      if (await _speech.hasPermission && _speech.isAvailable) {
        setState(() {
          _isListening = true;
          _voiceText = '';
          _error = '';
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _voiceText = val.recognizedWords;
            _promptController.text = _voiceText;
          }),
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 3),
          partialResults: true,
          localeId: "en_US",
          cancelOnError: true,
        );
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _generateUI(String prompt) async {
    setState(() {
      _isGenerating = true;
      _error = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.8.213:8000/generate-ui'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _generatedCode = jsonData['code'] ?? '';
          _uiJson = jsonData['ui_json'] ?? {};
          _error = jsonData['error'] ?? '';
          _isGenerating = false;
        });
        print("Code Data: ${jsonData['code']}");
        print("Json Data: ${jsonData['ui_json']}");
      } else {
        setState(() {
          _error = 'Failed to generate UI: ${response.statusCode}';
          _isGenerating = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _isGenerating = false;
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _promptController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final primaryGradient =
        isDark ? AppColorsDark.primaryGradient : AppColorsLight.primaryGradient;
    final primary = isDark ? AppColorsDark.primary : AppColorsLight.primary;
    final textOnPrimary =
        isDark ? AppColorsDark.textOnPrimary : AppColorsLight.textOnPrimary;
    final surface = isDark ? AppColorsDark.surface : AppColorsLight.surface;
    final surfaceVariant =
        isDark ? AppColorsDark.surfaceVariant : AppColorsLight.surfaceVariant;
    final cardBorder =
        isDark ? AppColorsDark.cardBorder : AppColorsLight.cardBorder;
    final divider = isDark ? AppColorsDark.divider : AppColorsLight.divider;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: primaryGradient,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.auto_awesome, color: textOnPrimary, size: 24),
            ),
            SizedBox(width: 6),
            Text(
              'UI Generator',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          // Theme Toggle Button
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isDark ? surface : surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? cardBorder : divider,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  themeProvider.toggleTheme();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: primary,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        isDark ? 'Light' : 'Dark',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.dashboard_customize, color: primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AITypeSection(),
                ),
              );
            },
            tooltip: 'Dashboard',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Section
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColorsDark.shadowMedium
                          : AppColorsLight.shadowMedium,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Beautiful UIs',
                      style: TextStyle(
                        color: textOnPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Describe your UI with text or voice and watch the magic happen',
                      style: TextStyle(
                        color: textOnPrimary.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Input Section
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColorsDark.cardBackground
                      : AppColorsLight.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColorsDark.cardBorder
                        : AppColorsLight.cardBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColorsDark.shadowLight
                          : AppColorsLight.shadowLight,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Describe Your UI',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        ScaleTransition(
                          scale: _isListening
                              ? _pulseAnimation
                              : AlwaysStoppedAnimation(1.0),
                          child: Material(
                            color: _isListening
                                ? (isDark
                                    ? AppColorsDark.success
                                    : AppColorsLight.success)
                                : primary,
                            borderRadius: BorderRadius.circular(12),
                            elevation: _isListening ? 4 : 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _isAvailable ? _listen : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isListening ? Icons.stop : Icons.mic,
                                      color: textOnPrimary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      _isListening ? 'Stop' : 'Voice',
                                      style: TextStyle(
                                        color: textOnPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Text Input
                    TextField(
                      controller: _promptController,
                      maxLines: 4,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText:
                            'e.g., Create a login form with email and password fields...',
                      ),
                    ),

                    if (_isListening) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isListening
                              ? (isDark
                                  ? AppColorsDark.success.withOpacity(0.1)
                                  : AppColorsLight.success.withOpacity(0.1))
                              : (isDark
                                  ? AppColorsDark.info.withOpacity(0.1)
                                  : AppColorsLight.info.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isListening
                                ? (isDark
                                    ? AppColorsDark.success
                                    : AppColorsLight.success)
                                : (isDark
                                    ? AppColorsDark.info
                                    : AppColorsLight.info),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isListening ? Icons.mic : Icons.check_circle,
                              color: _isListening
                                  ? (isDark
                                      ? AppColorsDark.success
                                      : AppColorsLight.success)
                                  : (isDark
                                      ? AppColorsDark.info
                                      : AppColorsLight.info),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            _isListening
                                ? Expanded(
                                    child: Text(
                                      'Listening...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  )
                                : SizedBox(
                                    height: 1,
                                  )
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 8),

                    SizedBox(height: 24),

                    // Generate Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: primaryGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? AppColorsDark.shadowMedium
                                : AppColorsLight.shadowMedium,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _isGenerating || _promptController.text.isEmpty
                              ? null
                              : () {
                                  _stopListening();
                                  _generateUI(_promptController.text);
                                },
                          child: Center(
                            child: _isGenerating
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  textOnPrimary),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Generating...',
                                        style: TextStyle(
                                          color: textOnPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.auto_awesome,
                                          color: textOnPrimary),
                                      SizedBox(width: 8),
                                      Text(
                                        'Generate UI',
                                        style: TextStyle(
                                          color: textOnPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Error Message
              if (_error.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColorsDark.error.withOpacity(0.1)
                        : AppColorsLight.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isDark ? AppColorsDark.error : AppColorsLight.error,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: isDark
                              ? AppColorsDark.error
                              : AppColorsLight.error),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error,
                          style: TextStyle(
                            color: isDark
                                ? AppColorsDark.error
                                : AppColorsLight.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Info Message - Always Visible
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColorsDark.warning.withOpacity(0.15),
                            AppColorsDark.accentLight.withOpacity(0.15),
                          ]
                        : [
                            AppColorsLight.warning.withOpacity(0.1),
                            AppColorsLight.accentLight.withOpacity(0.1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isDark ? AppColorsDark.warning : AppColorsLight.warning,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: isDark ? AppColorsDark.info : AppColorsLight.info,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'After generating the UI, please refresh the app and navigate to UI Preview to see your creation',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            height: 1.5,
                          ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? AppColorsDark.accentGradient
                              : AppColorsLight.accentGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? AppColorsDark.shadowMedium
                                : AppColorsLight.shadowMedium,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AITypeSection(),
                              ),
                            );
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.dashboard_rounded,
                                    color: textOnPrimary, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Go to UI Preview',
                                  style: TextStyle(
                                    color: textOnPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
