import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  void _login() async {
    setState(() => loading = true);
    final res = await ApiService.login(email.text.trim(), password.text);
    setState(() => loading = false);
    if (res.containsKey('token')) {
      await ApiService.saveToken(res['token']);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final msg = res['msg'] ?? res['error'] ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuickNotes — Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : _login,
              child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Login'),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Create an account'))
        ]),
      ),
    );
  }
}
