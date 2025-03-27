import 'package:flutter/material.dart';

import 'custom_textfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Text Field Example',
      home: Scaffold(
        appBar: AppBar(title: const Text("Custom Text Field Example")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTextField(
            title: "Full Name",
            controller: TextEditingController(),
            keyboardType: TextInputType.name,
          ),
        ),
      ),
    );
  }
}
