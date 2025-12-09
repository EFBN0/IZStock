import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/vendas/controllers/carrinho_controller.dart';
import 'package:izstock/features/vendas/controllers/mercadoria_list_controller.dart';

class MercadoriaList extends ConsumerWidget {
  const MercadoriaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mercadoriasAgrupadasAsync = ref.watch(mercadoriasAgrupadasProvider);

    return mercadoriasAgrupadasAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erro: $err')),
      data: (estoqueMercadoriaListMap) {
        if (estoqueMercadoriaListMap.isEmpty) {
          return const Center(child: Text('Nenhum produto encontrado.'));
        }

        final estoques = estoqueMercadoriaListMap.keys.toList();
        estoques.sort();

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: estoques.length,
          itemBuilder: (ctx, index) {
            final estoque = estoques[index];
            final mercadorias = estoqueMercadoriaListMap[estoque]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderEstoque(estoque, mercadorias.length),

                ...mercadorias.map(
                  (mercadoria) => _buildItemMercadoria(mercadoria, context, ref),
                ),

                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderEstoque(String titulo, int qtd) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Row(
        children: [
          Icon(Icons.inventory_2_outlined, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            titulo.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 13,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          Text(
            '$qtd itens',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildItemMercadoria(Mercadoria mercadoria, BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(mercadoria.titulo),
      subtitle: Text(FormatterService.formatAsCurrency(mercadoria.valorVenda)),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.shopping_bag_outlined,
          color: Colors.deepPurple,
        ),
      ),
      onTap: () {
        ref
            .watch(carrinhoControllerProvider.notifier)
            .addMercadoriaToCarrinho(mercadoria);
        Navigator.of(context).pop();
      },
    );
  }
}
