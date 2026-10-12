import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/commons/widgets/empty_state.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_controller.dart';
import 'package:izstock/features/vendas/controllers/carrinho/mercadoria_list_controller.dart';

class MercadoriaList extends ConsumerWidget {
  const MercadoriaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mercadoriasAgrupadasAsync = ref.watch(mercadoriasAgrupadasProvider);

    return mercadoriasAgrupadasAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Não foi possível carregar',
        message: '$err',
      ),
      data: (estoqueMercadoriaListMap) {
        if (estoqueMercadoriaListMap.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Nenhum produto disponível',
            message: 'Só aparecem aqui mercadorias com estoque.',
          );
        }

        final estoques = estoqueMercadoriaListMap.keys.toList();
        estoques.sort();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          itemCount: estoques.length,
          itemBuilder: (ctx, index) {
            final estoque = estoques[index];
            final mercadorias = estoqueMercadoriaListMap[estoque]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderEstoque(context, estoque),
                Card(
                  child: Column(
                    children: [
                      for (var i = 0; i < mercadorias.length; i++) ...[
                        if (i > 0) const Divider(indent: 16, endIndent: 16),
                        _buildItemMercadoria(mercadorias[i], context, ref),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderEstoque(BuildContext context, String titulo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Text(
        titulo.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildItemMercadoria(
    Mercadoria mercadoria,
    BuildContext context,
    WidgetRef ref,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
      title: Text(
        mercadoria.titulo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${FormatterService.formatAsCurrency(mercadoria.valorVenda)}  ·  ${mercadoria.quantidade} disponíveis',
        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
      ),
      trailing: Icon(Icons.add_circle_outline_rounded, color: colorScheme.primary),
      onTap: () {
        ref
            .read(carrinhoControllerProvider.notifier)
            .addMercadoriaToCarrinho(mercadoria);
        Navigator.of(context).pop();
      },
    );
  }
}
