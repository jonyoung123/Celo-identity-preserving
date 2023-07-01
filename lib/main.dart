// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:identity_preserving_dapp/screen/home_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Celo Identity DApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNumber = '';
  List<String> linkedAddresses = [];

  // setState(() {
  //   linkedAddresses = addresses.map((e) => e.hex).toList();
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Celo Identity DApp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
            ),
            ElevatedButton(
              child: Text('Lookup Accounts'),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: linkedAddresses.map((e) => Text(e)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
