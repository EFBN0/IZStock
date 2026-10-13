class ResumoFinanceiro {
  final double faturamento;
  final double lucro;
  final double capitalGiro;
  final int qtdVendas;
  final DateTime? data;

  const ResumoFinanceiro({
    required this.faturamento,
    required this.lucro,
    required this.capitalGiro,
    required this.qtdVendas,
    this.data,
  });

  factory ResumoFinanceiro.fromMap(Map<String, dynamic> map) {
    return ResumoFinanceiro(
      faturamento: (map['faturamento'] as num?)?.toDouble() ?? 0.0,
      lucro: (map['lucro'] as num?)?.toDouble() ?? 0.0,
      capitalGiro: (map['capitalGiro'] as num?)?.toDouble() ?? 0.0,
      qtdVendas: (map['qtdVendas'] as num?)?.toInt() ?? 0,
      data: DateTime.tryParse(map['data'] as String? ?? ''),
    );
  }

  double get ticketMedio {
    if (qtdVendas == 0) return 0.0;
    return faturamento / qtdVendas;
  }
}