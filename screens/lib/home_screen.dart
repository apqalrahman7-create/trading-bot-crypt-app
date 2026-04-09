import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
 final String token;
 const HomeScreen({super.key, required this.token});

 @override
 State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 final _api = ApiService();

 bool _running = false;
 double _balance = 0;
 String _statusText = "جاري التحميل...";
 String _lastError = "";
 bool _loading = false;

 @override
 void initState() {
 super.initState();
 _refresh();
 }

 Future<void> _refresh() async {
 setState(() {
 _loading = true;
 _lastError = "";
 });

 try {
 final status = await _api.getStatus(widget.token);
 final balance = await _api.getBalance(widget.token);

 final running = status["running"] == true;
 final quoteTotal = balance["quote_total"] ?? 0;

 setState(() {
 _running = running;
 _balance = (quoteTotal is num) ? quoteTotal.toDouble() : 0;
 _statusText = running ? "البوت يعمل" : "البوت متوقف";
 _lastError = (status["last_error"] ?? "").toString();
 });
 } catch (e) {
 setState(() {
 _statusText = "فشل الاتصال";
 _lastError = e.toString();
 });
 } finally {
 setState(() => _loading = false);
 }
 }

 Future<void> _start() async {
 await _api.startBot(widget.token);
 await _refresh();
 }

 Future<void> _stop() async {
 await _api.stopBot(widget.token);
 await _refresh();
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 title: const Text("لوحة التحكم"),
 actions: [
 IconButton(
 onPressed: _loading ? null : _refresh,
 icon: const Icon(Icons.refresh),
 )
 ],
 ),
 body: Padding(
 padding: const EdgeInsets.all(16),
 child: ListView(
 children: [
 Card(
 child: ListTile(
 leading: Icon(
 _running ? Icons.play_circle : Icons.stop_circle,
 color: _running ? Colors.greenAccent : Colors.redAccent,
 ),
 title: Text(_statusText),
 ),
 ),
 const SizedBox(height: 12),
 Card(
 child: ListTile(
 title: const Text("الرصيد الحقيقي (Quote)"),
 subtitle: Text("\$${_balance.toStringAsFixed(2)}"),
 ),
 ),
 const SizedBox(height: 12),
 Row(
 children: [
 Expanded(
 child: ElevatedButton(
 onPressed: _running || _loading ? null : _start,
 child: const Text("تشغيل البوت"),
 ),
 ),
 const SizedBox(width: 12),
 Expanded(
 child: ElevatedButton(
 onPressed: !_running || _loading ? null : _stop,
 style: ElevatedButton.styleFrom(
 backgroundColor: Colors.redAccent,
 ),
 child: const Text("إيقاف البوت"),
 ),
 ),
 ],
 ),
 const SizedBox(height: 16),
 if (_lastError.isNotEmpty)
 Text(
 _lastError,
 style: const TextStyle(color: Colors.redAccent),
 ),
 ],
 ),
 ),
 );
 }
}
