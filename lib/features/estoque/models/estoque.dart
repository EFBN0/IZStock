import 'package:cloud_firestore/cloud_firestore.dart';

class Estoque {
  final String? id;
  final String titulo;
  final int quantidadeItens;

  const Estoque({
    required this.titulo,
    this.id,
    this.quantidadeItens = 0,
  });

  factory Estoque.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Estoque(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      quantidadeItens: data['quantidadeItens'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'quantidadeItens': quantidadeItens,
    };
  }
}
