import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      if (!vendasAgrupadas.containsKey(key)) {
        vendasAgrupadas[key] = [];
      }
      vendasAgrupadas[key]!.add(venda);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: vendasAgrupadas.keys.length,
      itemBuilder: (context, index) {
        final diaKey = vendasAgrupadas.keys.elementAt(index);
        final listaDoDia = vendasAgrupadas[diaKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderDia(diaKey, listaDoDia),
            ...listaDoDia.map((venda) => CardVendaExpansivel(venda: venda)),

            const SizedBox(height: 16),
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
      return DateFormat('dd/MM/yyyy').format(data);
    }
  }

  Widget _buildHeaderDia(String titulo, List<Venda> vendasDoDia) {
    final totalDia = vendasDoDia.fold(0.0, (sum, v) => sum + v.valorVendaTotal);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontSize: 13,
              letterSpacing: 1.0,
            ),
          ),
          Text(
            'Total: R\$ ${totalDia.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.green,
              fontSize: 13,
            ),
          ),
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
    final hora = DateFormat('HH:mm').format(venda.data);

    final qtdTotalItens = venda.itens.fold(
      0,
      (sum, item) => sum + item.quantidade,
    );

    final bool hasDesconto = venda.desconto > 0;
    final double subtotal = venda.valorVendaTotal + venda.desconto;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12)
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: _buildIconePagamento(venda.meioPagamento),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hora,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                FormatterService.formatAsCurrency(venda.valorVendaTotal),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Text(
                '$qtdTotalItens itens • Detalhar',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (hasDesconto) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Com desconto',
                    style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ]
            ],
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  ...venda.itens.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            '${item.quantidade}x',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.titulo,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            FormatterService.formatAsCurrency(item.valorVenda * item.quantidade),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (hasDesconto) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                        Text(
                          FormatterService.formatAsCurrency(subtotal),
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Desconto', style: TextStyle(fontSize: 13, color: Colors.redAccent)),
                        Text(
                          '- ${FormatterService.formatAsCurrency(venda.desconto)}',
                          style: const TextStyle(
                            fontSize: 13, 
                            color: Colors.redAccent, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildIconePagamento(MeioPagamento meioPagamento) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: meioPagamento.color.withValues(alpha: 0.1),
      child: Icon(meioPagamento.icon, color: meioPagamento.color, size: 20),
    );
  }
}