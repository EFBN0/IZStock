import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraficoVendasSemanal extends StatelessWidget {
  final List<Map<String, dynamic>> dadosBrutos;

  const GraficoVendasSemanal({super.key, required this.dadosBrutos});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final List<Map<String, dynamic>> dadosProcessados = [];
    double maxValor = 0;

    for (int i = 6; i >= 0; i--) {
      final diaAlvo = currentDate.subtract(Duration(days: i));
      final idDia = DateFormat('yyyy-MM-dd').format(diaAlvo);
      final labelDia = DateFormat('E', 'pt_BR').format(diaAlvo);

      final dadosDia = dadosBrutos.firstWhere(
        (e) => e['data'] == idDia,
        orElse: () => {'faturamento': 0.0},
      );

      final valor = (dadosDia['faturamento'] as num?)?.toDouble() ?? 0.0;
      if (valor > maxValor) maxValor = valor;

      dadosProcessados.add({
        'dia': labelDia,
        'valor': valor,
        'id': 6 - i,
      });
    }

    final maxY = maxValor * 1.2;
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10);

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY == 0 ? 100 : maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY == 0 ? 20 : maxY / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outlineVariant,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  if (value >= 1000) {
                    return Text('${(value / 1000).toStringAsFixed(1)}k', 
                      style: labelStyle);
                  }
                  return Text(value.toInt().toString(), 
                      style: labelStyle);
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < dadosProcessados.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        dadosProcessados[index]['dia'],
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: dadosProcessados.map((dado) {
            return BarChartGroupData(
              x: dado['id'],
              barRods: [
                BarChartRodData(
                  toY: dado['valor'],
                  color: colorScheme.primary,
                  width: 18,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY == 0 ? 100 : maxY,
                    color: colorScheme.surfaceContainerLow,
                  ),
                ),
              ],
              showingTooltipIndicators: [0], 
            );
          }).toList(),
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 0,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY > 0 ? 'R\$ ${rod.toY.toInt()}' : '',
                  TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}