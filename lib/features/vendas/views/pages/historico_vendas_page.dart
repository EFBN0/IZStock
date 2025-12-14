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
      appBar: AppBar(
        elevation: 5.0,
        shadowColor: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.5),
        title: Text('Histórico de vendas'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            PeriodoPicker(
              onPeriodoChanged: (range) {
                ref.read(dateTimeRangeProvider.notifier).state = range;
              },
            ),
            const SizedBox(height: 16),
            VendasPanel(),
          ],
        ),
      ),
    );
  }
}
