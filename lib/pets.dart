import 'dart:convert';
import 'package:empetzapp/petdetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Pets extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const Pets({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<Pets> createState() => _PetsState();
}

class _PetsState extends State<Pets> {
  List<dynamic> image = [];

  @override
  void initState() {
    super.initState();
    fetchCategoryDetails();
  }

  Future<void> fetchCategoryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found!')),
      );
      return;
    }

    final url = Uri.parse(
        'http://192.168.1.60/Empetz/api/v1/pet/catagory?categoryid=${widget.categoryId}&PageNumber=1&PageSize=1000');

    try {
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
          image = data;
        });
      } else {
        print('Failed to fetch category details: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch category details')),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(widget.categoryName, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: image.isEmpty
          ? const Center(child: Text("No Data"))
          : GridView.builder(
              itemCount: image.length,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final foto = image[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailPage(petData: foto),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              foto['imagePath'] ?? 'https://via.placeholder.com/150',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                foto['name'] ?? 'No Name',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                foto['price'] != null ? '₹${foto['price']}' : 'No Price',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
