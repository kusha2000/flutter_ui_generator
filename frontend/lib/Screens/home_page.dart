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
  // ignore: unused_field
  String _generatedCode = '';
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

  // Generation status
  String _currentService = '';
  int _totalServices = 0;
  int _successfulServices = 0;
  int _failedServices = 0;
  bool _generationComplete = false;

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

    // Listen to text changes to enable/disable the generate button
    _promptController.addListener(() {
      setState(() {});
    });
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
      _generationComplete = false;
      _currentService = 'Initializing...';
      _totalServices = 0;
      _successfulServices = 0;
      _failedServices = 0;
    });

    try {
      final request = http.Request(
        'POST',
        Uri.parse('http://192.168.8.213:8000/generate-ui-stream'),
      );
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({'prompt': prompt});

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String buffer = '';

        await for (var chunk
            in streamedResponse.stream.transform(utf8.decoder)) {
          buffer += chunk;

          // Process complete SSE messages
          while (buffer.contains('\n\n')) {
            final index = buffer.indexOf('\n\n');
            final message = buffer.substring(0, index);
            buffer = buffer.substring(index + 2);

            // Parse SSE message
            if (message.startsWith('data: ')) {
              final jsonStr = message.substring(6);
              try {
                final data = jsonDecode(jsonStr);

                if (data['type'] == 'init') {
                  setState(() {
                    _currentService = data['message'] ?? 'Initializing...';
                  });
                } else if (data['type'] == 'progress') {
                  setState(() {
                    _currentService = data['message'] ?? 'Processing...';
                    if (data['total'] != null) {
                      _totalServices = data['total'];
                    }
                  });
                } else if (data['type'] == 'service_complete') {
                  // Update counters
                  final status = data['status'];
                  if (status == 'success') {
                    setState(() {
                      _successfulServices++;
                    });
                  } else {
                    setState(() {
                      _failedServices++;
                    });
                  }
                } else if (data['type'] == 'complete') {
                  // Final results
                  final results = data['results'] ?? [];
                  final summary = data['summary'] ?? {};

                  setState(() {
                    _totalServices = summary['total_services'] ?? 0;
                    _successfulServices = summary['successful'] ?? 0;
                    _failedServices = summary['failed'] ?? 0;

                    // Get the first successful code
                    for (var result in results) {
                      if (result['success'] == true && result['code'] != null) {
                        _generatedCode = result['code'];
                        break;
                      }
                    }

                    _generationComplete = true;
                    _isGenerating = false;
                  });

                  print(
                      "Generation Summary: Total: $_totalServices, Success: $_successfulServices, Failed: $_failedServices");
                } else if (data['type'] == 'error') {
                  setState(() {
                    _error = data['message'] ?? 'Generation failed';
                    _isGenerating = false;
                    _generationComplete = false;
                  });
                }
              } catch (e) {
                print('Error parsing SSE message: $e');
              }
            }
          }
        }
      } else {
        setState(() {
          _error = 'Failed to generate UI: ${streamedResponse.statusCode}';
          _isGenerating = false;
          _generationComplete = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _isGenerating = false;
        _generationComplete = false;
      });
    }
  }

  Widget _buildStatusRow(
      String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        colors: [Colors.blue.shade400, Colors.purple.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade300.withOpacity(0.5),
                          blurRadius: 15,
                          offset: Offset(0, 8),
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
                              onTap: _isGenerating ||
                                      _promptController.text.isEmpty
                                  ? null
                                  : () {
                                      _stopListening();
                                      _generateUI(_promptController.text);
                                    },
                              child: Center(
                                child: _isGenerating
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                          color: isDark
                              ? AppColorsDark.error
                              : AppColorsLight.error,
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

                  // Info Message / Status Container
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _generationComplete
                            ? (_successfulServices >= 3
                                ? isDark
                                    ? [
                                        AppColorsDark.success.withOpacity(0.15),
                                        AppColorsDark.success.withOpacity(0.1),
                                      ]
                                    : [
                                        AppColorsLight.success.withOpacity(0.1),
                                        AppColorsLight.success
                                            .withOpacity(0.05),
                                      ]
                                : _successfulServices >= 2
                                    ? isDark
                                        ? [
                                            AppColorsDark.warning
                                                .withOpacity(0.15),
                                            AppColorsDark.warning
                                                .withOpacity(0.1),
                                          ]
                                        : [
                                            AppColorsLight.warning
                                                .withOpacity(0.1),
                                            AppColorsLight.warning
                                                .withOpacity(0.05),
                                          ]
                                    : isDark
                                        ? [
                                            AppColorsDark.error
                                                .withOpacity(0.15),
                                            AppColorsDark.error
                                                .withOpacity(0.1),
                                          ]
                                        : [
                                            AppColorsLight.error
                                                .withOpacity(0.1),
                                            AppColorsLight.error
                                                .withOpacity(0.05),
                                          ])
                            : isDark
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
                        color: _generationComplete
                            ? (_successfulServices >= 3
                                ? (isDark
                                    ? AppColorsDark.success
                                    : AppColorsLight.success)
                                : _successfulServices >= 2
                                    ? (isDark
                                        ? AppColorsDark.warning
                                        : AppColorsLight.warning)
                                    : (isDark
                                        ? AppColorsDark.error
                                        : AppColorsLight.error))
                            : (isDark
                                ? AppColorsDark.warning
                                : AppColorsLight.warning),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _generationComplete
                              ? (_successfulServices >= 2
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.warning_amber_rounded)
                              : Icons.info_outline_rounded,
                          color: _generationComplete
                              ? (_successfulServices >= 3
                                  ? (isDark
                                      ? AppColorsDark.success
                                      : AppColorsLight.success)
                                  : _successfulServices >= 2
                                      ? (isDark
                                          ? AppColorsDark.warning
                                          : AppColorsLight.warning)
                                      : (isDark
                                          ? AppColorsDark.error
                                          : AppColorsLight.error))
                              : (isDark
                                  ? AppColorsDark.info
                                  : AppColorsLight.info),
                          size: 48,
                        ),
                        SizedBox(height: 16),
                        if (_generationComplete) ...[
                          Text(
                            _successfulServices >= 2
                                ? 'UI Generated Successfully!'
                                : 'UI Generation Failed',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _successfulServices >= 3
                                      ? (isDark
                                          ? AppColorsDark.success
                                          : AppColorsLight.success)
                                      : _successfulServices >= 2
                                          ? (isDark
                                              ? AppColorsDark.warning
                                              : AppColorsLight.warning)
                                          : (isDark
                                              ? AppColorsDark.error
                                              : AppColorsLight.error),
                                ),
                          ),
                          SizedBox(height: 16),

                          // Status Summary
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColorsDark.surface.withOpacity(0.5)
                                  : AppColorsLight.surface.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildStatusRow(
                                  'Total Services',
                                  _totalServices.toString(),
                                  Icons.apps_rounded,
                                  isDark
                                      ? AppColorsDark.info
                                      : AppColorsLight.info,
                                ),
                                SizedBox(height: 8),
                                _buildStatusRow(
                                  'Successful',
                                  _successfulServices.toString(),
                                  Icons.check_circle_rounded,
                                  isDark
                                      ? AppColorsDark.success
                                      : AppColorsLight.success,
                                ),
                                SizedBox(height: 8),
                                _buildStatusRow(
                                  'Failed',
                                  _failedServices.toString(),
                                  Icons.cancel_rounded,
                                  isDark
                                      ? AppColorsDark.error
                                      : AppColorsLight.error,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _successfulServices >= 2
                                ? 'Please refresh the app and navigate to UI Preview to see your creation!'
                                : 'Most services failed to generate the UI. Please try again with a different prompt.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                          ),
                        ] else ...[
                          Text(
                            'After generating the UI, please refresh the app and navigate to UI Preview to see your creation',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                          ),
                        ],
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _generationComplete &&
                                      _successfulServices >= 2
                                  ? isDark
                                      ? [
                                          AppColorsDark.textSecondary
                                              .withOpacity(0.3),
                                          AppColorsDark.textSecondary
                                              .withOpacity(0.2)
                                        ]
                                      : [
                                          AppColorsLight.textSecondary
                                              .withOpacity(0.3),
                                          AppColorsLight.textSecondary
                                              .withOpacity(0.2)
                                        ]
                                  : isDark
                                      ? AppColorsDark.accentGradient
                                      : AppColorsLight.accentGradient,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow:
                                _generationComplete && _successfulServices >= 2
                                    ? []
                                    : [
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
                                if (_generationComplete) {
                                  // Show toast message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.refresh_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Please refresh the app to view the generated UI',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: isDark
                                          ? AppColorsDark.primary
                                          : AppColorsLight.primary,
                                      duration: Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: EdgeInsets.all(16),
                                    ),
                                  );
                                } else {
                                  // Navigate to preview
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AITypeSection(),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _generationComplete &&
                                              _successfulServices >= 2
                                          ? Icons.refresh_rounded
                                          : Icons.dashboard_rounded,
                                      color: _generationComplete &&
                                              _successfulServices >= 2
                                          ? (isDark
                                              ? AppColorsDark.textSecondary
                                              : AppColorsLight.textSecondary)
                                          : textOnPrimary,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      _generationComplete &&
                                              _successfulServices >= 2
                                          ? 'Refresh App to View'
                                          : 'Go to UI Preview',
                                      style: TextStyle(
                                        color: _generationComplete &&
                                                _successfulServices >= 2
                                            ? (isDark
                                                ? AppColorsDark.textSecondary
                                                : AppColorsLight.textSecondary)
                                            : textOnPrimary,
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
          // Loading Overlay
          if (_isGenerating)
            Container(
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(32),
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColorsDark.surface : AppColorsLight.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Loading Spinner
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: primaryGradient,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(textOnPrimary),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Generating UI',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _currentService,
                          style: TextStyle(
                            color: textOnPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Processing with multiple LLM services...',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColorsDark.textSecondary
                                  : AppColorsLight.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
