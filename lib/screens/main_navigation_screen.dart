import 'package:flutter/material.dart';
import 'package:izstock/screens/dashboard_screen.dart';
import 'package:izstock/screens/settings_screen.dart';
import 'package:izstock/screens/stash_screen.dart';
import 'package:izstock/screens/transaction_screen.dart';

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
      screen: StashScreen(),
      title: 'Gerenciamento de estoque',
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
      appBar: AppBar(title: Text(_screens[_selectedScreenIndex].title)),
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
