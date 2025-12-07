import 'package:izstock/features/estoque/models/mercadoria.dart';

class MercadoriaVenda {
  MercadoriaVenda({
    this.id,
    this.vendaId,
    required this.estoqueId,
    required this.mercadoriaId,
    required this.titulo,
    required this.valor,
    required this.quantidade,
    this.imagemUrl,
  });

  final String? id;
  final String? vendaId;
  final String estoqueId;
  final String mercadoriaId;
  final String titulo;
  final double valor;
  final int quantidade;
  final String? imagemUrl;

  double get valorTotal {
    return valor * quantidade;
  }

  factory MercadoriaVenda.fromMercadoria(Mercadoria mercadoria) {
    return MercadoriaVenda(
      estoqueId: mercadoria.estoqueId,
      mercadoriaId: mercadoria.id,
      titulo: mercadoria.titulo,
      valor: mercadoria.valorVenda,
      quantidade: 1,
    );
  }

  MercadoriaVenda copyWith({
    String? id,
    String? vendaId,
    String? estoqueId,
    String? mercadoriaId,
    String? titulo,
    double? valor,
    int? quantidade,
    String? imagemUrl,
  }) {
    return MercadoriaVenda(
      id: id ?? this.id,
      vendaId: vendaId ?? this.vendaId,
      estoqueId: estoqueId ?? this.estoqueId,
      mercadoriaId: mercadoriaId ?? this.mercadoriaId,
      titulo: titulo ?? this.titulo,
      valor: valor ?? this.valor,
      quantidade: quantidade ?? this.quantidade,
      imagemUrl: imagemUrl ?? this.imagemUrl,
    );
  }
}
