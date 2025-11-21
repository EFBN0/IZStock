import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izstock/features/dashboard/dashboard.dart';
import 'package:izstock/features/configuracoes/configuracoes.dart';
import 'package:izstock/features/estoque/views/estoque_page.dart';
import 'package:izstock/features/vendas/vendas.dart';

class ScreenNavigationItem {
  const ScreenNavigationItem({
    required this.screen,
    required this.title,
    required this.label,
    required this.icon,
  });

  final Widget screen;
  final String title;
  final String label;
  final Icon icon;
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
      screen: EstoquePage(),
      title: 'Meus estoques',
      label: 'Estoque',
      icon: Icon(Icons.warehouse),
    ),
    const ScreenNavigationItem(
      screen: TransactionScreen(),
      title: 'Carrinho',
      label: 'Vender',
      icon: Icon(Icons.shopping_cart_outlined),
    ),
    const ScreenNavigationItem(
      screen: DashboardScreen(),
      title: 'Dashboard',
      label: 'Análises',
      icon: Icon(Icons.insert_chart_outlined_rounded),
    ),
    const ScreenNavigationItem(
      screen: SettingsScreen(),
      title: 'Configurações',
      label: 'Configurações',
      icon: Icon(Icons.settings),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        shadowColor: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.5),
        centerTitle: true,
        title: Text(_screens[_selectedScreenIndex].title),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: _screens[_selectedScreenIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedScreenIndex = index;
          });
        },
        currentIndex: _selectedScreenIndex,
        items: _screens
            .map(
              (screen) => BottomNavigationBarItem(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: screen.label,
                icon: screen.icon,
              ),
            )
            .toList(),
      ),
    );
  }
}
