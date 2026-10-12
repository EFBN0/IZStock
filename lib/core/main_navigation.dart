import 'package:flutter/material.dart';
import 'package:izstock/features/configuracoes/configuracoes.dart';
import 'package:izstock/features/dashboard/pages/dashboard_page.dart';
import 'package:izstock/features/estoque/views/pages/estoques_page.dart';
import 'package:izstock/features/vendas/views/pages/historico_vendas_page.dart';
import 'package:izstock/features/vendas/views/pages/carrinho_page.dart';

class ScreenNavigationItem {
  const ScreenNavigationItem({
    required this.screen,
    required this.title,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final Widget screen;
  final String title;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() {
    return _MainNavigationScreenState();
  }
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedScreenIndex = 0;

  final List<ScreenNavigationItem> _screens = [
    const ScreenNavigationItem(
      screen: EstoquesPage(),
      title: 'Meus estoques',
      label: 'Estoque',
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2_rounded,
    ),
    const ScreenNavigationItem(
      screen: HistoricoVendasPage(),
      title: 'Histórico de vendas',
      label: 'Histórico',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
    ),
    const ScreenNavigationItem(
      screen: CarrinhoPage(),
      title: 'Carrinho',
      label: 'Vender',
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale_rounded,
    ),
    const ScreenNavigationItem(
      screen: DashboardPage(),
      title: 'Dashboard',
      label: 'Painel',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
    ),
    const ScreenNavigationItem(
      screen: SettingsScreen(),
      title: 'Configurações',
      label: 'Ajustes',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedScreenIndex,
        children: _screens.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedScreenIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedScreenIndex = index;
            });
          },
          destinations: _screens
              .map(
                (item) => NavigationDestination(
                  label: item.label,
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
