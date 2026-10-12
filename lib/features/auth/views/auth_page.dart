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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget? authNavigationOption;
    Widget mainContent;
    String subtitulo;

    if (_pageMode == AuthPageModeEnum.login) {
      subtitulo = 'Entre para continuar';
      mainContent = const Login();
      authNavigationOption = _buildAlternarModo(
        'Ainda não tem conta?',
        'Criar conta',
        AuthPageModeEnum.register,
      );
    } else if (_pageMode == AuthPageModeEnum.register) {
      subtitulo = 'Crie sua conta gratuita';
      mainContent = const Register();
      authNavigationOption = _buildAlternarModo(
        'Já tem uma conta?',
        'Entrar',
        AuthPageModeEnum.login,
      );
    } else {
      subtitulo = 'Controle de estoque e vendas';
      mainContent = AuthPageOptionsWrapper(onPageModeChange: _setPageMode);
    }

    return PopScope(
      canPop: _pageMode == AuthPageModeEnum.initial,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _setPageMode(AuthPageModeEnum.initial);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          color: colorScheme.onPrimary,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'IZStock',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitulo,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 36),
                    mainContent,
                    if (authNavigationOption != null) ...[
                      const SizedBox(height: 16),
                      authNavigationOption,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlternarModo(
    String pergunta,
    String acao,
    AuthPageModeEnum destino,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          pergunta,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: () => _setPageMode(destino),
          child: Text(acao),
        ),
      ],
    );
  }
}
