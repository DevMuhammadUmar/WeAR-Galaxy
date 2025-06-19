import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:weargalaxy/providers/theme_provider.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:exif/exif.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  
  //static const String apiKey = Api key here ;
  
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  
  final List<String> _classLabels = [
    'Diamond', 'Heart', 'Oblong', 'Oval', 'Round', 'Square', 'Triangle'
  ];
  Interpreter? _interpreter;
  File? _selectedImage;
  bool _isProcessing = false;
  List<ModelMessage> _messages = [];
  late FaceDetector _faceDetector;

  @override
  void initState() {
    super.initState();
    _loadModel();
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      minFaceSize: 0.15,
      enableContours: true,
    );
    _faceDetector = GoogleMlKit.vision.faceDetector(options);
    Future.delayed(const Duration(seconds: 2), _showInitialGreeting);
  }

  void _showInitialGreeting() {
    setState(() {
      _messages.add(ModelMessage(
        isPrompt: false,
        message: "Hello! You can either describe your facial features or upload a photo for glasses recommendations.",
        time: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load model: $e')),
      );
    }
  }

  Future<int> _getImageRotation(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final data = await readExifFromBytes(bytes);
      final orientation = data['Image Orientation']?.printable;
      
      switch (orientation) {
        case 'Rotate 90 CW': return 90;
        case 'Rotate 180': return 180;
        case 'Rotate 270 CW': return 270;
        default: return 0;
      }
    } catch (e) {
      print('Error reading EXIF data: $e');
      return 0;
    }
  }

  InputImageRotation _getInputImageRotation(int rotation) {
    switch (rotation) {
      case 90: return InputImageRotation.rotation90deg;
      case 180: return InputImageRotation.rotation180deg;
      case 270: return InputImageRotation.rotation270deg;
      default: return InputImageRotation.rotation0deg;
    }
  }

 Future<void> _captureImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  if (image == null) return;

  setState(() {
    _isProcessing = true;
    _selectedImage = File(image.path);
  });

  try {
    // Detect face first
    final rotation = await _getImageRotation(image.path);
    final inputImage = InputImage.fromFile(File(image.path));

    // Adjust the rotation for the image based on EXIF data
    final rotatedInputImage = InputImage.fromFile(File(image.path));

    final faces = await _faceDetector.processImage(rotatedInputImage);
    if (faces.isEmpty) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No face detected! Please take a clear photo of your face.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Continue processing if face is detected
    final faceShape = await _predictFaceShape(File(image.path));
    final prompt = "Recommend a glasses frame for $faceShape face shape. Explain why it's suitable in one paragraph without any headings or bold text.";
    final response = await _getAIResponse(prompt);

    setState(() {
      _messages.add(ModelMessage(
        isPrompt: false,
        message: response,
        time: DateTime.now(),
      ));
      _messages.add(ModelMessage(
        isPrompt: false,
        message: "Are you satisfied with this recommendation? (Yes/No)",
        time: DateTime.now(),
      ));
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error processing image: $e')),
    );
  } finally {
    setState(() => _isProcessing = false);
  }
  _scrollToBottom();
}


  Future<String> _predictFaceShape(File image) async {
    try {
      final interpreter = await Interpreter.fromAsset('assets/model.tflite');
      final imageBytes = await image.readAsBytes();
      final imageInput = img.decodeImage(imageBytes);
      final resizedImage = img.copyResize(imageInput!, width: 200, height: 200);

      final input = List.generate(200, (y) => List.generate(200, (x) {
        final pixel = resizedImage.getPixel(x, y);
        return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
      }));

      final output = [List<double>.filled(_classLabels.length, 0.0)];
      interpreter.run([input], output);

      final predictedIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
      return _classLabels[predictedIndex];
    } catch (e) {
      return 'Error: $e';
    }
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (_messages.isNotEmpty && _messages.last.message == "Are you satisfied with this recommendation? (Yes/No)") {
      if (message.toLowerCase().contains('yes')) {
        setState(() {
          _messages.add(ModelMessage(
            isPrompt: false,
            message: "Great! Feel free to ask for more recommendations anytime.",
            time: DateTime.now(),
          ));
        });
      } else {
        _resetChat();
      }
      _messageController.clear();
      _scrollToBottom();
      return;
    }

    setState(() {
      _messages.add(ModelMessage(
        isPrompt: true, 
        message: message, 
        time: DateTime.now()
      ));
      _messageController.clear();
    });

    try {
      final containsFaceShape = _classLabels.any((shape) => 
          message.toLowerCase().contains(shape.toLowerCase()));
      
      final prompt = containsFaceShape
          ? "Recommend glasses frames for someone with: $message. Consider face shape and skin tone. Explain suitability in one paragraph without headings."
          : message;

      final response = await _getAIResponse(prompt);
      setState(() {
        _messages.add(ModelMessage(
          isPrompt: false, 
          message: response, 
          time: DateTime.now()
        ));
        _messages.add(ModelMessage(
          isPrompt: false,
          message: "Are you satisfied with this recommendation? (Yes/No)",
          time: DateTime.now(),
        ));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    _scrollToBottom();
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _selectedImage = null;
      _messages.add(ModelMessage(
        isPrompt: false,
        message: "Let's try again! Describe your features or take a new photo.",
        time: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  Future<String> _getAIResponse(String prompt) async {
    final response = await http.post(
      Uri.parse('$baseUrl?key= // api key     '),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'contents': [{'parts': [{'text': prompt}]}]}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response';
    }
    throw Exception('API Error: ${response.statusCode}');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final iconColor = themeProvider.getIsDarkTheme ? Colors.white70 : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/bag/wgb.png', height: 100),
        centerTitle: true,
        backgroundColor: themeProvider.getIsDarkTheme ? Colors.grey[900] : Colors.white,
      ),
      body: Column(
        children: [
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(_selectedImage!, height: 150, fit: BoxFit.cover),
                  if (_isProcessing) const CircularProgressIndicator(),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isPrompt ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isPrompt 
                          ? Colors.blueGrey[800] 
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        color: message.isPrompt ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(IconlyLight.camera, color: iconColor),
                  onPressed: _captureImage,
                  tooltip: 'Take Photo',
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type message or take photo...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(IconlyLight.send, color: iconColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModelMessage {
  final bool isPrompt;
  final String message;
  final DateTime time;

  ModelMessage({
    required this.isPrompt,
    required this.message,
    required this.time,
  });
}