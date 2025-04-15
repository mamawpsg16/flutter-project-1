import 'package:flutter/material.dart';
import 'pages/product/index.dart';
import 'pages/user/index.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dashboard_view.dart';
import '../providers/auth_provider.dart';
import '../views/pages/authentication/login.dart';
import '../services/auth_service.dart';
import 'pages/order/index.dart';


class PageWidget extends StatefulWidget {
  const PageWidget({super.key});

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardView(),
    ProductView(),
    UserView(),
    OrderView(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Products',
    'Employees',
    'Orders',
  ];

  final AuthService _authService = AuthService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ERP App'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);

              final token = authProvider.token;
              if (token == null) return;

              final success = await _authService.logout();

              if (!mounted) return;

              if (success) {
                await authProvider.logout(); // clear local state + storage
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Logout failed. Please try again.')),
                );
              }
            }
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Add this line
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
