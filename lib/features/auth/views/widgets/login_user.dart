import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Falha ao autenticar usuário')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            onTapOutside: (event) {
              _unfocus();
            },
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  !value.contains('@')) {
                return 'Digite um email válido';
              }
              return null;
            },
            onSaved: (value) {
              _enteredEmail = value!;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            onTapOutside: (event) {
              _unfocus();
            },
            decoration: const InputDecoration(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return 'Senha deve ter pelo menos 6 caracteres';
              }
              return null;
            },
            onSaved: (value) {
              _enteredPassword = value!;
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submit,
            child: Text('Entrar'),
          ),
        ],
      ),
    );
  }
}
