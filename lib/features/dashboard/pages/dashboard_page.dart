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
          title: const Text('Dashboard analítico'),
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(icon: Icon(Icons.attach_money), text: 'Resumo'),
              Tab(icon: Icon(Icons.map_outlined), text: 'Mapa'),
              Tab(icon: Icon(Icons.lightbulb_outline), text: 'Dicas'),
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