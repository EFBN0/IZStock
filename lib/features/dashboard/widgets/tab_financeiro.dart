import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/dashboard/widgets/grafico_vendas.dart';
import 'package:izstock/features/dashboard/widgets/data_resumo_selector.dart';
import '../controllers/dashboard_controller.dart';

class TabFinanceiro extends ConsumerWidget {
  const TabFinanceiro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumoAsync = ref.watch(resumoFinanceiroController);
    final historicoAsync = ref.watch(historicoVendasController);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final sectionStyle = textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.w700,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        const DataResumoSelector(),
        const SizedBox(height: 12),
        resumoAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text('Erro: $err'),
          data: (resumo) {
            return Column(
              children: [
                _DestaqueCard(
                  label: 'Faturamento',
                  valor: FormatterService.formatAsCurrency(resumo.faturamento),
                  detalhe: resumo.qtdVendas == 1
                      ? '1 venda realizada'
                      : '${resumo.qtdVendas} vendas realizadas',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        label: 'Lucro líquido',
                        valor: FormatterService.formatAsCurrency(resumo.lucro),
                        icon: Icons.trending_up_rounded,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _KpiCard(
                        label: 'Ticket médio',
                        valor: FormatterService.formatAsCurrency(
                          resumo.ticketMedio,
                        ),
                        icon: Icons.receipt_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _KpiCard(
                  label: 'Capital de giro',
                  valor: FormatterService.formatAsCurrency(resumo.capitalGiro),
                  icon: Icons.sync_alt_rounded,
                  color: AppColors.warning,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        Text('Últimos 7 dias', style: sectionStyle),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 16, 12),
            child: historicoAsync.when(
              data: (listaHistorico) =>
                  GraficoVendasSemanal(dadosBrutos: listaHistorico),
              loading: () => const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => const SizedBox(
                height: 180,
                child: Center(child: Text('Não foi possível carregar o gráfico')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DestaqueCard extends StatelessWidget {
  const _DestaqueCard({
    required this.label,
    required this.valor,
    required this.detalhe,
  });

  final String label;
  final String valor;
  final String detalhe;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: textTheme.headlineMedium!.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detalhe,
            style: textTheme.bodySmall!.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.valor,
    required this.icon,
    required this.color,
  });

  final String label;
  final String valor;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      valor,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
