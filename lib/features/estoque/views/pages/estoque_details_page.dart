import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/controllers/mercadoria_controller.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/estoque/views/widgets/estoque_details_card.dart';

class EstoqueDetailsPage extends ConsumerWidget {
  const EstoqueDetailsPage({super.key, required this.estoque});

  final Estoque estoque;

  void _selectMercadoria(BuildContext context, Mercadoria mercadoria) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsetsGeometry.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            Row(children: [Text('mercadoria ')]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mercadoriaAsyncList = ref.watch(mercadoriaListProvider(estoque.id!));

    return Scaffold(
      appBar: AppBar(title: Text('Estoque: ${estoque.titulo}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: mercadoriaAsyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (mercadorias) {
          if (mercadorias.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma mercadoria adicionada.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 16),
            child: ListView.builder(
              itemCount: mercadorias.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    _selectMercadoria(context, mercadorias[index]);
                  },
                  child: EstoqueDetailsCard(mercadoria: mercadorias[index]),
                ),
              ),
            ),
          );
        },
        error: (err, stack) => Center(
          child: Text(
            'Erro: $err',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}
