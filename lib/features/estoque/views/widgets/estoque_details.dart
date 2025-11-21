import 'package:flutter/material.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';

class EstoqueDetailsPage extends StatelessWidget {
  const EstoqueDetailsPage({super.key, required this.estoque});

  final Estoque estoque;

  void _onMercadoriaTap(BuildContext context, Mercadoria mercadoria) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsetsGeometry.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Text('mercadoria '),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mercadorias = estoque.mercadorias;

    return Scaffold(
      appBar: AppBar(title: Text('Estoque: ${estoque.titulo}')),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 16),
        child: ListView.builder(
          itemCount: mercadorias.length,
          itemBuilder: (ctx, index) => Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: () {
                _onMercadoriaTap(context, mercadorias[index]);
              },
              child: Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mercadorias[index].titulo,
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                          const SizedBox(height: 6),
                          Text('Valor: R\$ ${mercadorias[index].valor}'),
                        ],
                      ),
                      IconButton.outlined(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Color.fromARGB(255, 150, 24, 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
