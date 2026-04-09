import 'package:flutter/material.dart';
import 'customer_service.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
 return MaterialApp(
 debugShowCheckedModeBanner: false,
 home: const CustomerHomePage(),
 );
 }
}

class CustomerHomePage extends StatefulWidget {
 const CustomerHomePage({super.key});

 @override
 State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
 // غيّر هذا إلى عنوان السيرفر عندك
 final customerService = CustomerService('http://YOUR_SERVER_IP:5000');

 final phoneController = TextEditingController();
 final nameController = TextEditingController();
 final codeController = TextEditingController();
 final messageController = TextEditingController();

 String statusText = 'جاهز';

 Future<void> register() async {
 final phone = phoneController.text.trim();
 final name = nameController.text.trim();

 final res = await customerService.registerUser(phone: phone, name: name);
 setState(() {
 statusText = res['ok'] == true ? 'تم تسجيل المستخدم' : 'فشل التسجيل';
 });
 }

 Future<void> checkStatus() async {
 final phone = phoneController.text.trim();
 final res = await customerService.getUserStatus(phone);
 setState(() {
 statusText = res['is_active'] == true ? 'المستخدم نشط ✅' : 'المستخدم غير نشط ❌';
 });
 }

 Future<void> activate() async {
 final phone = phoneController.text.trim();
 final code = codeController.text.trim();

 final res = await customerService.activateCode(phone: phone, code: code);
 setState(() {
 statusText = res['ok'] == true ? 'تم التفعيل ✅' : 'فشل التفعيل';
 });
 }

 Future<void> sendMessage() async {
 final phone = phoneController.text.trim();
 final msg = messageController.text.trim();

 final res = await customerService.sendMessage(phone: phone, message: msg);
 setState(() {
 statusText = res['ok'] == true ? 'تم إرسال الرسالة ✅' : 'فشل الإرسال';
 });
 messageController.clear();
 }

 @override
 void dispose() {
 phoneController.dispose();
 nameController.dispose();
 codeController.dispose();
 messageController.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(title: const Text('خدمات العملاء')),
 body: ListView(
 padding: const EdgeInsets.all(16),
 children: [
 TextField(
 controller: phoneController,
 decoration: const InputDecoration(labelText: 'رقم الهاتف'),
 ),
 const SizedBox(height: 10),
 TextField(
 controller: nameController,
 decoration: const InputDecoration(labelText: 'الاسم (اختياري)'),
 ),
 const SizedBox(height: 10),
 ElevatedButton(
 onPressed: register,
 child: const Text('تسجيل'),
 ),
 const SizedBox(height: 20),
 ElevatedButton(
 onPressed: checkStatus,
 child: const Text('عرض حالة المستخدم'),
 ),
 const SizedBox(height: 20),
 TextField(
 controller: codeController,
 decoration: const InputDecoration(labelText: 'رمز التفعيل'),
 ),
 const SizedBox(height: 10),
 ElevatedButton(
 onPressed: activate,
 child: const Text('تفعيل'),
 ),
 const SizedBox(height: 20),
 TextField(
 controller: messageController,
 decoration: const InputDecoration(labelText: 'اكتب رسالتك'),
 ),
 const SizedBox(height: 10),
 ElevatedButton(
 onPressed: sendMessage,
 child: const Text('إرسال رسالة للمشرف'),
 ),
 const SizedBox(height: 20),
 Text(
 statusText,
 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
 ),
 ],
 ),
 );
 }
}
