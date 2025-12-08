import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izstock/features/commons/services/location_service.dart';
import 'package:izstock/features/vendas/controllers/carrinho_controller.dart';
import 'package:izstock/features/vendas/views/pages/search_mercadoria_page.dart';
import 'package:izstock/features/vendas/views/widgets/card_mercadoria_carrinho.dart';
import 'package:izstock/features/vendas/views/widgets/resumo_carrinho.dart';

class CarrinhoPage extends ConsumerStatefulWidget {
  const CarrinhoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CarrinhoPageState();
  }
}

class _CarrinhoPageState extends ConsumerState<CarrinhoPage> {
  void _finalizarCompra() async {
    Position position = await LocationService.getLocalizacaoAtual();
    ref
        .watch(carrinhoControllerProvider.notifier)
        .finalizarVenda(
          latitude: position.latitude,
          longitude: position.longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(carrinhoControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao finalizar: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next is AsyncData && !next.isLoading) {
        final lista = next.value ?? [];
        if (lista.isEmpty && (previous?.value ?? []).isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Venda realizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });

    final mercadoriasAsync = ref.watch(carrinhoControllerProvider);

    return Scaffold(
      body: mercadoriasAsync.when(
        error: (err, stack) => Center(
          child: Text(
            'Erro: $err',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (mercadorias) {
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

          if (mercadorias.isNotEmpty) {
            mainContent = ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: mercadorias.length,
              itemBuilder: (context, index) {
                final mercadoria = mercadorias[index];

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
                      onPressed: mercadorias.isNotEmpty
                          ? _finalizarCompra
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
