import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:izstock/features/vendas/models/venda.dart';
import 'package:izstock/features/vendas/repositories/venda_repository.dart';

final vendaRepositoryProvider = Provider<VendaRepository>((ref) {
  return VendaRepository();
});

final dateTimeRangeProvider = StateProvider<DateTimeRange>(
  (ref) => DateTimeRange(start: DateTime.now(), end: DateTime.now()),
);

final vendaListProvider = StreamProvider<List<Venda>>((ref) {
  final repository = ref.watch(vendaRepositoryProvider);
  final dateTimeRange = ref.watch(dateTimeRangeProvider);
  final startDate = Timestamp.fromDate(dateTimeRange.start);
  final endDate = Timestamp.fromDate(dateTimeRange.end);
  return repository.getVendasStreamByDateRange(startDate, endDate);
});
