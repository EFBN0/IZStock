import 'package:flutter/material.dart';
import 'package:izstock/features/auth/views/widgets/auth_page_options_wrapper.dart';
import 'package:izstock/features/auth/views/widgets/login_user.dart';
import 'package:izstock/features/auth/views/widgets/register_user.dart';

enum AuthPageModeEnum { initial, login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  var _pageMode = AuthPageModeEnum.initial;

  void _setPageMode(AuthPageModeEnum pageMode) {
    setState(() {
      _pageMode = pageMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget authNavigationOption;
    Widget mainContent;

    if (_pageMode == AuthPageModeEnum.login) {
      authNavigationOption = TextButton(onPressed: () {
        _setPageMode(AuthPageModeEnum.register);
      }, child: Text('Ainda não possui uma conta? Cadastre-se!'));

      mainContent = Login();
    } else if (_pageMode == AuthPageModeEnum.register) {
      authNavigationOption = TextButton(onPressed: () {
        _setPageMode(AuthPageModeEnum.login);
      }, child: Text('Já possuo uma conta!'));

      mainContent = Register();
    } else {
      authNavigationOption = const SizedBox.shrink();
      mainContent = AuthPageOptionsWrapper(onPageModeChange: _setPageMode);
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
                if (_pageMode != AuthPageModeEnum.initial)
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