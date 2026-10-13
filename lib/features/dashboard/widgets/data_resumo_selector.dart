import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:izstock/core/styles/theme.dart';
import 'package:izstock/features/commons/services/formatter_service.dart';
import 'package:izstock/features/commons/widgets/empty_state.dart';
import 'package:izstock/features/commons/widgets/search_input.dart';
import 'package:izstock/features/dashboard/models/resumo_financeiro.dart';
import '../controllers/dashboard_controller.dart';

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _capitalize(String texto) {
  if (texto.isEmpty) return texto;
  return texto[0].toUpperCase() + texto.substring(1);
}

String formatDataResumo(DateTime? data) {
  if (data == null) return 'Hoje';
  return _capitalize(
    DateFormat("EEE, d 'de' MMM 'de' y", 'pt_BR').format(data),
  );
}

class DataResumoSelector extends ConsumerWidget {
  const DataResumoSelector({super.key});

  void _openSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const _DataResumoSelectorSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSelected = ref.watch(dataResumoSelectedProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => _openSelector(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  formatDataResumo(dataSelected),
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Alterar',
                style: textTheme.labelLarge!.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.expand_more_rounded, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataResumoSelectorSheet extends ConsumerStatefulWidget {
  const _DataResumoSelectorSheet();

  @override
  ConsumerState<_DataResumoSelectorSheet> createState() =>
      _DataResumoSelectorSheetState();
}

class _DataResumoSelectorSheetState
    extends ConsumerState<_DataResumoSelectorSheet> {
  String _busca = '';

  static const _acentos = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ã': 'a',
    'é': 'e',
    'ê': 'e',
    'í': 'i',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ç': 'c',
  };

  String _normalize(String texto) {
    final buffer = StringBuffer();
    for (final char in texto.toLowerCase().split('')) {
      buffer.write(_acentos[char] ?? char);
    }
    return buffer.toString().trim();
  }

  bool _correspondeBusca(DateTime data) {
    if (_busca.isEmpty) return true;
    final textos = [
      DateFormat('dd/MM/yyyy').format(data),
      DateFormat('d/M/yyyy').format(data),
      DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR').format(data),
    ];
    final busca = _normalize(_busca);
    return textos.any((texto) => _normalize(texto).contains(busca));
  }

  void _selectDataResumo(DateTime? data) {
    ref.read(dataResumoSelectedProvider.notifier).state = data;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final resumosAsync = ref.watch(availableResumosController);
    final dataSelected = ref.watch(dataResumoSelectedProvider);
    final today = DateTime.now();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escolher dia',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Somente dias com vendas registradas',
                    style: textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SearchInput(
                    placeholder: 'Buscar por data, ex.: 13/03 ou março',
                    onChanged: (valor) => setState(() => _busca = valor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: resumosAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Não foi possível carregar',
                  message: '$err',
                ),
                data: (resumos) {
                  final mostrarHoje =
                      _busca.isEmpty ||
                      _normalize('hoje').contains(_normalize(_busca)) ||
                      _correspondeBusca(today);
                  final filtrados = resumos
                      .where((r) => !_isSameDay(r.data!, today))
                      .where((r) => _correspondeBusca(r.data!))
                      .toList();

                  if (!mostrarHoje && filtrados.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Nenhum dia encontrado',
                      message: 'Não há vendas registradas nessa data.',
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      if (mostrarHoje)
                        _ItemData(
                          titulo: 'Hoje',
                          subtitulo: DateFormat(
                            "d 'de' MMMM",
                            'pt_BR',
                          ).format(today),
                          selecionado: dataSelected == null,
                          onTap: () => _selectDataResumo(null),
                        ),
                      ..._buildGruposPorMes(
                        context,
                        filtrados,
                        dataSelected,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGruposPorMes(
    BuildContext context,
    List<ResumoFinanceiro> resumos,
    DateTime? dataSelecionada,
  ) {
    final widgets = <Widget>[];
    String? mesAtual;

    for (final resumo in resumos) {
      final data = resumo.data!;
      final mes = DateFormat("MMMM 'de' y", 'pt_BR').format(data).toUpperCase();

      if (mes != mesAtual) {
        mesAtual = mes;
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: Text(
              mes,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        );
      }

      widgets.add(
        _ItemData(
          titulo: _capitalize(
            DateFormat("EEEE, d 'de' MMM", 'pt_BR').format(data),
          ),
          subtitulo:
              '${FormatterService.formatAsCurrency(resumo.faturamento)}  ·  ${resumo.qtdVendas} ${resumo.qtdVendas == 1 ? 'venda' : 'vendas'}',
          selecionado:
              dataSelecionada != null && _isSameDay(dataSelecionada, data),
          onTap: () => _selectDataResumo(data),
        ),
      );
    }

    return widgets;
  }
}

class _ItemData extends StatelessWidget {
  const _ItemData({
    required this.titulo,
    required this.subtitulo,
    required this.selecionado,
    required this.onTap,
  });

  final String titulo;
  final String subtitulo;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: selecionado
            ? colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          title: Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selecionado ? colorScheme.primary : null,
            ),
          ),
          subtitle: Text(
            subtitulo,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
          ),
          trailing: selecionado
              ? Icon(Icons.check_rounded, color: colorScheme.primary)
              : null,
        ),
      ),
    );
  }
}
