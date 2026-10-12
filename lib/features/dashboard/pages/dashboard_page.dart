import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/dashboard/widgets/tab_combos.dart';
import 'package:izstock/features/dashboard/widgets/tab_financeiro.dart';
import 'package:izstock/features/dashboard/widgets/tab_mapa.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Painel'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Resumo'),
              Tab(text: 'Mapa'),
              Tab(text: 'Dicas'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            TabFinanceiro(),
            TabMapa(),
            TabCombos(),
          ],
        ),
      ),
    );
  }
}