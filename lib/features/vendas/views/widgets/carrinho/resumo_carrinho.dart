import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_controller.dart';
import 'package:flutter/services.dart';

class ResumoCarrinho extends ConsumerWidget {
  const ResumoCarrinho({super.key, required this.onFinalizar});

  final VoidCallback onFinalizar;

  void _addDesconto(BuildContext context, WidgetRef ref) {
    final estadoAtual = ref.read(carrinhoControllerProvider).value;
    final descontoAtual = estadoAtual?.desconto ?? 0.0;
    
    final textController = TextEditingController(
      text: descontoAtual > 0 ? descontoAtual.toStringAsFixed(2).replaceAll('.', ',') : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aplicar desconto'),
        content: TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          ],
          decoration: const InputDecoration(
            labelText: 'Valor do desconto',
            hintText: '0,00',
            prefixText: 'R\$ ',
          ),
          autofocus: true,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
            onPressed: () {
              final sanitizedText = textController.text.replaceAll(',', '.');
              final desconto = double.tryParse(sanitizedText) ?? 0.0;
              ref
                  .read(carrinhoControllerProvider.notifier)
                  .addDesconto(desconto);
              Navigator.of(context).pop();
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carrinhoAsync = ref.watch(carrinhoControllerProvider);
    final state = carrinhoAsync.value;

    final desconto = state?.desconto ?? 0.0;
    final bool hasDesconto = desconto > 0;

    final subtotal = ref.read(carrinhoControllerProvider.notifier).subtotal;
    final double valorTotal = ref.read(carrinhoControllerProvider.notifier).valorTotal;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final secondaryStyle = textTheme.bodyMedium!.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDesconto) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: secondaryStyle),
                Text(
                  FormatterService.formatAsCurrency(subtotal),
                  style: secondaryStyle,
                ),
              ],
            ),
            Row(
              children: [
                Text('Desconto', style: secondaryStyle),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => _addDesconto(context, ref),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  tooltip: 'Editar desconto',
                  visualDensity: VisualDensity.compact,
                  color: colorScheme.onSurfaceVariant,
                ),
                IconButton(
                  onPressed: () => ref
                      .read(carrinhoControllerProvider.notifier)
                      .addDesconto(0.0),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  tooltip: 'Remover desconto',
                  visualDensity: VisualDensity.compact,
                  color: colorScheme.onSurfaceVariant,
                ),
                const Spacer(),
                Text(
                  '- ${FormatterService.formatAsCurrency(desconto)}',
                  style: textTheme.bodyMedium!.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ] else
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _addDesconto(context, ref),
                icon: const Icon(Icons.local_offer_outlined, size: 18),
                label: const Text('Adicionar desconto'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                FormatterService.formatAsCurrency(valorTotal),
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onFinalizar,
              child: const Text('Finalizar venda'),
            ),
          ),
        ],
      ),
    );
  }
}
