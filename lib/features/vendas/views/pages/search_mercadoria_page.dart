import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/widgets/search_input.dart';
import 'package:izstock/features/vendas/controllers/carrinho/search_mercadoria_controller.dart';
import 'package:izstock/features/vendas/views/widgets/carrinho/mercadoria_list.dart';

class SearchMercadoriaPage extends ConsumerStatefulWidget {
  const SearchMercadoriaPage({super.key});

  @override
  ConsumerState<SearchMercadoriaPage> createState() {
    return _SearchMercadoriaPageState();
  }
}

class _SearchMercadoriaPageState extends ConsumerState<SearchMercadoriaPage> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(termoBuscaProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar produto'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchInput(
              placeholder: 'Buscar em todos os estoques',
              autofocus: true,
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: const MercadoriaList(),
    );
  }
}
