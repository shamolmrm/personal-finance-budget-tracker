import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeAIService {
  ClaudeAIService._();
  static final instance = ClaudeAIService._();

  /// Suggests a category based on the `text`. Returns a category string.
  /// This will call the Claude API if `CLAUDE_API_KEY` is provided via
  /// environment. Otherwise returns a sensible default.
  Future<String> suggestCategory(String text) async {
    final key = const String.fromEnvironment(
      'CLAUDE_API_KEY',
      defaultValue: '',
    );
    if (key.isEmpty) {
      final t = text.toLowerCase();
      if (t.contains('uber') || t.contains('taxi') || t.contains('bus'))
        return 'Transport';
      if (t.contains('coffee') || t.contains('cafe') || t.contains('starbucks'))
        return 'Food';
      if (t.contains('grocery') || t.contains('supermarket'))
        return 'Groceries';
      return 'Others';
    }

    final uri = Uri.parse('https://api.anthropic.com/v1/complete');
    final prompt =
        'Suggest a single expense category for this merchant/note:\n"""$text""". Reply with a single word.';
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'x-api-key': key},
      body: jsonEncode({
        'model': 'claude-1.3',
        'prompt': prompt,
        'max_tokens_to_sample': 16,
      }),
    );

    if (resp.statusCode == 200) {
      try {
        final j = jsonDecode(resp.body);
        final String? out =
            j['completion'] ?? j['text'] ?? j['choices']?[0]?['text'];
        if (out != null) return out.trim().split('\n').first;
      } catch (_) {}
    }
    return 'Others';
  }

  Future<String> generateResponse(String message) async {
    final key = const String.fromEnvironment(
      'CLAUDE_API_KEY',
      defaultValue: '',
    );
    if (key.isEmpty) {
      return 'I recommend reviewing your latest expenses and keeping at least 20% of your income for savings.';
    }

    final uri = Uri.parse('https://api.anthropic.com/v1/complete');
    final prompt =
        'You are a finance assistant. Respond concisely to the user request:\n"""$message"""';
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'x-api-key': key},
      body: jsonEncode({
        'model': 'claude-1.3',
        'prompt': prompt,
        'max_tokens_to_sample': 150,
      }),
    );

    if (resp.statusCode == 200) {
      try {
        final j = jsonDecode(resp.body);
        final String? out =
            j['completion'] ?? j['text'] ?? j['choices']?[0]?['text'];
        if (out != null) return out.trim();
      } catch (_) {}
    }

    return 'Sorry, I could not generate a response right now. Please try again later.';
  }

  Future<String> suggestReceiptFields(String receiptText) async {
    final key = const String.fromEnvironment(
      'CLAUDE_API_KEY',
      defaultValue: '',
    );
    if (key.isEmpty) {
      return receiptText;
    }
    final uri = Uri.parse('https://api.anthropic.com/v1/complete');
    final prompt =
        'Extract the merchant name and total amount from this receipt text:\n"""$receiptText""". Return as Merchant: <name>\nAmount: <value>.';
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'x-api-key': key},
      body: jsonEncode({
        'model': 'claude-1.3',
        'prompt': prompt,
        'max_tokens_to_sample': 80,
      }),
    );

    if (resp.statusCode == 200) {
      try {
        final j = jsonDecode(resp.body);
        final String? out =
            j['completion'] ?? j['text'] ?? j['choices']?[0]?['text'];
        if (out != null) return out.trim();
      } catch (_) {}
    }

    return receiptText;
  }
}
