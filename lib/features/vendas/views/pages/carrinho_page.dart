import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/widgets/confirm_dialog.dart';
import 'package:izstock/features/commons/widgets/empty_state.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_controller.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_state.dart';
import 'package:izstock/features/vendas/controllers/carrinho/search_mercadoria_controller.dart';
import 'package:izstock/features/vendas/models/meio_pagamento_enum.dart';
import 'package:izstock/features/vendas/views/pages/search_mercadoria_page.dart';
import 'package:izstock/features/vendas/views/widgets/carrinho/card_mercadoria_carrinho.dart';
import 'package:izstock/features/vendas/views/widgets/carrinho/resumo_carrinho.dart';

class CarrinhoPage extends ConsumerStatefulWidget {
  const CarrinhoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CarrinhoPageState();
  }
}

class _CarrinhoPageState extends ConsumerState<CarrinhoPage> {
  Future<MeioPagamento?> _solicitarMeioPagamento(BuildContext context) async {
    return await showModalBottomSheet<MeioPagamento>(
      context: context,
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Forma de pagamento',
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                for (final meio in MeioPagamento.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        onTap: () => Navigator.pop(context, meio),
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: meio.color.withValues(alpha: 0.12),
                          child: Icon(meio.icon, color: meio.color, size: 20),
                        ),
                        title: Text(
                          meio.label,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _limparCarrinho(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Limpar carrinho?',
      message: 'Todos os itens e o desconto serão removidos desta venda.',
      confirmLabel: 'Limpar',
      destructive: true,
    );

    if (confirmed) {
      ref.read(carrinhoControllerProvider.notifier).limparCarrinho();
    }
  }

  void _abrirBusca(BuildContext context) {
    ref.read(termoBuscaProvider.notifier).state = '';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const SearchMercadoriaPage()),
    );
  }

  void _finalizarCompra(BuildContext context) async {
    final meioPagamento = await _solicitarMeioPagamento(context);
    if (meioPagamento == null) return;

    ref
        .read(carrinhoControllerProvider.notifier)
        .finalizarVenda(meioPagamento: meioPagamento);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(carrinhoControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      if (next is AsyncData) {
        final state = next.value!;

        switch (state.status) {
          case CarrinhoStatus.vendaFinalizada:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venda registrada com sucesso'),
                backgroundColor: AppColors.success,
              ),
            );
            break;

          case CarrinhoStatus.itemRemovido:
          case CarrinhoStatus.itemAdicionado:
            break;

          case CarrinhoStatus.erro:
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mensagemErro!),
                duration: const Duration(seconds: 4),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            break;

          case CarrinhoStatus.ocioso:
            break;
        }
      }
    });

    final carrinhoAsync = ref.watch(carrinhoControllerProvider);
    final carrinho = carrinhoAsync.value;
    final temItens = carrinho?.mercadoriaList.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova venda'),
        actions: [
          if (temItens) ...[
            TextButton.icon(
              onPressed: () => _abrirBusca(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Produto'),
            ),
            IconButton(
              onPressed: () => _limparCarrinho(context),
              tooltip: 'Limpar carrinho',
              icon: const Icon(Icons.remove_shopping_cart_outlined),
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
      body: carrinhoAsync.when(
        error: (err, stack) => EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Algo deu errado',
          message: '$err',
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (carrinho) {
          if (carrinho.mercadoriaList.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Carrinho vazio',
              message: 'Adicione produtos dos seus estoques para registrar uma venda.',
              action: FilledButton.icon(
                onPressed: () => _abrirBusca(context),
                icon: const Icon(Icons.search_rounded),
                label: const Text('Buscar produto'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: carrinho.mercadoriaList.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final mercadoria = carrinho.mercadoriaList[index];
                    return CardMercadoriaCarrinho(mercadoria: mercadoria);
                  },
                ),
              ),
              ResumoCarrinho(onFinalizar: () => _finalizarCompra(context)),
            ],
          );
        },
      ),
    );
  }
}
