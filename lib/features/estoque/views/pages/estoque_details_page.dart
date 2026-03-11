import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/controllers/mercadoria_controller.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
    setState(() {});
  }

  void _touchMercadoria(BuildContext context, Mercadoria? mercadoria) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>
          FormMercadoria(mercadoria: mercadoria, estoque: widget.estoque),
    );
  }

  void _removeMercadoria(WidgetRef ref, Mercadoria mercadoria) {
    ref
        .read(mercadoriaControllerProvider.notifier)
        .removeMercadoria(widget.estoque.id!, mercadoria);
  }

  @override
  Widget build(BuildContext context) {
    final mercadoriaAsyncList = ref.watch(filteredMercadoriaListProvider(widget.estoque.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Estoque: ${widget.estoque.titulo}'),
        elevation: 5.0,
        shadowColor: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.5),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _touchMercadoria(context, null);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar mercadoria...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          Expanded(
            child: mercadoriaAsyncList.when(
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
                          _searchController.text.isEmpty 
                            ? 'Nenhuma mercadoria adicionada.'
                            : 'Nenhum resultado encontrado.',
                          style: TextStyle(color: Colors.grey[600], fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListView.builder(
                    itemCount: mercadorias.length,
                    itemBuilder: (ctx, index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
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
          ),
        ],
      ),
    );
  }
}