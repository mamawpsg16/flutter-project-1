import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class TestRoutePage extends StatefulWidget {
  const TestRoutePage({super.key});

  @override
  _TestRoutePageState createState() => _TestRoutePageState();
}

class _TestRoutePageState extends State<TestRoutePage> {
  String message = 'No data';

  Future<void> fetchTestData() async {

    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/test'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          message = data['message'] ?? 'No message found';
        });
      } else {
        setState(() {
          message = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'An error occurred: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test GET Route')),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
