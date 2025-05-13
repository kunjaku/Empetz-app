import 'dart:async';
import 'package:empetzapp/login.dart';
import 'package:flutter/material.dart';

class Myempetz extends StatefulWidget {
  const Myempetz({super.key});

  @override
  State<Myempetz> createState() => _MyempetzState();
}

class _MyempetzState extends State<Myempetz> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homepage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Empetz',
                 style:TextStyle(fontSize: 60,fontWeight: FontWeight.bold, color: Colors.black),
                )
              ],
            ),
          ),
    );
  }
}
