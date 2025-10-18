import 'package:flutter/material.dart';
import 'package:frontend/widgets/ai_type_selection.dart';
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
        Uri.parse('http://172.26.120.94:8000/generate-ui'),
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Text(
              'AI UI Generator',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard_customize, color: Colors.blue.shade700),
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
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200.withOpacity(0.5),
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
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Describe your UI with text or voice and watch the magic happen',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        ScaleTransition(
                          scale: _isListening
                              ? _pulseAnimation
                              : AlwaysStoppedAnimation(1.0),
                          child: Material(
                            color: _isListening
                                ? Colors.green
                                : Colors.blue.shade400,
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
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      _isListening ? 'Stop' : 'Voice',
                                      style: TextStyle(
                                        color: Colors.white,
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
                      decoration: InputDecoration(
                        hintText:
                            'e.g., Create a login form with email and password fields...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.blue.shade400, width: 2),
                        ),
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),

                    if (_isListening || _voiceText.isNotEmpty) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isListening
                              ? Colors.green.shade50
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isListening
                                ? Colors.green.shade300
                                : Colors.blue.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isListening ? Icons.mic : Icons.check_circle,
                              color: _isListening
                                  ? Colors.green
                                  : Colors.blue.shade700,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _isListening ? 'Listening...' : _voiceText,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade200.withOpacity(0.5),
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
                                                  Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Generating...',
                                        style: TextStyle(
                                          color: Colors.white,
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
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Generate UI',
                                        style: TextStyle(
                                          color: Colors.white,
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
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error,
                          style: TextStyle(color: Colors.red.shade700),
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
                    colors: [Colors.amber.shade50, Colors.orange.shade50],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade300, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue.shade600,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'After generating the UI, please refresh the app and navigate to UI Preview to see your creation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade500,
                            Colors.indigo.shade700
                          ],
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
                                    color: Colors.white, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Go to Dashboard',
                                  style: TextStyle(
                                    color: Colors.white,
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
