import 'package:flutter/material.dart';
import 'package:izstock/pages/main_navigation.dart';
import 'package:izstock/styles/theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: const MainNavigationScreen());
  }
}
