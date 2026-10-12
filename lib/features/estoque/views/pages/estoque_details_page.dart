import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/widgets/confirm_dialog.dart';
import 'package:izstock/features/commons/widgets/empty_state.dart';
import 'package:izstock/features/commons/widgets/search_input.dart';
import 'package:izstock/features/estoque/controllers/mercadoria_controller.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/estoque/models/ordenacao_mercadoria.dart';
import 'package:izstock/features/estoque/views/widgets/mercadoria_card.dart';
import 'package:izstock/features/estoque/views/widgets/form_mercadoria.dart';
import 'dart:async';

class EstoqueDetailsPage extends ConsumerStatefulWidget {
  const EstoqueDetailsPage({super.key, required this.estoque});

  final Estoque estoque;

  @override
  ConsumerState<EstoqueDetailsPage> createState() => _EstoqueDetailsPageState();
}

class _EstoqueDetailsPageState extends ConsumerState<EstoqueDetailsPage> {
  Timer? _debounce;
  bool _hasSearch = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
    setState(() {
      _hasSearch = query.isNotEmpty;
    });
  }

  void _touchMercadoria(BuildContext context, Mercadoria? mercadoria) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) =>
          FormMercadoria(mercadoria: mercadoria, estoque: widget.estoque),
    );
  }

  Future<void> _removeMercadoria(Mercadoria mercadoria) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir mercadoria?',
      message: '"${mercadoria.titulo}" será removida deste estoque.',
      confirmLabel: 'Excluir',
      destructive: true,
    );

    if (confirmed) {
      ref
          .read(mercadoriaControllerProvider.notifier)
          .removeMercadoria(widget.estoque.id!, mercadoria);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mercadoriaAsyncList = ref.watch(filteredMercadoriaListProvider(widget.estoque.id!));
    final ordenacao = ref.watch(ordenacaoMercadoriaProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.estoque.titulo),
        actions: [
          PopupMenuButton<OrdenacaoMercadoria>(
            icon: const Icon(Icons.swap_vert_rounded),
            tooltip: 'Ordenar',
            initialValue: ordenacao,
            onSelected: (value) {
              ref.read(ordenacaoMercadoriaProvider.notifier).state = value;
            },
            itemBuilder: (ctx) => [
              for (final opcao in OrdenacaoMercadoria.values)
                CheckedPopupMenuItem(
                  value: opcao,
                  checked: opcao == ordenacao,
                  child: Text(opcao.label),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _touchMercadoria(context, null),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova mercadoria'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SearchInput(
              placeholder: 'Buscar mercadoria',
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: mercadoriaAsyncList.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (mercadorias) {
                if (mercadorias.isEmpty) {
                  return _hasSearch
                      ? const EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'Nada encontrado',
                          message: 'Tente buscar por outro nome.',
                        )
                      : const EmptyState(
                          icon: Icons.sell_outlined,
                          title: 'Nenhuma mercadoria',
                          message: 'Adicione a primeira mercadoria deste estoque.',
                        );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: mercadorias.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (ctx, index) {
                    final mercadoria = mercadorias[index];
                    return MercadoriaCard(
                      mercadoria: mercadoria,
                      onTap: () => _touchMercadoria(context, mercadoria),
                      onRemoveMercadoria: _removeMercadoria,
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
          ),
        ],
      ),
    );
  }
}
