import 'package:flutter/material.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/estoque/models/estoque.dart';

class EstoqueCard extends StatelessWidget {
  const EstoqueCard({
    super.key,
    required this.estoque,
    required this.onTap,
    required this.onDelete,
  });

  final Estoque estoque;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final quantidade = estoque.quantidadeItens;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estoque.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quantidade == 1
                          ? '1 unidade em estoque'
                          : '$quantidade unidades em estoque',
                      style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Opções',
                onSelected: (value) {
                  if (value == 'excluir') onDelete();
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'excluir',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Excluir',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
