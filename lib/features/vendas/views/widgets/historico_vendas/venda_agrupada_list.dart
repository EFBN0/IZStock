import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/vendas/models/meio_pagamento_enum.dart';
import 'package:izstock/features/vendas/models/venda.dart';

class VendaAgrupadaList extends StatelessWidget {
  final List<Venda> vendaList;

  const VendaAgrupadaList({super.key, required this.vendaList});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Venda>> vendasAgrupadas = {};

    final vendasOrdenadas = List<Venda>.from(vendaList);
    vendasOrdenadas.sort((a, b) => b.data.compareTo(a.data));

    for (var venda in vendasOrdenadas) {
      final key = _formatarDataCabecalho(venda.data);
      vendasAgrupadas.putIfAbsent(key, () => []).add(venda);
    }

    final dias = vendasAgrupadas.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: dias.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ResumoPeriodo(vendas: vendaList);
        }

        final diaKey = dias[index - 1];
        final listaDoDia = vendasAgrupadas[diaKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderDia(context, diaKey, listaDoDia),
            for (final venda in listaDoDia) ...[
              CardVendaExpansivel(venda: venda),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }

  String _formatarDataCabecalho(DateTime data) {
    final hoje = DateTime.now();
    final ontem = hoje.subtract(const Duration(days: 1));

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    if (isSameDay(data, hoje)) {
      return 'Hoje';
    } else if (isSameDay(data, ontem)) {
      return 'Ontem';
    } else {
      return DateFormat("EEE, d 'de' MMM", 'pt_BR').format(data);
    }
  }

  Widget _buildHeaderDia(
    BuildContext context,
    String titulo,
    List<Venda> vendasDoDia,
  ) {
    final totalDia = vendasDoDia.fold(0.0, (sum, v) => sum + v.valorVendaTotal);
    final style = Theme.of(context).textTheme.labelMedium!.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo.toUpperCase(), style: style.copyWith(letterSpacing: 0.8)),
          Text(FormatterService.formatAsCurrency(totalDia), style: style),
        ],
      ),
    );
  }
}

class _ResumoPeriodo extends StatelessWidget {
  const _ResumoPeriodo({required this.vendas});

  final List<Venda> vendas;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final total = vendas.fold(0.0, (sum, v) => sum + v.valorVendaTotal);
    final lucro = vendas.fold(0.0, (sum, v) => sum + v.lucroTotal);

    Widget metrica(String label, String valor) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodySmall!.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium!.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          metrica('Faturamento', FormatterService.formatAsCurrency(total)),
          metrica('Lucro', FormatterService.formatAsCurrency(lucro)),
          metrica('Vendas', '${vendas.length}'),
        ],
      ),
    );
  }
}

class CardVendaExpansivel extends StatelessWidget {
  final Venda venda;

  const CardVendaExpansivel({super.key, required this.venda});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hora = DateFormat('HH:mm').format(venda.data);

    final qtdTotalItens = venda.itens.fold(
      0,
      (sum, item) => sum + item.quantidade,
    );

    final bool hasDesconto = venda.desconto > 0;
    final double subtotal = venda.valorVendaTotal + venda.desconto;
    final secondaryStyle = textTheme.bodySmall!.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontSize: 13,
    );

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 4, 12, 4),
          childrenPadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),
          leading: _buildIconePagamento(venda.meioPagamento),
          title: Text(
            FormatterService.formatAsCurrency(venda.valorVendaTotal),
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            '$hora  ·  ${venda.meioPagamento.label}  ·  $qtdTotalItens ${qtdTotalItens == 1 ? 'item' : 'itens'}',
            style: secondaryStyle,
          ),
          children: [
            const Divider(indent: 14, endIndent: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Column(
                children: [
                  ...venda.itens.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Text(
                              '${item.quantidade}×',
                              style: secondaryStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.titulo,
                              style: textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            FormatterService.formatAsCurrency(
                              item.valorVenda * item.quantidade,
                            ),
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasDesconto) ...[
                    const SizedBox(height: 6),
                    _linhaTotal('Subtotal', FormatterService.formatAsCurrency(subtotal), secondaryStyle),
                    const SizedBox(height: 2),
                    _linhaTotal(
                      'Desconto',
                      '- ${FormatterService.formatAsCurrency(venda.desconto)}',
                      secondaryStyle.copyWith(color: AppColors.success),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linhaTotal(String label, String valor, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: style), Text(valor, style: style)],
    );
  }

  Widget _buildIconePagamento(MeioPagamento meioPagamento) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: meioPagamento.color.withValues(alpha: 0.12),
      child: Icon(meioPagamento.icon, color: meioPagamento.color, size: 20),
    );
  }
}
