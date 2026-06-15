import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/transactions_tab.dart';
import 'tabs/goals_tab.dart';
import 'tabs/profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeTab(),
    TransactionsTab(),
    GoalsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24, top: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.05),
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: const Color(0xFFFFA27F),
            unselectedItemColor: Colors.white.withOpacity(0.4),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 28),
                activeIcon: Icon(Icons.home_rounded, size: 28),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined, size: 28),
                activeIcon: Icon(Icons.receipt_long, size: 28),
                label: 'Extrato',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag_outlined, size: 28),
                activeIcon: Icon(Icons.flag_rounded, size: 28),
                label: 'Metas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 28),
                activeIcon: Icon(Icons.person_rounded, size: 28),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
