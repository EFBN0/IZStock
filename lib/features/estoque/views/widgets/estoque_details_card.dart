import 'package:flutter/material.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';

class EstoqueDetailsCard extends StatelessWidget {
  const EstoqueDetailsCard({
    super.key,
    required this.mercadoria,
  });

  final Mercadoria mercadoria;

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
                Text('Valor: R\$ ${mercadoria.valorVenda}'),
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
    );
  }
}