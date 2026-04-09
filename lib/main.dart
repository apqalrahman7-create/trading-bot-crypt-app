import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
 runApp(const TradingBotApp());
}

class TradingBotApp extends StatelessWidget {
 const TradingBotApp({super.key});

 @override
 Widget build(BuildContext context) {
 return MaterialApp(
 debugShowCheckedModeBanner: false,
 title: 'Trading Bot',
 theme: ThemeData.dark(useMaterial3: true),
 home: const LoginScreen(),
 routes: {
 '/home': (_) => const HomeScreen(token: ''),
 },
 );
 }
}
