import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors:-
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), // standard dark theme
      themeMode: ThemeMode.system,
      //   textTheme: GoogleFonts.latoTextTheme(
      //     Theme.of(context).textTheme,
      //   ),
      // ),
      debugShowCheckedModeBanner: false,
      title: "New Note App",
      home: const HomePage(),
    );
  }
}
