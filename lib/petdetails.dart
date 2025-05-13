import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PetDetailPage extends StatefulWidget {
  final Map<String, dynamic> petData;

  const PetDetailPage({super.key, required this.petData});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  Map<String, dynamic>? sellerData;

  @override
  void initState() {
    super.initState();
    fetchSellerData();
  }

  Future<void> fetchSellerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found! Please login again.')),
      );
      return;
    }

    final userId = widget.petData['userId'];
    final url = Uri.parse('http://192.168.1.60/Empetz/user/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          sellerData = data;
        });
      } else {
        print('Failed to load seller data: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load seller data')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot make a call')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.petData['breedName'] ?? 'Pet Detail'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.network(
              widget.petData['imagePath'] ?? 'https://via.placeholder.com/300',
              height: 250,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.petData['name'] ?? 'No Name',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    Text(
                      widget.petData['locationName'] ?? 'Location not available',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.petData['price'] != null
                  ? 'Price: ₹${widget.petData['price']}'
                  : 'Price not available',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Card(
              color: const Color.fromARGB(255, 226, 213, 213),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.petData['discription'] ?? 'Description not available.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              widget.petData['address'] ?? 'Address not available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Seller Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Card(
              color: Colors.amber.shade100,
              child: ListTile(
                title: Text(sellerData?['firstName'] ?? 'Loading...'),
                subtitle: Text(sellerData?['email'] ?? ''),
                trailing: IconButton(
                  onPressed: () {
                    final phone = sellerData?['phone'];
                    if (phone != null && phone.isNotEmpty) {
                      _makePhoneCall(phone);
                    }
                  },
                  icon: const Icon(Icons.call, size: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
