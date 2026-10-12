import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/vendas/controllers/historico_vendas/historico_vendas_controller.dart';
import 'package:izstock/features/vendas/views/widgets/historico_vendas/periodo_picker.dart';
import 'package:izstock/features/vendas/views/widgets/historico_vendas/vendas_panel.dart';

class HistoricoVendasPage extends ConsumerWidget {
  const HistoricoVendasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: PeriodoPicker(
              onPeriodoChanged: (range) {
                ref.read(dateTimeRangeProvider.notifier).state = range;
              },
            ),
          ),
          const Expanded(child: VendasPanel()),
        ],
      ),
    );
  }
}
