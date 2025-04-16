import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'viewmodels/product_view_model.dart';
import 'viewmodels/user_view_model.dart';
import 'viewmodels/order_view_model.dart';
import 'providers/theme_provider.dart';
import 'views/pages.dart';
import 'views/pages/authentication/login.dart';
import 'providers/auth_provider.dart';

void main() async {
  await dotenv.load();  // Load the .env file
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Helper method to determine which screen to show based on auth state
  Widget _buildHomeWidget(AuthProvider auth, BuildContext context) {
    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }
    
    if (!auth.isActive) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 72, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Account Inactive',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your account is currently inactive.\nPlease contact an administrator.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Logout functionality
                  await auth.logout();
                  // No need for navigation as the consumer will rebuild
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }
    
    return const PageWidget();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ERP App',
          themeMode: themeProvider.currentTheme,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Poppins',
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              secondary: const Color(0xFF00BFA6),
              brightness: Brightness.light,
            ),
            textTheme: baseTextTheme.apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Poppins',
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              secondary: const Color(0xFF00BFA6),
              brightness: Brightness.dark,
            ),
            textTheme: baseTextTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          home: _buildHomeWidget(auth, context),
        );
      },
    );
  }
}