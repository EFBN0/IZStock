import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_controller.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_state.dart';
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
    return await showDialog<MeioPagamento>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Forma de Pagamento'),
          children: MeioPagamento.values.map((meio) {
            return SimpleDialogOption(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              onPressed: () {
                Navigator.pop(context, meio);
              },
              child: Row(
                children: [
                  Icon(meio.icon, color: meio.color),
                  const SizedBox(width: 16),
                  Text(meio.label, style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _finalizarCompra(BuildContext context) async {
    final meioPagamento = await _solicitarMeioPagamento(context);
    if (meioPagamento == null) return;

    ref
        .watch(carrinhoControllerProvider.notifier)
        .finalizarVenda(meioPagamento: meioPagamento);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(carrinhoControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (next is AsyncData) {
        final estado = next.value!;

        switch (estado.status) {
          case CarrinhoStatus.vendaFinalizada:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venda realizada com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            break;

          case CarrinhoStatus.itemRemovido:
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item removido'),
                duration: Duration(seconds: 1),
              ),
            );
            break;

          case CarrinhoStatus.itemAdicionado:
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item adicionado'),
                duration: Duration(seconds: 1),
              ),
            );
            break;

          case CarrinhoStatus.ocioso:
          case CarrinhoStatus.erro:
            break;
        }
      }
    });

    final carrinhoAsync = ref.watch(carrinhoControllerProvider);
    return Scaffold(
      body: carrinhoAsync.when(
        error: (err, stack) => Center(
          child: Text(
            'Erro: $err',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (carrinho) {
          Widget mainContent = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shopping_basket, size: 120),
              const SizedBox(height: 24),
              Text(
                'Sua cestinha está vazia',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Escaneie o QR Code do produto para adicioná-lo a cestinha',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          );

          if (carrinho.mercadoriaList.isNotEmpty) {
            mainContent = ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: carrinho.mercadoriaList.length,
              itemBuilder: (context, index) {
                final mercadoria = carrinho.mercadoriaList[index];
                return CardMercadoriaCarrinho(mercadoria: mercadoria);
              },
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => SearchMercadoriaPage(),
                          ),
                        );
                      },
                      label: Text('Buscar'),
                      icon: Icon(Icons.search),
                    ),
                    TextButton(
                      onPressed: carrinho.mercadoriaList.isNotEmpty
                          ? () => _finalizarCompra(context)
                          : null,
                      child: Text('Finalizar compra'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  width: double.infinity,
                  child: mainContent,
                ),
              ),

              ResumoCarrinho(),
            ],
          );
        },
      ),
    );
  }
}
