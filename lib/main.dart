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
import 'views/pages/authentication/test.dart';
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
          home: auth.isAuthenticated ? const PageWidget() : const LoginScreen(),
        );
      },
    );
  }
}
