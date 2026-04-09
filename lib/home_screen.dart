import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
 const LoginScreen({super.key});

 @override
 State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final _api = ApiService();
 final _userCtrl = TextEditingController();
 final _passCtrl = TextEditingController();

 bool _loading = false;
 String _error = "";

 Future<void> _doLogin() async {
 setState(() {
 _loading = true;
 _error = "";
 });

 try {
 final token = await _api.login(
 username: _userCtrl.text.trim(),
 password: _passCtrl.text,
 );

 if (!mounted) return;

 if (token == null || token.isEmpty) {
 setState(() {
 _loading = false;
 _error = "فشل تسجيل الدخول (تحقق من البيانات).";
 });
 return;
 }

 Navigator.pushReplacement(
 context,
 MaterialPageRoute(
 builder: (_) => HomeScreen(token: token),
 ),
 );
 } catch (e) {
 if (!mounted) return;
 setState(() {
 _loading = false;
 _error = "خطأ: ${e.toString()}";
 });
 }
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(title: const Text("تسجيل الدخول")),
 body: Padding(
 padding: const EdgeInsets.all(16),
 child: Column(
 children: [
 TextField(
 controller: _userCtrl,
 decoration: const InputDecoration(labelText: "اسم المستخدم"),
 ),
 const SizedBox(height: 12),
 TextField(
 controller: _passCtrl,
 decoration: const InputDecoration(labelText: "كلمة المرور"),
 obscureText: true,
 ),
 const SizedBox(height: 16),
 if (_error.isNotEmpty)
 Text(_error, style: const TextStyle(color: Colors.redAccent)),
 const SizedBox(height: 12),
 SizedBox(
 width: double.infinity,
 child: ElevatedButton(
 onPressed: _loading ? null : _doLogin,
 child: _loading
 ? const SizedBox(
 height: 18,
 width: 18,
 child: CircularProgressIndicator(strokeWidth: 2),
 )
 : const Text("دخول"),
 ),
 ),
 ],
 ),
 ),
 );
 }
}
