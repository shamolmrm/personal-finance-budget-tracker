import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                CustomTextField(label: 'Email', controller: _email, validator: Validators.email),
                const SizedBox(height: 12),
                CustomTextField(label: 'Password', controller: _password, obscureText: true, validator: Validators.password),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot password?'))),
                const SizedBox(height: 12),
                CustomButton(label: 'Login', loading: _loading, onPressed: _login),
                const SizedBox(height: 12),
                OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.login), label: const Text('Sign in with Google')),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Don\'t have an account?'), TextButton(onPressed: () {}, child: const Text('Register'))])
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final client = SupabaseService.instance.client;
      if (client == null) {
        // fallback: simulate slow login for dev
        await Future.delayed(const Duration(seconds: 1));
        return;
      }

      final res = await client.auth.signInWithPassword(email: _email.text.trim(), password: _password.text);
      if (res.user == null && res.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to sign in. Please check your credentials.')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
