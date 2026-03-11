import 'package:flutter/material.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';

class MercadoriaCard extends StatelessWidget {
  const MercadoriaCard({
    super.key,
    required this.mercadoria,
    required this.onRemoveMercadoria,
  });

  final Mercadoria mercadoria;
  final void Function(Mercadoria mercadoria) onRemoveMercadoria;

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
                      mercadoria.titulo,
                      style: Theme.of(context).textTheme.titleMedium!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Valor: ${FormatterService.formatAsCurrency(mercadoria.valorVenda)} | Custo: ${FormatterService.formatAsCurrency(mercadoria.valorCusto)}',
                    ),
                    const SizedBox(height: 4),
                    Text('Qtd.: ${mercadoria.quantidade}'),
                  ],
                ),
              ),
            ),
            Material(
              color: Theme.of(context).colorScheme.error,
              child: InkWell(
                onTap: () {
                  onRemoveMercadoria(mercadoria);
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
