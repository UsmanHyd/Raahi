import 'package:flutter/material.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/my_trips/presentation/screens/my_trips_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// App root shell: hosts the 3 primary tabs behind a single persistent
/// [AppBottomNavBar]. Tab screens render body content only — this shell
/// owns the [Scaffold] so the nav bar stays fixed while tabs switch.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    HomeScreen(),
    MyTripsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
