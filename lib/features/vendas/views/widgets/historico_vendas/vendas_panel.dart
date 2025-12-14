import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/vendas/controllers/historico_vendas/historico_vendas_controller.dart';
import 'package:izstock/features/vendas/views/widgets/historico_vendas/venda_agrupada_list.dart';

class VendasPanel extends ConsumerWidget {
  const VendasPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendaAsyncList = ref.watch(vendaListProvider);

    return vendaAsyncList.when(
      data: (vendaList) {
        if (vendaList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nenhum venda registrada.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }

        return Expanded(child: VendaAgrupadaList(vendaList: vendaList));
      },
      error: (err, stack) => Center(
        child: Text(
          'Erro: $err',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
