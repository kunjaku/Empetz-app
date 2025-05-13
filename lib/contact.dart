import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Contact Us",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
