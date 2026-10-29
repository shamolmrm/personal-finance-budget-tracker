import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/supabase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            CustomTextField(label: 'Full name', controller: _name),
            const SizedBox(height: 8),
            CustomTextField(label: 'Email', controller: _email, validator: Validators.email),
            const SizedBox(height: 8),
            CustomTextField(label: 'Password', controller: _password, obscureText: true, validator: Validators.password),
            const SizedBox(height: 8),
            CustomTextField(label: 'Confirm password', controller: _confirm, obscureText: true, validator: (v) => v == _password.text ? null : 'Passwords do not match'),
            const SizedBox(height: 12),
            CustomButton(label: 'Register', loading: _loading, onPressed: _register),
          ]),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final client = SupabaseService.instance.client;
      if (client == null) {
        await Future.delayed(const Duration(seconds: 1));
        return;
      }

      final res = await client.auth.signUp(email: _email.text.trim(), password: _password.text, data: {'full_name': _name.text.trim()});
      if (res.user == null && res.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to register. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
