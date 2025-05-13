import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.amber,
        title: Text(
          "About",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
