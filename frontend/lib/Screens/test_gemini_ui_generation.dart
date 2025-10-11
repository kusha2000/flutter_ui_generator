import 'package:flutter/material.dart';
import 'package:frontend/widgets/ai_type_selection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TestGeminiUIGeneration extends StatefulWidget {
  const TestGeminiUIGeneration({super.key});

  @override
  _TestGeminiUIGenerationState createState() => _TestGeminiUIGenerationState();
}

class _TestGeminiUIGenerationState extends State<TestGeminiUIGeneration> {
  bool _showCodePreview = true;
  String _generatedCode = '';
  Map<String, dynamic> _uiJson = {};
  String _error = '';
  final TextEditingController _promptController = TextEditingController();

  Future<void> _generateUI(String prompt) async {
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
        });
        print("Code Data:${jsonData['code']}");
        print("Json Data:${jsonData['ui_json']}");
      } else {
        setState(() {
          _error = 'Failed to generate UI: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
      });
    }
  }

  Widget _buildUIFromJson(Map<String, dynamic> json) {
    try {
      print('Building widget: ${json['type']}');

      switch (json['type']) {
        case 'Scaffold':
          // Extract the body content instead of returning a full Scaffold
          Widget? body = json['properties']?['body'] != null
              ? _buildWidget(json['properties']['body'])
              : Container();

          // For preview, we'll show the body content wrapped in a card
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show app bar title if exists
                  if (json['properties']?['appBar'] != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: _parseColor(json['properties']['appBar']
                                ['properties']?['backgroundColor']) ??
                            Colors.blue,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: json['properties']['appBar']['properties']
                                  ?['title'] !=
                              null
                          ? _buildWidget(json['properties']['appBar']
                              ['properties']['title'])
                          : Text('Title',
                              style: TextStyle(color: Colors.white)),
                    ),
                  if (json['properties']?['appBar'] != null)
                    SizedBox(height: 16),
                  // Show body content
                  body,
                ],
              ),
            ),
          );

        case 'AppBar':
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _parseColor(json['properties']?['backgroundColor']) ??
                  Colors.blue,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: json['properties']?['title'] != null
                ? _buildWidget(json['properties']['title'])
                : Text('Title', style: TextStyle(color: Colors.white)),
          );

        case 'Padding':
          EdgeInsets padding = EdgeInsets.all(16.0);
          if (json['properties']?['padding'] != null) {
            final paddingData = json['properties']['padding'];
            if (paddingData is Map && paddingData['all'] != null) {
              padding = EdgeInsets.all(paddingData['all'].toDouble());
            }
          }
          return Padding(
            padding: padding,
            child: json['properties']?['child'] != null
                ? _buildWidget(json['properties']['child'])
                : Container(),
          );

        case 'Column':
          List<Widget> children = [];
          if (json['properties']?['children'] != null) {
            final childrenData =
                json['properties']['children'] as List<dynamic>;
            children =
                childrenData.map((child) => _buildWidget(child)).toList();
          }

          MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
          if (json['properties']?['mainAxisAlignment'] == 'center') {
            mainAxisAlignment = MainAxisAlignment.center;
          }

          return Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );

        case 'TextFormField':
          InputDecoration decoration = InputDecoration();
          bool obscureText = false;
          TextInputType keyboardType = TextInputType.text;

          if (json['properties']?['decoration'] != null) {
            final decorationData = json['properties']['decoration'];
            String? labelText = decorationData['labelText'];

            OutlineInputBorder? border;
            if (decorationData['border'] != null) {
              final borderData = decorationData['border'];
              if (borderData['type'] == 'OutlineInputBorder') {
                double borderRadius =
                    borderData['properties']?['borderRadius']?.toDouble() ??
                        4.0;
                border = OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                );
              }
            }

            decoration = InputDecoration(
              labelText: labelText,
              border: border,
            );
          }

          if (json['properties']?['obscureText'] == true) {
            obscureText = true;
          }

          if (json['properties']?['keyboardType'] == 'emailAddress') {
            keyboardType = TextInputType.emailAddress;
          }

          return TextFormField(
            decoration: decoration,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          );

        case 'Form':
          List<Widget> children = [];
          if (json['properties']?['child'] != null) {
            // If Form has a single child
            children = [_buildWidget(json['properties']['child'])];
          } else if (json['properties']?['children'] != null) {
            // If Form has multiple children
            final childrenData =
                json['properties']['children'] as List<dynamic>;
            children =
                childrenData.map((child) => _buildWidget(child)).toList();
          }

          // Form key handling (optional)
          GlobalKey<FormState>? formKey;
          if (json['properties']?['key'] != null) {
            formKey = GlobalKey<FormState>();
          }

          return Form(
            key: formKey,
            child: children.length == 1
                ? children.first
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
          );

        case 'SizedBox':
          double height = json['properties']?['height']?.toDouble() ?? 0.0;
          double width = json['properties']?['width']?.toDouble() ?? 0.0;
          return SizedBox(
            height: height,
            width: width,
          );

        case 'ElevatedButton':
          Widget child = Text('Button');
          if (json['properties']?['child'] != null) {
            child = _buildWidget(json['properties']['child']);
          }

          ButtonStyle? style;
          if (json['properties']?['style'] != null) {
            final styleData = json['properties']['style'];

            Color? backgroundColor = _parseColor(styleData['backgroundColor']);

            EdgeInsets? padding;
            if (styleData['padding'] != null) {
              final paddingData = styleData['padding'];
              double vertical = paddingData['vertical']?.toDouble() ?? 8.0;
              double horizontal = paddingData['horizontal']?.toDouble() ?? 16.0;
              padding = EdgeInsets.symmetric(
                  vertical: vertical, horizontal: horizontal);
            }

            style = ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: padding,
            );
          }

          return ElevatedButton(
            onPressed: () {},
            style: style,
            child: child,
          );

        case 'SingleChildScrollView':
          Widget? child = json['properties']?['child'] != null
              ? _buildWidget(json['properties']['child'])
              : Container();

          // Parse scroll direction
          Axis scrollDirection = Axis.vertical;
          if (json['properties']?['scrollDirection'] == 'horizontal') {
            scrollDirection = Axis.horizontal;
          }

          // Parse padding
          EdgeInsets? padding;
          if (json['properties']?['padding'] != null) {
            final paddingData = json['properties']['padding'];
            if (paddingData is Map && paddingData['all'] != null) {
              padding = EdgeInsets.all(paddingData['all'].toDouble());
            } else if (paddingData is Map) {
              padding = EdgeInsets.only(
                top: paddingData['top']?.toDouble() ?? 0.0,
                bottom: paddingData['bottom']?.toDouble() ?? 0.0,
                left: paddingData['left']?.toDouble() ?? 0.0,
                right: paddingData['right']?.toDouble() ?? 0.0,
              );
            }
          }

          return SingleChildScrollView(
            scrollDirection: scrollDirection,
            padding: padding,
            child: child,
          );
        case 'Image':
          String? imageUrl =
              json['properties']?['src'] ?? json['properties']?['url'];
          String? assetPath = json['properties']?['asset'];

          // Parse dimensions
          double? width = json['properties']?['width']?.toDouble();
          double? height = json['properties']?['height']?.toDouble();

          // Parse BoxFit
          BoxFit fit = BoxFit.cover;
          if (json['properties']?['fit'] != null) {
            switch (json['properties']['fit']) {
              case 'contain':
                fit = BoxFit.contain;
                break;
              case 'cover':
                fit = BoxFit.cover;
                break;
              case 'fill':
                fit = BoxFit.fill;
                break;
              case 'fitWidth':
                fit = BoxFit.fitWidth;
                break;
              case 'fitHeight':
                fit = BoxFit.fitHeight;
                break;
              case 'none':
                fit = BoxFit.none;
                break;
              case 'scaleDown':
                fit = BoxFit.scaleDown;
                break;
            }
          }

          // Return appropriate Image widget
          if (imageUrl != null) {
            return Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: width ?? 100,
                  height: height ?? 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            );
          } else if (assetPath != null) {
            return Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: width ?? 100,
                  height: height ?? 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            );
          } else {
            // Placeholder when no image source is provided
            return Container(
              width: width ?? 100,
              height: height ?? 100,
              color: Colors.grey[300],
              child: Icon(Icons.image, color: Colors.grey),
            );
          }
        case 'Text':
          String text =
              json['properties']?['data'] ?? json['properties']?['text'] ?? '';

          TextStyle? textStyle;
          if (json['properties']?['style'] != null) {
            final styleData = json['properties']['style'];
            Color? color = _parseColor(styleData['color']);
            double? fontSize = styleData['fontSize']?.toDouble();

            textStyle = TextStyle(
              color: color,
              fontSize: fontSize,
            );
          }

          return Text(text, style: textStyle);

        default:
          return Container(
            padding: EdgeInsets.all(8.0),
            child: Text('Unsupported widget: ${json['type']}'),
          );
      }
    } catch (e) {
      print('Error rendering UI: $e');
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Text('Error rendering UI: $e'),
      );
    }
  }

  Color? _parseColor(dynamic colorData) {
    if (colorData == null) return null;

    String colorString = colorData.toString();
    if (colorString.startsWith('#')) {
      try {
        return Color(
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      } catch (e) {
        print('Error parsing color: $colorString');
        return null;
      }
    }
    return null;
  }

  Widget _buildWidget(dynamic json) {
    if (json == null) return Container();
    if (json is Map<String, dynamic>) {
      return _buildUIFromJson(json);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Flutter Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AITypeSection(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                labelText: 'Enter UI prompt',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_promptController.text.isNotEmpty) {
                  _generateUI(_promptController.text);
                }
              },
              child: Text('Generate UI'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _showCodePreview = true),
                  child: Text('Code Preview'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _showCodePreview ? Colors.blue : Colors.grey,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _showCodePreview = false),
                  child: Text('UI Preview'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !_showCodePreview ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _error.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            _error,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : _showCodePreview
                        ? SingleChildScrollView(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              _generatedCode.isEmpty
                                  ? 'No code generated yet. Enter a prompt and click "Generate UI".'
                                  : _generatedCode,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          )
                        : _uiJson.isNotEmpty
                            ? SingleChildScrollView(
                                padding: EdgeInsets.all(16.0),
                                child: _buildUIFromJson(_uiJson),
                              )
                            : Center(
                                child: Text(
                                  'No UI generated yet. Enter a prompt and click "Generate UI".',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
