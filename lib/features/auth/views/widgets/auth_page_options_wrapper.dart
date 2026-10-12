import 'package:flutter/material.dart';
import 'package:izstock/features/auth/views/auth_page.dart';

class AuthPageOptionsWrapper extends StatelessWidget {
  const AuthPageOptionsWrapper({super.key, required this.onPageModeChange});

  final void Function(AuthPageModeEnum) onPageModeChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: () => onPageModeChange(AuthPageModeEnum.login),
          child: const Text('Entrar'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => onPageModeChange(AuthPageModeEnum.register),
          child: const Text('Criar conta'),
        ),
      ],
    );
  }
}
