import 'package:flutter/material.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';

class MercadoriaCard extends StatelessWidget {
  const MercadoriaCard({
    super.key,
    required this.mercadoria,
    required this.onRemoveMercadoria
  });

  final Mercadoria mercadoria;
  final void Function(Mercadoria mercadoria) onRemoveMercadoria;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  mercadoria.titulo,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: 6),
                Text('Valor: R\$ ${mercadoria.valorVenda.toStringAsFixed(2).replaceAll('.', ',')}'),
                const SizedBox(height: 6),
                Text('Qtd.: ${mercadoria.quantidade}'),
              ],
            ),
            IconButton.outlined(
              onPressed: () {
                onRemoveMercadoria(mercadoria);
              },
              icon: const Icon(
                Icons.delete,
                size: 20,
                color: Color.fromARGB(255, 150, 24, 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}