import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:izstock/features/vendas/models/meio_pagamento_enum.dart';
import 'package:izstock/features/vendas/models/mercadoria_venda.dart';

class Venda {
  final String id;
  final String userId;
  final DateTime data;
  final double valorVendaTotal;
  final double valorCustoTotal;
  final double lucroTotal;
  final MeioPagamento meioPagamento;
  final List<MercadoriaVenda> itens;
  final double? latitude;
  final double? longitude;

  const Venda({
    required this.id,
    required this.userId,
    required this.data,
    required this.valorVendaTotal,
    required this.valorCustoTotal,
    required this.lucroTotal,
    required this.meioPagamento,
    required this.itens,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'data': Timestamp.fromDate(data),
      'valorVendaTotal': valorVendaTotal,
      'valorCustoTotal': valorCustoTotal,
      'lucroTotal': lucroTotal,
      'meioPagamento': meioPagamento.name,
      'itens': itens.map((item) => item.toMap()).toList(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Venda.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Venda(
      id: doc.id,
      userId: data['userId'] ?? '',
      data: (data['data'] as Timestamp).toDate(),
      valorVendaTotal: (data['valorVendaTotal'] ?? 0.0).toDouble(),
      valorCustoTotal: (data['valorCustoTotal'] ?? 0.0).toDouble(),
      lucroTotal: (data['lucroTotal'] ?? 0.0).toDouble(),
      meioPagamento: MeioPagamento.fromString(data['meioPagamento']),
      itens: (data['itens'] as List<dynamic>?)
              ?.map((item) => MercadoriaVenda.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  Venda copyWith({
    String? id,
    String? userId,
    DateTime? data,
    double? valorVendaTotal,
    double? valorCustoTotal,
    double? lucroTotal,
    MeioPagamento? meioPagamento,
    List<MercadoriaVenda>? itens,
    double? latitude,
    double? longitude,
  }) {
    return Venda(
      id: id ?? this.id,
      userId: userId ?? this.userId,data: data ?? this.data,
      valorVendaTotal: valorVendaTotal ?? this.valorVendaTotal,
      valorCustoTotal: valorCustoTotal ?? this.valorCustoTotal,
      lucroTotal: lucroTotal ?? this.lucroTotal,
      meioPagamento: meioPagamento ?? this.meioPagamento,
      itens: itens ?? this.itens,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
