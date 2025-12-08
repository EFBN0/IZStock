import 'package:izstock/features/estoque/models/mercadoria.dart';

class MercadoriaVenda {
  MercadoriaVenda({
    required this.estoqueId,
    required this.mercadoriaId,
    required this.titulo,
    required this.valorVenda,
    required this.valorCusto,
    required this.quantidade,
  });

  final String estoqueId;
  final String mercadoriaId;
  final String titulo;
  final double valorVenda;
  final double valorCusto;
  final int quantidade;

  double get valorTotal {
    return valorVenda * quantidade;
  }

  factory MercadoriaVenda.fromMercadoria(Mercadoria mercadoria) {
    return MercadoriaVenda(
      estoqueId: mercadoria.estoqueId,
      mercadoriaId: mercadoria.id,
      titulo: mercadoria.titulo,
      valorVenda: mercadoria.valorVenda,
      valorCusto: mercadoria.valorCusto,
      quantidade: 1,
    );
  }

  MercadoriaVenda copyWith({
    String? estoqueId,
    String? mercadoriaId,
    String? titulo,
    double? valorVenda,
    double? valorCusto,
    int? quantidade,
  }) {
    return MercadoriaVenda(
      estoqueId: estoqueId ?? this.estoqueId,
      mercadoriaId: mercadoriaId ?? this.mercadoriaId,
      titulo: titulo ?? this.titulo,
      valorVenda: valorVenda ?? this.valorVenda,
      valorCusto: valorCusto ?? this.valorCusto,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mercadoriaId': mercadoriaId,
      'estoqueId': estoqueId,
      'titulo': titulo,
      'valorVenda': valorVenda,
      'valorCusto': valorCusto,
      'quantidade': quantidade,
    };
  }

  factory MercadoriaVenda.fromMap(Map<String, dynamic> map) {
    return MercadoriaVenda(
      mercadoriaId: map['mercadoriaId'] ?? '',
      estoqueId: map['estoqueId'] ?? '',
      titulo: map['titulo'] ?? '',
      valorVenda: (map['valorVenda'] ?? 0.0).toDouble(),
      valorCusto: (map['valorCusto'] ?? 0.0).toDouble(),
      quantidade: map['quantidade'] ?? 1,
    );
  }
}
