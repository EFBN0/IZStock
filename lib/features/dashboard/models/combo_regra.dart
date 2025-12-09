class ComboRegra {
  final String gatilho;
  final String sugestao;
  final double confianca;
  final double lift;

  const ComboRegra({
    required this.gatilho,
    required this.sugestao,
    required this.confianca,
    required this.lift,
  });

  factory ComboRegra.fromMap(Map<String, dynamic> map) {
    return ComboRegra(
      gatilho: map['itemA'] ?? map['gatilho'] ?? 'Produto Desconhecido',
      sugestao: map['itemB'] ?? map['sugestao'] ?? 'Produto Recomendado',
      confianca: (map['confianca'] as num?)?.toDouble() ?? 0.0,
      lift: (map['lift'] as num?)?.toDouble() ?? 0.0,
    );
  }
}