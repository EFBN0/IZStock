import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/controllers/estoque_controller.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/views/pages/estoque_details_page.dart';
import 'package:izstock/features/estoque/views/widgets/estoque_card.dart';

class EstoquesPage extends ConsumerWidget {
  const EstoquesPage({super.key});

  void _addEstoque(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final actionState = ref.watch(estoqueControllerProvider);

          ref.listen(estoqueControllerProvider, (previous, next) {
            if (next is AsyncData) {
              Navigator.of(context).pop();
            }
          });

          return AlertDialog(
            title: const Text('Novo Estoque'),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Nome (ex: Livros)',
                errorText: actionState.hasError
                    ? actionState.error.toString()
                    : null,
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: actionState.isLoading
                    ? null
                    : () {
                        ref
                            .read(estoqueControllerProvider.notifier)
                            .addEstoque(textController.text);
                      },
                child: actionState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('Criar'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectEstoque(BuildContext context, Estoque estoque) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EstoqueDetailsPage(estoque: estoque),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estoqueAsyncList = ref.watch(estoqueListProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEstoque(context);
        },
        child: const Icon(Icons.add),
      ),
      body: estoqueAsyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (estoques) {
          if (estoques.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum estoque criado.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: ListView.builder(
              itemCount: estoques.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    _selectEstoque(context, estoques[index]);
                  },
                  child: EstoqueCard(
                    estoque: estoques[index],
                    onDelete: ref
                        .watch(estoqueControllerProvider.notifier)
                        .removeEstoque,
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
