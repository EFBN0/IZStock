import 'package:flutter/material.dart';

enum MeioPagamento {
  dinheiro(
    label: 'Dinheiro',
    icon: Icons.payments_outlined,
    color: Colors.green,
  ),
  pix(
    label: 'Pix',
    icon: Icons.pix, 
    color: Colors.teal,
  ),
  cartaoCredito(
    label: 'Crédito',
    icon: Icons.credit_card,
    color: Colors.blue,
  ),
  cartaoDebito(
    label: 'Débito',
    icon: Icons.credit_card_outlined,
    color: Colors.orange,
  ),
  outro(
    label: 'Outro',
    icon: Icons.payment,
    color: Colors.grey,
  );

  final String label;
  final IconData icon;
  final Color color;

  const MeioPagamento({
    required this.label,
    required this.icon,
    required this.color,
  });

  static MeioPagamento fromString(String? value) {
    if (value == null) return MeioPagamento.outro;
    
    return MeioPagamento.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MeioPagamento.outro,
    );
  }
}