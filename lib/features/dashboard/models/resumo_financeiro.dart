class ResumoFinanceiro {
  final double faturamento;
  final double lucro;
  final int qtdVendas;

  const ResumoFinanceiro({
    required this.faturamento,
    required this.lucro,
    required this.qtdVendas,
  });

  factory ResumoFinanceiro.fromMap(Map<String, dynamic> map) {
    return ResumoFinanceiro(
      faturamento: (map['faturamento'] as num?)?.toDouble() ?? 0.0,
      lucro: (map['lucro'] as num?)?.toDouble() ?? 0.0,
      qtdVendas: (map['qtdVendas'] as num?)?.toInt() ?? 0,
    );
  }

  double get ticketMedio {
    if (qtdVendas == 0) return 0.0;
    return faturamento / qtdVendas;
  }
}