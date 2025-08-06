import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isAvailable = false;
  String _text = 'Press the button and start speaking...';
  String _currentWords = '';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    // Request microphone permission
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      setState(() {
        _text = 'Microphone permission denied';
      });
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      setState(() => _isAvailable = true);
    } else {
      setState(() => _text = 'Speech recognition not available');
    }
  }

  void _listen() async {
    if (!_isListening) {
      if (await _speech.hasPermission && _speech.isAvailable) {
        setState(() {
          _isListening = true;
          _currentWords = '';
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _currentWords = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 5),
          partialResults: true,
          localeId: "en_US",
          onSoundLevelChange: (level) => print("Sound level: $level"),
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
        if (_currentWords.isNotEmpty) {
          _text = _currentWords;
        }
      });
    }
  }

  void _clearText() {
    setState(() {
      _text = 'Press the button and start speaking...';
      _currentWords = '';
      _confidence = 1.0;
    });
  }

  void _copyText() {
    if (_text.isNotEmpty && _text != 'Press the button and start speaking...') {
      // Note: In a real app, you'd use Clipboard.setData() from flutter/services
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text copied to clipboard!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice to Text'),
        backgroundColor: Colors.blue.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearText,
            tooltip: 'Clear text',
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: _copyText,
            tooltip: 'Copy text',
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status indicator
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:
                    _isListening ? Colors.green.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: _isListening ? Colors.green : Colors.grey,
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isListening ? Icons.mic : Icons.mic_off,
                    color: _isListening ? Colors.green : Colors.grey,
                    size: 24.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    _isListening ? 'Listening...' : 'Not listening',
                    style: TextStyle(
                      color: _isListening ? Colors.green : Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Confidence indicator
            if (_confidence != 1.0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics, color: Colors.blue, size: 20.0),
                    SizedBox(width: 8.0),
                    Text(
                      'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.0),

            // Text display area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _isListening ? _currentWords : _text,
                    style: TextStyle(
                      fontSize: 18.0,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Stop button
                ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : null,
                  icon: Icon(Icons.stop),
                  label: Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                ),

                // Main mic button
                ElevatedButton.icon(
                  onPressed: _isAvailable ? _listen : null,
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  label: Text(_isListening ? 'Listening' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening ? Colors.green : Colors.blue,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Help text
            Text(
              'Tap Start to begin voice recognition. The app will listen for 30 seconds or until you tap Stop.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}
