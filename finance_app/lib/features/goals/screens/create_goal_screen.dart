import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/goal_model.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({Key? key}) : super(key: key);

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _deadlineController = TextEditingController();
  String _icon = '🎯';
  String _color = '#4F46E5';
  bool _saving = false;
  DateTime? _deadline;

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 30)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) {
      setState(() {
        _deadline = picked;
        _deadlineController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final goal = GoalModel(
      id: const Uuid().v4(),
      userId: 'me',
      title: _titleController.text.trim(),
      targetAmount: double.tryParse(_targetController.text) ?? 0,
      savedAmount: 0,
      deadline: _deadline,
      icon: _icon,
      color: _color,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _saving = false);
    Navigator.of(context).pop(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Goal title'), validator: (value) => value == null || value.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _targetController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Target amount'), validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid amount' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _deadlineController, readOnly: true, decoration: const InputDecoration(labelText: 'Deadline'), onTap: _selectDeadline),
            const SizedBox(height: 12),
            const Text('Icon'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: ['🎯', '🏦', '💻', '✈️', '📚', '🚗'].map((emoji) => ChoiceChip(label: Text(emoji), selected: _icon == emoji, onSelected: (_) => setState(() => _icon = emoji))).toList()),
            const SizedBox(height: 12),
            const Text('Color'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: ['#4F46E5', '#10B981', '#F59E0B', '#F43F5E', '#0EA5E9'].map((color) {
              return ChoiceChip(
                label: const SizedBox(width: 24, height: 24),
                selected: _color == color,
                selectedColor: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
                backgroundColor: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
                onSelected: (_) => setState(() => _color = color),
              );
            }).toList()),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _saving ? null : _save, child: _saving ? const CircularProgressIndicator() : const Text('Create Goal'))
          ]),
        ),
      ),
    );
  }
}
