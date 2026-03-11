import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_controller.dart';
import 'package:flutter/services.dart';

class ResumoCarrinho extends ConsumerWidget {
  const ResumoCarrinho({super.key});

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
            hintText: 'Ex.: 15,00',
            prefixText: 'R\$ ',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final sanitizedText = textController.text.replaceAll(',', '.');
              final desconto = double.tryParse(sanitizedText) ?? 0.0;
              ref
                  .read(carrinhoControllerProvider.notifier)
                  .addDesconto(desconto);
              Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasDesconto)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  FormatterService.formatAsCurrency(subtotal),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          if (hasDesconto) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  FormatterService.formatAsCurrency(subtotal),
                  style: const TextStyle(
                    fontSize: 16, 
                    color: Colors.grey, 
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Desconto',
                  style: TextStyle(color: Colors.redAccent, fontSize: 14),
                ),
                Text(
                  '- ${FormatterService.formatAsCurrency(desconto)}',
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.black87, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  FormatterService.formatAsCurrency(valorTotal),
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

           if (hasDesconto)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(carrinhoControllerProvider.notifier).addDesconto(0.0);
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Remover desconto'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addDesconto(context, ref),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addDesconto(context, ref),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Aplicar desconto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}