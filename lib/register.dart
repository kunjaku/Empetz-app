import 'dart:convert';

import 'package:empetzapp/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  bool? ischecked = false;
  bool _obscureText = true;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> senddata() async {
    final url =
        Uri.parse('http://192.168.1.60/Empetz/api/v1/user/registration');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "firstName": firstnameController.text.trim(),
          "userName": usernameController.text.trim(),
          "phone": phonenumberController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim()
        }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("saved");
      print("response${response.body}");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
    }
  }

  String? firstnameError;
  String? usernameError;
  String? phonenumberError;
  String? emailError;
  String? passwordError;

  String? validatefirstname(String username) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(username)) {
      return 'username must not contain special characters or numbers';
    }
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  String? validateUsername(String username) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(username)) {
      return 'username must not contain special characters or numbers';
    }
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  String? validatePhonenumber(String phonenumber) {
    if (!RegExp(r'^\d{10}$').hasMatch(phonenumber)) {
      return 'Phone number must be exactly 10 digits';
    }
    return null;
  }

  void onLoginPressed() {
    setState(() {
      firstnameError = validatefirstname(firstnameController.text);
      usernameError = validateUsername(usernameController.text);
      phonenumberError = validatePhonenumber(phonenumberController.text);
      emailError = validateEmail(emailController.text);
      passwordError = validatePassword(passwordController.text);
    });

    if (firstnameError == null &&
        usernameError == null &&
        phonenumberError == null &&
        emailError == null &&
        passwordError == null) {
      // Navigate to the Home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
    }
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              "REGISTER",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: firstnameController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: "First Name",
                    errorText: firstnameError,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                onChanged: (value) {
                  setState(() {
                    firstnameError = validatefirstname(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
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
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onChanged: (value) {
                  setState(() {
                    usernameError = validateUsername(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: phonenumberController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "Phone Number",
                  errorText: phonenumberError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    phonenumberError = validatePhonenumber(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "Email",
                  errorText: emailError,
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onChanged: (value) {
                  setState(() {
                    emailError = validateEmail(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
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
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "Password",
                  errorText: passwordError,
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
            Row(
              children: [
                Checkbox(
                  value: ischecked,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      ischecked = value;
                    });
                  },
                ),
                Text("keep me signed in")
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: senddata,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "alredy have an account",
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => homepage()),
                    );
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
