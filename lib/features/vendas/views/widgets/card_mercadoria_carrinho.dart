import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/vendas/controllers/carrinho_controller.dart';
import 'package:izstock/features/vendas/models/mercadoria_venda.dart';

class CardMercadoriaCarrinho extends ConsumerWidget {
  const CardMercadoriaCarrinho({super.key, required this.mercadoria});

  final MercadoriaVenda mercadoria;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mercadoria.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      FormatterService.formatAsCurrency(mercadoria.valorVenda),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total: ${FormatterService.formatAsCurrency(mercadoria.valorTotal)}',
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              children: [
                _BotaoQuantidade(
                  icon: Icons.remove,
                  onTap: () {
                    ref
                        .watch(carrinhoControllerProvider.notifier)
                        .decrementMercadoria(mercadoria);
                  },
                  ativo: mercadoria.quantidade > 1,
                ),

                Container(
                  constraints: const BoxConstraints(minWidth: 32),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${mercadoria.quantidade}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                _BotaoQuantidade(
                  icon: Icons.add,
                  onTap: () {
                    ref
                        .watch(carrinhoControllerProvider.notifier)
                        .incrementMercadoria(mercadoria);
                  },
                  ativo: true,
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    ref
                        .watch(carrinhoControllerProvider.notifier)
                        .removeMercadoria(mercadoria);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BotaoQuantidade extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool ativo;

  const _BotaoQuantidade({
    required this.icon,
    required this.onTap,
    this.ativo = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ativo ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ativo ? Colors.grey[200] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: ativo ? Colors.black87 : Colors.grey[400],
        ),
      ),
    );
  }
}
