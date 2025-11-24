import 'package:flutter/material.dart';
import 'package:izstock/features/estoque/models/estoque.dart';

class EstoqueCard extends StatelessWidget {
  const EstoqueCard({super.key, required this.estoque, required this.onDelete});

  final Estoque estoque;
  final void Function(String estoqueId) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estoque.titulo,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: 6),
                Text('Itens: ${estoque.quantidadeItens}'),
              ],
            ),
            IconButton.outlined(
              onPressed: () {
                onDelete(estoque.id!);
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