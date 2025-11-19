import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredConfirmedPassword = '';

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    if (_enteredPassword != _enteredConfirmedPassword) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('As senhas não coincidem')));
      return;
    }

    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Falha ao se cadastrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            onTapOutside: (event) {
              _unfocus();
            },
            decoration: InputDecoration(labelText: 'Email', filled: false),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty ||
                  !value.contains('@')) {
                return 'Digite um email válido';
              }
            },
            onSaved: (value) {
              _enteredEmail = value!;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            onTapOutside: (event) {
              _unfocus();
            },
            decoration: InputDecoration(labelText: 'Senha', filled: false),
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return 'Senha deve ter pelo menos 6 caracteres';
              }
            },
            onSaved: (value) {
              _enteredPassword = value!;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            onTapOutside: (event) {
              _unfocus();
            },
            decoration: InputDecoration(
              labelText: 'Confirme sua senha',
              filled: false,
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return 'Senha deve ter pelo menos 6 caracteres';
              }
            },
            onSaved: (value) {
              _enteredConfirmedPassword = value!;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              foregroundColor: Theme.of(context).colorScheme.primaryContainer,
              textStyle: TextStyle(fontSize: 24),
            ),
            child: Text('Cadastrar'),
          ),
        ],
      ),
    );
  }
}
