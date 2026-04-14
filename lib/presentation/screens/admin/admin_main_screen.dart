import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_drawer.dart';
import '../shared/home_screen.dart';

import 'menu/menu_management_screen.dart';
import 'tables/table_management_screen.dart';
import '../../../core/app_theme.dart';
import '../shared/profile_screen.dart';
import '../../widgets/global/editorial_background.dart';

class AdminMainScreen extends ConsumerStatefulWidget {
  const AdminMainScreen({super.key});

  @override
  ConsumerState<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends ConsumerState<AdminMainScreen> {
  int _selectedIndex = 0;
  bool _isBottomBarVisible = true;

  final List<Widget> _screens = [
    const OperationalHomeScreen(useShell: true),
    const Center(child: Text('Reports - Coming Soon', style: TextStyle(fontSize: 18, color: Colors.grey))),
    const MenuManagementScreen(useShell: true),
    const TableManagementScreen(useShell: true),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/branding/splash_logo.png', height: 35),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: AppTheme.maroon),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const ProfileScreen())
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(),
      body: GestureDetector(
        onTap: () {
          if (_isBottomBarVisible) {
            setState(() => _isBottomBarVisible = false);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              if (notification.scrollDelta! > 10 && _isBottomBarVisible) {
                setState(() => _isBottomBarVisible = false);
              } else if (notification.scrollDelta! < -10 && !_isBottomBarVisible) {
                setState(() => _isBottomBarVisible = true);
              }
            }
            return false;
          },
          child: EditorialBackground(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isBottomBarVisible ? kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom : 0,
        child: Wrap(
          children: [
            InkWell(
              onTap: () {
                if (!_isBottomBarVisible) {
                  setState(() => _isBottomBarVisible = true);
                }
              },
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  _onItemTapped(index);
                  // Optionally keep it visible after a tap
                  setState(() => _isBottomBarVisible = true);
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppTheme.maroon,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                backgroundColor: Colors.white,
                elevation: 8,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.point_of_sale_rounded),
                    label: 'Checkout',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_rounded),
                    label: 'Reports',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.restaurant_menu_rounded),
                    label: 'Menu',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.table_restaurant_rounded),
                    label: 'Tables',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
