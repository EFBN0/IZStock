import 'package:flutter/material.dart';
import 'package:izstock/widgets/auth/auth_options.dart';
import 'package:izstock/widgets/auth/login_user.dart';
import 'package:izstock/widgets/auth/register_user.dart';

enum AuthScreenModeEnum { initial, login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _pageMode = AuthScreenModeEnum.initial;

  void _setPageMode(AuthScreenModeEnum pageMode) {
    setState(() {
      _pageMode = pageMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget authNavigationOption;
    Widget mainContent;

    if (_pageMode == AuthScreenModeEnum.login) {
      authNavigationOption = TextButton(onPressed: () {
        _setPageMode(AuthScreenModeEnum.register);
      }, child: Text('Ainda não possui uma conta? Cadastre-se!'));

      mainContent = Login();
    } else if (_pageMode == AuthScreenModeEnum.register) {
      authNavigationOption = TextButton(onPressed: () {
        _setPageMode(AuthScreenModeEnum.login);
      }, child: Text('Já possuo uma conta!'));

      mainContent = Register();
    } else {
      authNavigationOption = const SizedBox.shrink();
      mainContent = AuthOptions(onPageModeChange: _setPageMode);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warehouse,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 40,
                ),
                Text(
                  'IZStock App',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 40),
                SingleChildScrollView(child: mainContent),
                if (_pageMode != AuthScreenModeEnum.initial)
                  const SizedBox(height: 10,),
                authNavigationOption
              ],
            ),
          ),
        ),
      ),
    );
  }
}