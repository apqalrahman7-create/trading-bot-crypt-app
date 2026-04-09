import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerService {
 final String baseUrl;

 CustomerService(this.baseUrl);

 Map<String, String> get _jsonHeaders => {
 'Content-Type': 'application/json',
 };

 Future<Map<String, dynamic>> registerUser({
 required String phone,
 String name = '',
 }) async {
 final res = await http.post(
 Uri.parse('$baseUrl/user/register'),
 headers: _jsonHeaders,
 body: jsonEncode({
 'phone': phone,
 'name': name,
 }),
 );

 return jsonDecode(res.body);
 }

 Future<Map<String, dynamic>> getUserStatus(String phone) async {
 final res = await http.get(
 Uri.parse('$baseUrl/user/status?phone=$phone'),
 headers: const {},
 );

 return jsonDecode(res.body);
 }

 Future<Map<String, dynamic>> activateCode({
 required String phone,
 required String code,
 }) async {
 final res = await http.post(
 Uri.parse('$baseUrl/user/activate-code'),
 headers: _jsonHeaders,
 body: jsonEncode({
 'phone': phone,
 'code': code,
 }),
 );

 return jsonDecode(res.body);
 }

 Future<Map<String, dynamic>> sendMessage({
 required String phone,
 required String message,
 }) async {
 final res = await http.post(
 Uri.parse('$baseUrl/user/message'),
 headers: _jsonHeaders,
 body: jsonEncode({
 'phone': phone,
 'message': message,
 }),
 );

 return jsonDecode(res.body);
 }

 Future<List<dynamic>> getMessages(String phone) async {
 final res = await http.get(
 Uri.parse('$baseUrl/user/messages?phone=$phone'),
 );

 return jsonDecode(res.body);
 }
}
