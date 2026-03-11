import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/controllers/mercadoria_controller.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/estoque/views/widgets/mercadoria_card.dart';
import 'package:izstock/features/estoque/views/widgets/form_mercadoria.dart';

class EstoqueDetailsPage extends ConsumerWidget {
  const EstoqueDetailsPage({super.key, required this.estoque});

  final Estoque estoque;

  void _touchMercadoria(BuildContext context, Mercadoria? mercadoria) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>
          FormMercadoria(mercadoria: mercadoria, estoque: estoque),
    );
  }

  void _removeMercadoria(WidgetRef ref, Mercadoria mercadoria) {
    ref
        .read(mercadoriaControllerProvider.notifier)
        .removeMercadoria(estoque.id!, mercadoria);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mercadoriaAsyncList = ref.watch(mercadoriaListProvider(estoque.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Estoque: ${estoque.titulo}'),
        elevation: 5.0,
        shadowColor: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.5),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _touchMercadoria(context, null);
        },
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
            padding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 10),
            child: ListView.builder(
              itemCount: mercadorias.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: GestureDetector(
                  onTap: () {
                    _touchMercadoria(context, mercadorias[index]);
                  },
                  child: MercadoriaCard(
                    mercadoria: mercadorias[index],
                    onRemoveMercadoria: (mercadoria) {
                      _removeMercadoria(ref, mercadoria);
                    },
                  ),
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
