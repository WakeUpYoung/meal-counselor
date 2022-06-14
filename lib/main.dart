import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:lunch_counselor/pages/main_page.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: themeData.colorScheme.copyWith(
          primary: const Color(0xff8cc0de),
          onPrimary: Colors.white,
          secondary: const Color(0xfff4bfbf),
          background: Colors.white,
        ),
        textTheme: GoogleFonts.sourceSansProTextTheme(),
        splashColor: const Color(0xFF6b93ab),
        floatingActionButtonTheme: themeData.floatingActionButtonTheme.copyWith(
          splashColor: const Color(0xffc19797)
        ),
        snackBarTheme: themeData.snackBarTheme.copyWith(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      home: const MainPage(),
    );
  }
}

