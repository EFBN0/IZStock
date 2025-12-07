import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  void _finalizarCompra() {
    
  }

  @override
  Widget build(BuildContext context) {
    final mercadorias = ref.watch(carrinhoProvider);

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

    return Scaffold(
      body: Column(
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
                  onPressed: mercadorias.isNotEmpty ? _finalizarCompra : null,
                  child: Text('Finalizar compra'),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: double.infinity,
              child: mainContent,
            ),
          ),

          ResumoCarrinho(),
        ],
      ),
    );
  }
}
