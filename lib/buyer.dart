import 'dart:convert';
import 'package:empetzapp/pets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Buyer extends StatefulWidget {
  const Buyer({super.key});

  @override
  State<Buyer> createState() => _BuyerState();
}

class _BuyerState extends State<Buyer> {
  List<dynamic> category = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found! Please login again.')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.1.60/Empetz/api/v1/category');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        category = data;
      });
    } else {
      print('Error fetching users: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch user data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: category.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3,
            mainAxisSpacing: 5,
            childAspectRatio: 5 / 4,
          ),
          itemBuilder: (context, index) {
            final Category = category[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
               onTap: () {
  final categoryId = Category['id']; // or '_id' depending on your API
  final categoryName = Category['name'];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Pets(
        categoryId: categoryId,
        categoryName: categoryName,
      ),
    ),
  );
},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    Category['imagePath'] ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image));
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
