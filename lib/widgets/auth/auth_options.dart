import 'package:flutter/material.dart';
import 'package:izstock/pages/auth/auth.dart';

class AuthOptions extends StatelessWidget {
  const AuthOptions({super.key, required this.onPageModeChange});

  final void Function(AuthScreenModeEnum) onPageModeChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  onPageModeChange(AuthScreenModeEnum.login);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(14),
                  ),
                ),
                child: const Text('Entrar'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  onPageModeChange(AuthScreenModeEnum.register);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(14),
                  ),
                ),
                child: Text('Cadastrar-se'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}