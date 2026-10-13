import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_controller.dart';
import 'package:izstock/features/vendas/controllers/carrinho/search_mercadoria_controller.dart';
import 'package:izstock/features/vendas/models/mercadoria_venda.dart';

class CardMercadoriaCarrinho extends ConsumerWidget {
  const CardMercadoriaCarrinho({super.key, required this.mercadoria});

  final MercadoriaVenda mercadoria;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final controller = ref.read(carrinhoControllerProvider.notifier);

    ref.watch(mercadoriasProvider);
    final estoqueDisponivel = controller.estoqueDisponivel(
      mercadoria.mercadoriaId,
    );
    final podeIncrementar =
        estoqueDisponivel == null || mercadoria.quantidade < estoqueDisponivel;
    final excedeEstoque =
        estoqueDisponivel != null && mercadoria.quantidade > estoqueDisponivel;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mercadoria.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${FormatterService.formatAsCurrency(mercadoria.valorVenda)} un.',
                    style: textTheme.bodySmall!.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (excedeEstoque) ...[
                    const SizedBox(height: 4),
                    Text(
                      estoqueDisponivel <= 0
                          ? 'Esgotado'
                          : 'Só $estoqueDisponivel disponíveis',
                      style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    FormatterService.formatAsCurrency(mercadoria.valorTotal),
                    style: textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BotaoQuantidade(
                    icon: mercadoria.quantidade == 1
                        ? Icons.delete_outline_rounded
                        : Icons.remove_rounded,
                    color: mercadoria.quantidade == 1 ? colorScheme.error : null,
                    tooltip: mercadoria.quantidade == 1 ? 'Remover' : 'Diminuir',
                    onTap: () => controller.decrementMercadoria(mercadoria),
                  ),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${mercadoria.quantidade}',
                      textAlign: TextAlign.center,
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _BotaoQuantidade(
                    icon: Icons.add_rounded,
                    tooltip: podeIncrementar ? 'Aumentar' : 'Estoque esgotado',
                    onTap: podeIncrementar
                        ? () => controller.incrementMercadoria(mercadoria)
                        : null,
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

class _BotaoQuantidade extends StatelessWidget {
  const _BotaoQuantidade({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      color: color ?? Theme.of(context).colorScheme.onSurface,
      disabledColor: Theme.of(context).colorScheme.outline,
      visualDensity: VisualDensity.compact,
    );
  }
}
