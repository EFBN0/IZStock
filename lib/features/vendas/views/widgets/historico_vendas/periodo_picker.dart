import 'package:flutter/material.dart';

enum PeriodoFiltro { hoje, ontem, semana, mes, personalizado }

class PeriodoPicker extends StatefulWidget {
  final Function(DateTimeRange) onPeriodoChanged;

  const PeriodoPicker({super.key, required this.onPeriodoChanged});

  @override
  State<PeriodoPicker> createState() {
    return _PeriodoPickerState();
  }
}

class _PeriodoPickerState extends State<PeriodoPicker> {
  PeriodoFiltro _selectedFilter = PeriodoFiltro.hoje;

  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilter(PeriodoFiltro.hoje);
    });
  }

  DateTime toStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime toEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  Future<void> _applyFilter(PeriodoFiltro filter) async {
    final now = DateTime.now();
    final nowStartOfDay = toStartOfDay(now);
    final nowEndOfDay = toEndOfDay(now);

    DateTimeRange newRange;

    switch (filter) {
      case PeriodoFiltro.hoje:
        newRange = DateTimeRange(start: nowStartOfDay, end: nowEndOfDay);
        break;

      case PeriodoFiltro.ontem:
        final nowMinusDay = nowStartOfDay.subtract(const Duration(days: 1));
        newRange = DateTimeRange(
          start: nowMinusDay,
          end: toEndOfDay(nowMinusDay),
        );
        break;

      case PeriodoFiltro.semana:
        final nowMinusWeek = nowStartOfDay.subtract(const Duration(days: 7));
        newRange = DateTimeRange(start: nowMinusWeek, end: nowEndOfDay);
        break;

      case PeriodoFiltro.mes:
        final startOfMonth = DateTime(now.year, now.month, 1);
        newRange = DateTimeRange(start: startOfMonth, end: nowEndOfDay);
        break;

      case PeriodoFiltro.personalizado:
        final pickedRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: now,
          initialDateRange:_customRange ?? DateTimeRange(start: nowStartOfDay, end: nowEndOfDay),
          saveText: 'Filtrar',
          helpText: 'Selecione um período'
        );

        if (pickedRange != null) {
          _customRange = DateTimeRange(
            start: toStartOfDay(pickedRange.start),
            end: toEndOfDay(pickedRange.end),
          );
          newRange = _customRange!;
        } else {
          return;
        }
        break;
    }

    setState(() {
      _selectedFilter = filter;
    });

    widget.onPeriodoChanged(newRange);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('Hoje', PeriodoFiltro.hoje),
          const SizedBox(width: 8),
          _buildChip('Ontem', PeriodoFiltro.ontem),
          const SizedBox(width: 8),
          _buildChip('7 Dias', PeriodoFiltro.semana),
          const SizedBox(width: 8),
          _buildChip('Este Mês', PeriodoFiltro.mes),
          const SizedBox(width: 8),
          _buildCustomChip(),
        ],
      ),
    );
  }

  Widget _buildChip(String label, PeriodoFiltro filtro) {
    final bool isSelected = _selectedFilter == filtro;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) _applyFilter(filtro);
      },
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      elevation: 2.0,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      side: BorderSide.none,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildCustomChip() {
    final bool isSelected = _selectedFilter == PeriodoFiltro.personalizado;
    return ActionChip(
      avatar: Icon(
        Icons.calendar_today,
        size: 16,
        color: isSelected
            ? Colors.white
            : Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        isSelected && _customRange != null
            ? '${_customRange!.start.day}/${_customRange!.start.month} - ${_customRange!.end.day}/${_customRange!.end.month}'
            : 'Outro período',
      ),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : Colors.white,
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => _applyFilter(PeriodoFiltro.personalizado),
    );
  }
}
