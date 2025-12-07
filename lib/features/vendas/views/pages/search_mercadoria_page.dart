import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/widgets/search_input.dart';
import 'package:izstock/features/vendas/controllers/search_mercadoria_controller.dart';
import 'package:izstock/features/vendas/views/widgets/mercadoria_list.dart';

class SearchMercadoriaPage extends ConsumerStatefulWidget {
  const SearchMercadoriaPage({super.key});

  @override
  ConsumerState<SearchMercadoriaPage> createState() {
    return _SearchMercadoriaPageState();
  }
}

class _SearchMercadoriaPageState extends ConsumerState<SearchMercadoriaPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(36),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SearchInput(
                          placeholder: 'Buscar mercadorias',
                          onInputTextChanged: (context, q, controller) => {
                            _onSearchChanged(q),
                          },
                          focusNode: FocusNode(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 12),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        body: MercadoriaList(),
      ),
    );
  }
}
