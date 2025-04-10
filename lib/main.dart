import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/product_view_model.dart';
import 'viewmodels/employee_view_model.dart';
import 'viewmodels/order_view_model.dart';
import 'providers/theme_provider.dart';
import 'views/dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => EmployeeViewModel()),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ERP App',
      themeMode: themeProvider.currentTheme,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light, // Set the brightness explicitly
        ),
        useMaterial3: true,
        brightness: Brightness.light, // Set brightness for light theme
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark, // Set the brightness explicitly
        ),
        useMaterial3: true,
        brightness: Brightness.dark, // Set brightness for dark theme
      ),
      home: const Dashboard(),
    );
  }
}
