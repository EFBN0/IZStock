import 'package:flutter/material.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';

class MercadoriaCard extends StatelessWidget {
  const MercadoriaCard({
    super.key,
    required this.mercadoria,
    required this.onTap,
    required this.onRemoveMercadoria,
  });

  final Mercadoria mercadoria;
  final VoidCallback onTap;
  final void Function(Mercadoria mercadoria) onRemoveMercadoria;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mercadoria.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: FormatterService.formatAsCurrency(
                              mercadoria.valorVenda,
                            ),
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                '  ·  custo ${FormatterService.formatAsCurrency(mercadoria.valorCusto)}',
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              QuantidadeBadge(quantidade: mercadoria.quantidade),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Opções',
                onSelected: (value) {
                  if (value == 'excluir') onRemoveMercadoria(mercadoria);
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

class QuantidadeBadge extends StatelessWidget {
  const QuantidadeBadge({super.key, required this.quantidade});

  final int quantidade;

  static const _limiteEstoqueBaixo = 5;

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (quantidade <= 0) {
      color = AppColors.danger;
    } else if (quantidade <= _limiteEstoqueBaixo) {
      color = AppColors.warning;
    } else {
      color = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        quantidade <= 0 ? 'Esgotado' : '$quantidade un.',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
