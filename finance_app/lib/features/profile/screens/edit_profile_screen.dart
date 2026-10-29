import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _currency;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileNotifierProvider);
    _nameController = TextEditingController(text: profile.fullName);
    _emailController = TextEditingController(text: profile.email);
    _currency = profile.currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full name'), validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _currency,
                decoration: const InputDecoration(labelText: 'Currency'),
                items: ['USD', 'EUR', 'GBP', 'INR', 'BDT'].map((currency) => DropdownMenuItem(value: currency, child: Text(currency))).toList(),
                onChanged: (value) => setState(() => _currency = value ?? _currency),
              ),
              const Spacer(),
              ElevatedButton(onPressed: _save, child: const SizedBox(width: double.infinity, child: Center(child: Text('Save changes')))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(profileNotifierProvider.notifier).updateProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      currency: _currency,
    );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }
}
