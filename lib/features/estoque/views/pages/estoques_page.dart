import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/widgets/confirm_dialog.dart';
import 'package:izstock/features/commons/widgets/empty_state.dart';
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
            title: const Text('Novo estoque'),
            content: TextField(
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex.: Bebidas',
                errorText: actionState.hasError
                    ? actionState.error.toString()
                    : null,
              ),
              autofocus: true,
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
                onPressed: actionState.isLoading
                    ? null
                    : () {
                        ref
                            .read(estoqueControllerProvider.notifier)
                            .addEstoque(textController.text.trim());
                      },
                child: actionState.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Criar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _removeEstoque(
    BuildContext context,
    WidgetRef ref,
    Estoque estoque,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir estoque?',
      message: '"${estoque.titulo}" será removido. Essa ação não pode ser desfeita.',
      confirmLabel: 'Excluir',
      destructive: true,
    );

    if (confirmed) {
      ref.read(estoqueControllerProvider.notifier).removeEstoque(estoque.id!);
    }
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
      appBar: AppBar(title: const Text('Estoques')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addEstoque(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo estoque'),
      ),
      body: estoqueAsyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (estoques) {
          if (estoques.isEmpty) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Nenhum estoque ainda',
              message: 'Crie um estoque para começar a cadastrar suas mercadorias.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: estoques.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (ctx, index) {
              final estoque = estoques[index];
              return EstoqueCard(
                estoque: estoque,
                onTap: () => _selectEstoque(context, estoque),
                onDelete: () => _removeEstoque(context, ref, estoque),
              );
            },
          );
        },
        error: (err, stack) => EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Não foi possível carregar',
          message: '$err',
        ),
      ),
    );
  }
}
