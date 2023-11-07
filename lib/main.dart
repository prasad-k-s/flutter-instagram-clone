import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/responsive_layout/mobile_screen_layout.dart';
import 'package:flutter_instagram_clone/responsive_layout/responsive.dart';
import 'package:flutter_instagram_clone/responsive_layout/web_screen_layout.dart';
import 'package:flutter_instagram_clone/utlis/colors.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),
    );
  }
}
