import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../ai/services/claude_ai_service.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/custom_numpad.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  String _amount = '';
  bool _isExpense = true;
  String _category = 'Others';
  final _note = TextEditingController();
  bool _saving = false;

  void _onKey(String k) {
    setState(() {
      if (k == '.' && _amount.contains('.')) return;
      _amount = (_amount + k).replaceAll(RegExp(r'^0+(?=\d)'), '');
    });
  }

  void _onDelete() {
    setState(() {
      if (_amount.isNotEmpty) _amount = _amount.substring(0, _amount.length - 1);
    });
  }

  Future<void> _suggestCategory(String text) async {
    if (text.trim().isEmpty) return;
    final suggestion = await ClaudeAIService.instance.suggestCategory(text);
    setState(() => _category = suggestion);
  }

  Future<void> _save() async {
    if (_amount.isEmpty) return;
    setState(() => _saving = true);
    final svc = ref.read(transactionNotifierProvider);
    final t = TransactionModel(
      id: const Uuid().v4(),
      userId: 'me',
      accountId: null,
      categoryId: null,
      amount: double.tryParse(_amount) ?? 0,
      currency: 'USD',
      type: _isExpense ? 'expense' : 'income',
      note: _note.text,
      merchant: null,
      occurredAt: DateTime.now(),
    );

    await svc.addTransaction(t);
    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(children: [
              ChoiceChip(label: const Text('Expense'), selected: _isExpense, onSelected: (v) => setState(() => _isExpense = true)),
              const SizedBox(width: 8),
              ChoiceChip(label: const Text('Income'), selected: !_isExpense, onSelected: (v) => setState(() => _isExpense = false)),
            ]),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft, child: Text('Amount', style: Theme.of(context).textTheme.bodyMedium)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: Text(_amount.isEmpty ? '0.00' : _amount, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(controller: _note, decoration: const InputDecoration(labelText: 'Note / merchant'), onChanged: (v) => _suggestCategory(v)),
              ),
              IconButton(onPressed: () {/* open receipt scanner */}, icon: const Icon(Icons.camera_alt)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Category: '),
              Chip(label: Text(_category)),
              const SizedBox(width: 8),
              TextButton(onPressed: () {/* open category picker */}, child: const Text('Change'))
            ])
          ]),
        ),
        const Divider(height: 1),
        Expanded(child: CustomNumpad(onKey: _onKey, onDelete: _onDelete, onDone: () => _save())),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(onPressed: _saving ? null : _save, child: _saving ? const CircularProgressIndicator() : const Text('Save')),
        )
      ]),
    );
  }
}
