import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/widgets/empty_state.dart';
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
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Nenhuma venda no período',
            message: 'Selecione outro período ou registre uma venda.',
          );
        }

        return VendaAgrupadaList(vendaList: vendaList);
      },
      error: (err, stack) => EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Não foi possível carregar',
        message: '$err',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
