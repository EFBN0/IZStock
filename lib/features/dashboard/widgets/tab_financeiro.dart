import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/dashboard/widgets/grafico_vendas.dart';
import '../controllers/dashboard_controller.dart';

class TabFinanceiro extends ConsumerWidget {
  const TabFinanceiro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumoAsync = ref.watch(resumoFinanceiroController);
    final historicoAsync = ref.watch(historicoVendasController);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hoje',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          resumoAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Erro: $err'),
            data: (resumo) {
              return Column(
                children: [
                  _buildKpiCard('Faturamento', resumo.faturamento, Colors.blue),
                  const SizedBox(height: 8),
                  _buildKpiCard('Lucro Líquido', resumo.lucro, Colors.green),
                  const SizedBox(height: 8),
                  _buildKpiCard(
                    'Capital de giro',
                    resumo.capitalGiro,
                    const Color.fromARGB(255, 39, 144, 176),
                  ),
                  const SizedBox(height: 8),
                  _buildKpiCard(
                    'Ticket Médio',
                    resumo.ticketMedio,
                    Colors.purple,
                  ),
                  const SizedBox(height: 8),
                  _buildKpiCard(
                    'Vendas Realizadas',
                    resumo.qtdVendas.toDouble(),
                    Colors.orange,
                    isCurrency: false,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          const Text(
            'Histórico (7 Dias)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.fromLTRB(8, 24, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: historicoAsync.when(
              data: (listaHistorico) =>
                  GraficoVendasSemanal(dadosBrutos: listaHistorico),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Não foi possível carregar o gráfico')),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    double value,
    Color color, {
    bool isCurrency = true,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      color: color.withValues(alpha: 0.05),
      child: ListTile(
        leading: Icon(Icons.analytics, color: color),
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
        ),
        trailing: Text(
          isCurrency
              ? FormatterService.formatAsCurrency(value)
              : '${value.toInt()}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
