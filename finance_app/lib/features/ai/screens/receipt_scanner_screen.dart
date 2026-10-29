import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/claude_ai_service.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  CameraController? _controller;
  bool _isProcessing = false;
  String _receiptText = '';
  String _merchant = '';
  String _amount = '';
  String _category = '';
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _captureReceipt() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() => _isProcessing = true);
    final picture = await _controller!.takePicture();
    final inputImage = InputImage.fromFilePath(picture.path);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final result = await recognizer.processImage(inputImage);
    recognizer.close();

    final extractedText = result.text;
    final requested = await ClaudeAIService.instance.suggestReceiptFields(
      extractedText,
    );
    String merchant = '';
    String amount = '';
    for (final line in requested.split('\n')) {
      if (line.toLowerCase().startsWith('merchant:'))
        merchant = line.split(':').sublist(1).join(':').trim();
      if (line.toLowerCase().startsWith('amount:'))
        amount = line.split(':').sublist(1).join(':').trim();
    }
    final category = await ClaudeAIService.instance.suggestCategory(
      extractedText,
    );

    setState(() {
      _receiptText = extractedText;
      _merchant = merchant;
      _amount = amount;
      _category = category;
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Scanner')),
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Text(
                        'Point your camera at the receipt and tap Capture',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _captureReceipt,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capture'),
                      ),
                      const SizedBox(height: 12),
                      if (_isProcessing) const CircularProgressIndicator(),
                      if (_merchant.isNotEmpty ||
                          _amount.isNotEmpty ||
                          _category.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Merchant: $_merchant'),
                            Text('Amount: $_amount'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Category: '),
                            Text(
                              _category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Receipt text preview:',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _receiptText,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
