import 'dart:convert';

import 'package:empetzapp/homepage.dart';
import 'package:empetzapp/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool _obscureText = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> senddata() async {
    final url = Uri.parse('http://192.168.1.60/Empetz/api/v1/user/login');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userName": usernameController.text.trim(),
          "password": passwordController.text.trim(),
        }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      final data = jsonDecode(response.body);
      final token = data['token'];

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const homegage()),
      );
    }
  }

  String? usernameError;
  String? passwordError;

  String? validateUsername(String username) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(username)) {
      return 'username must not contain special characters or numbers';
    }
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase long';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  void onLoginPressed() {
    setState(() {
      usernameError = validateUsername(usernameController.text);
      passwordError = validatePassword(passwordController.text);
    });

    if (usernameError == null && passwordError == null) {
      // Navigate to the Home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const homegage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "login",
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(10),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: "User Name",
                errorText: usernameError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  usernameError = validateUsername(value);
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: "password",
                //   errorText: passwordError,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (value) {
                setState(() {
                  passwordError = validatePassword(value);
                });
              },
              obscureText: _obscureText,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: senddata,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an accound?",
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => register()),
                  );
                },
                child: Text(
                  "REGISTER",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
