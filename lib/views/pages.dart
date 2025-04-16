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
import 'package:erp_application/views/pages/user/profile.dart';

class PageWidget extends StatefulWidget {
  const PageWidget({super.key});

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();

  /// Helper to get pages, titles, and navigation items based on user role
  _NavigationData _getNavigationData(bool isAdmin) {
    final pages = [
      if (isAdmin) DashboardView(),
      OrderView(), // Everyone can see orders
      if (isAdmin) ProductView(),
      if (isAdmin) UserView(),
    ];

    final titles = [
      if (isAdmin) 'Dashboard',
      'Orders',
      if (isAdmin) 'Products',
      if (isAdmin) 'Employees',
    ];

    final navigationItems = [
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Orders',
      ),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Products',
        ),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Employees',
        ),
    ];

    return _NavigationData(pages, titles, navigationItems);
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) return;

    final success = await _authService.logout();
    if (!mounted) return;

    if (success) {
      await authProvider.logout();
      setState(() {}); // Force rebuild before navigation

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.userRole == 'admin';

    final navData = _getNavigationData(isAdmin);

    // Validate _selectedIndex
    int currentIndex = _selectedIndex;
    if (currentIndex >= navData.pages.length) currentIndex = 0;
    if (!isAdmin && currentIndex > 0) currentIndex = 0;

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(navData.titles.isNotEmpty ? navData.titles[currentIndex] : 'App'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: themeProvider.toggleTheme,
          ),
          _UserMenu(
            onProfile: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UserProfile()));
            },
            onLogout: () => _handleLogout(context),
          ),
        ],
      ),
      body: navData.pages.isNotEmpty
          ? navData.pages[currentIndex]
          : const Center(child: Text('No access to this page')),
      bottomNavigationBar: navData.navigationItems.length >= 2
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              currentIndex: currentIndex,
              onTap: onItemTapped,
              items: navData.navigationItems,
            )
          : null,
    );
  }
}

/// Simple data holder for navigation info
class _NavigationData {
  final List<Widget> pages;
  final List<String> titles;
  final List<BottomNavigationBarItem> navigationItems;

  _NavigationData(this.pages, this.titles, this.navigationItems);
}

/// Widget for the user profile/logout popup menu
class _UserMenu extends StatelessWidget {
  final VoidCallback onProfile;
  final VoidCallback onLogout;

  const _UserMenu({required this.onProfile, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: const Icon(Icons.account_circle),
      onSelected: (value) {
        if (value == 'profile') {
          onProfile();
        } else if (value == 'logout') {
          onLogout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: const [
                Icon(Icons.person, size: 20),
                SizedBox(width: 12),
                Text('Profile'),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: const [
                Icon(Icons.logout, size: 20),
                SizedBox(width: 12),
                Text('Logout'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
