import 'package:cloud_firestore/cloud_firestore.dart';

class Mercadoria {
  final String id;
  final String estoqueId;
  final String codigo;
  final String titulo;
  final String descricao;
  final double valorVenda;
  final double valorCusto;
  final int quantidade;
  final String? imagemUrl;

  const Mercadoria({
    required this.id,
    required this.estoqueId,
    required this.codigo,
    required this.titulo,
    required this.descricao,
    required this.valorVenda,
    required this.valorCusto,
    required this.quantidade,
    this.imagemUrl,
  });

  factory Mercadoria.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Mercadoria(
      id: doc.id,
      estoqueId: data['estoqueId'] ?? '',
      codigo: data['codigo'] ?? '',
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      valorVenda: (data['valorVenda'] ?? 0.0).toDouble(),
      valorCusto: (data['valorCusto'] ?? 0.0).toDouble(),
      quantidade: data['quantidade'] ?? 0,
      imagemUrl: data['imagemUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'estoqueId': estoqueId,
      'codigo': codigo,
      'titulo': titulo,
      'descricao': descricao,
      'valorVenda': valorVenda,
      'valorCusto': valorCusto,
      'quantidade': quantidade,
      'imagemUrl': imagemUrl,
    };
  }
}
