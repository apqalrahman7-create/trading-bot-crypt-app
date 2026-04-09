import 'package:flutter/material.dart';
import 'customer_service.dart';

class MessagesPage extends StatefulWidget {
 final CustomerService customerService;
 final String phone;

 const MessagesPage({
 super.key,
 required this.customerService,
 required this.phone,
 });

 @override
 State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
 final messageController = TextEditingController();
 bool loading = false;

 List<dynamic> messages = [];

 @override
 void initState() {
 super.initState();
 loadMessages();
 }

 Future<void> loadMessages() async {
 setState(() => loading = true);
 try {
 final res = await widget.customerService.getMessages(widget.phone);
 setState(() {
 messages = res;
 loading = false;
 });
 } catch (_) {
 setState(() => loading = false);
 }
 }

 Future<void> sendToAdmin() async {
 final msg = messageController.text.trim();
 if (msg.isEmpty) return;

 await widget.customerService.sendMessage(
 phone: widget.phone,
 message: msg,
 );

 messageController.clear();
 await loadMessages();
 }

 @override
 void dispose() {
 messageController.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 title: Text('المحادثة - ${widget.phone}'),
 actions: [
 IconButton(
 onPressed: loadMessages,
 icon: const Icon(Icons.refresh),
 ),
 ],
 ),
 body: Column(
 children: [
 Expanded(
 child: loading
 ? const Center(child: CircularProgressIndicator())
 : ListView.builder(
 padding: const EdgeInsets.all(16),
 itemCount: messages.length,
 itemBuilder: (context, i) {
 final m = messages[i];
 final sender = (m['sender'] ?? '').toString();
 final text = (m['message'] ?? '').toString();

 final isAdmin = sender == 'admin';

 return Align(
 alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
 child: Container(
 margin: const EdgeInsets.symmetric(vertical: 6),
 padding: const EdgeInsets.all(12),
 constraints: const BoxConstraints(maxWidth: 320),
 decoration: BoxDecoration(
 color: isAdmin ? Colors.grey.shade200 : Colors.blue.shade100,
 borderRadius: BorderRadius.circular(12),
 ),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 isAdmin ? 'المشرف' : 'أنت',
 style: const TextStyle(
 fontWeight: FontWeight.bold,
 fontSize: 12,
 ),
 ),
 const SizedBox(height: 6),
 Text(text),
 ],
 ),
 ),
 );
 },
 ),
 ),
 SafeArea(
 child: Padding(
 padding: const EdgeInsets.all(12),
 child: Row(
 children: [
 Expanded(
 child: TextField(
 controller: messageController,
 decoration: const InputDecoration(
 hintText: 'اكتب رسالتك...',
 border: OutlineInputBorder(),
 ),
 ),
 ),
 const SizedBox(width: 8),
 ElevatedButton(
 onPressed: sendToAdmin,
 child: const Text('إرسال'),
 ),
 ],
 ),
 ),
 ),
 ],
 ),
 );
 }
}
