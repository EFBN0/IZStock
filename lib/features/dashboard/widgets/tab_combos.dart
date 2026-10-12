import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/widgets/empty_state.dart';
import 'package:izstock/features/dashboard/models/combo_regra.dart';
import '../controllers/dashboard_controller.dart';

class TabCombos extends ConsumerWidget {
  const TabCombos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combosAsync = ref.watch(combosInsightsController);

    return combosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erro ao carregar dicas: $err')),
      data: (regras) {
        if (regras.isEmpty) {
          return _buildEmptyState();
        }

        final regrasOrdenadas = List<ComboRegra>.from(regras);
        regrasOrdenadas.sort((a, b) {
          return b.confianca.compareTo(a.confianca);
        });

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          itemCount: regrasOrdenadas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final regra = regrasOrdenadas[index];
            return _buildComboCard(context, regra);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const EmptyState(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Ainda sem dicas',
      message:
          'Continue registrando vendas. Assim que houver dados suficientes, sugerimos combinações de produtos que vendem juntos.',
    );
  }

  Widget _buildComboCard(BuildContext context, ComboRegra regra) {
    final textTheme = Theme.of(context).textTheme;
    final confianca = (regra.confianca * 100).toInt();
    final isStrong = regra.lift > 1.5;
    final destaque = isStrong ? AppColors.success : Theme.of(context).colorScheme.primary;
    final labelStyle = textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final produtoStyle = textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 15);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: destaque.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Text(
                    '$confianca% de chance',
                    style: textTheme.labelSmall!.copyWith(
                      color: destaque,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isStrong) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.bolt_rounded, size: 16, color: destaque),
                  Text(
                    'Combo forte',
                    style: textTheme.labelSmall!.copyWith(
                      color: destaque,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quem leva', style: labelStyle),
                      const SizedBox(height: 2),
                      Text(regra.gatilho, style: produtoStyle),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Ofereça também', style: labelStyle),
                      const SizedBox(height: 2),
                      Text(regra.sugestao, textAlign: TextAlign.end, style: produtoStyle),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
