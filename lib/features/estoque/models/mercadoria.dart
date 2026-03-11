import 'package:cloud_firestore/cloud_firestore.dart';

class Mercadoria {
  final String id;
  final String estoqueId;
  final String userId;
  final String codigo;
  final String titulo;
  final String descricao;
  final double valorVenda;
  final double valorCusto;
  final int quantidade;
  final String? imagemUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Mercadoria({
    required this.id,
    required this.estoqueId,
    required this.userId,
    required this.codigo,
    required this.titulo,
    required this.descricao,
    required this.valorVenda,
    required this.valorCusto,
    required this.quantidade,
    this.imagemUrl,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'estoqueId': estoqueId,
      'userId': userId,
      'codigo': codigo,
      'titulo': titulo,
      'descricao': descricao,
      'valorVenda': valorVenda,
      'valorCusto': valorCusto,
      'quantidade': quantidade,
      'imagemUrl': imagemUrl,
      "createdAt": createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  factory Mercadoria.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Mercadoria(
      id: doc.id,
      estoqueId: data['estoqueId'] ?? '',
      userId: data['userId'] ?? '',
      codigo: data['codigo'] ?? '',
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      valorVenda: (data['valorVenda'] ?? 0.0).toDouble(),
      valorCusto: (data['valorCusto'] ?? 0.0).toDouble(),
      quantidade: data['quantidade'] ?? 0,
      imagemUrl: data['imagemUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Mercadoria copyWith({
    String? id,
    String? estoqueId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? codigo,
    String? titulo,
    String? descricao,
    double? valorVenda,
    double? valorCusto,
    int? quantidade,
    String? imagemUrl,
  }) {
    return Mercadoria(
      id: id ?? this.id,
      estoqueId: estoqueId ?? this.estoqueId,
      userId: userId ?? this.userId,
      codigo: codigo ?? this.codigo,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      valorVenda: valorVenda ?? this.valorVenda,
      valorCusto: valorCusto ?? this.valorCusto,
      quantidade: quantidade ?? this.quantidade,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
