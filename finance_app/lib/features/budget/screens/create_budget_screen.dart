import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../budget/models/budget_model.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({Key? key}) : super(key: key);

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _title = TextEditingController();
  String _interval = 'monthly';
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final b = BudgetModel(id: const Uuid().v4(), userId: 'me', categoryId: _title.text.trim(), amount: double.tryParse(_amount.text) ?? 0, interval: _interval);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _saving = false);
    Navigator.of(context).pop(b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Category'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 8),
            TextFormField(controller: _amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount'), validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null),
            const SizedBox(height: 8),
            DropdownButtonFormField(value: _interval, items: const [DropdownMenuItem(value: 'monthly', child: Text('Monthly')), DropdownMenuItem(value: 'weekly', child: Text('Weekly'))], onChanged: (v) => setState(() => _interval = v as String)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _saving ? null : _save, child: _saving ? const CircularProgressIndicator() : const Text('Save'))
          ]),
        ),
      ),
    );
  }
}
