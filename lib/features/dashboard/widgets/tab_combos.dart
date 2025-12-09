import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/dashboard/models/combo_regra.dart';
import '../controllers/dashboard_controller.dart';

class TabCombos extends ConsumerWidget {
  const TabCombos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combosAsync = ref.watch(combosInsightsController);

    return combosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erro ao carregar dicas: $err')),
      data: (regras) {
        if (regras.isEmpty) {
          return _buildEmptyState();
        }

        final regrasOrdenadas = List<ComboRegra>.from(regras);
        regrasOrdenadas.sort((a, b) {
          return b.confianca.compareTo(a.confianca);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: regrasOrdenadas.length,
          itemBuilder: (context, index) {
            final regra = regrasOrdenadas[index];
            return _buildComboCard(regra);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Ainda não temos dados suficientes.',
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Continue registrando vendas. O sistema aprenderá os padrões de compra dos seus clientes em breve.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboCard(ComboRegra regra) {
    final gatilho = regra.gatilho;
    final sugestao = regra.sugestao;
    final confianca = (regra.confianca * 100).toInt();
    final lift = regra.lift;

    final isStrong = lift > 1.5; 
    final cardColor = isStrong ? Colors.green.shade50 : Colors.blue.shade50;
    final iconColor = isStrong ? Colors.green : Colors.blue;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardColor, width: 2),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_graph, size: 18, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    'Chance de venda: $confianca%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  const Spacer(),
                  if (isStrong)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'SUPER COMBO',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Se o cliente levar...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          gatilho,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward, color: Colors.grey[400]),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Ofereça também!', style: TextStyle(fontSize: 12, color: iconColor, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          sugestao,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
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