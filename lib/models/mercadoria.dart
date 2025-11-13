class Mercadoria {
  const Mercadoria({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.valor,
    this.imagemUrl
  });

  final int id;
  final String titulo;
  final String descricao;
  final double valor;
  final String? imagemUrl;
}
