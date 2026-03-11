import 'package:flutter/material.dart';
import 'package:izstock/features/estoque/models/estoque.dart';

class EstoqueCard extends StatelessWidget {
  const EstoqueCard({super.key, required this.estoque, required this.onDelete});

  final Estoque estoque;
  final void Function(String estoqueId) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estoque.titulo,
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                    const SizedBox(height: 4),
                    Text('Itens: ${estoque.quantidadeItens}'),
                  ],
                ),
              ),
            ),
            Material(
              color: Theme.of(context).colorScheme.error,
              child: InkWell(
                onTap: () {
                  onDelete(estoque.id!);
                },
                child: SizedBox(
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
