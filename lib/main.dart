import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalcioLiveApp());
}

class CalcioLiveApp extends StatelessWidget {
  const CalcioLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF31D17C);
    return MaterialApp(
      title: 'Calcio Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          brightness: Brightness.dark,
          surface: const Color(0xFF111C2E),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1220),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF142238),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF24344C)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
