import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izstock/features/auth/views/auth_page.dart';
import 'package:izstock/core/main_navigation.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return const MainNavigationScreen();
          }

          return const AuthPage();
        },
      ),
    );
  }
}
