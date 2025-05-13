import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:empetzapp/AddPetdetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class seller extends StatefulWidget {
  const seller({super.key});

  @override
  State<seller> createState() => _sellerState();
}

class _sellerState extends State<seller> {
  bool? ischecked = false;

  List<dynamic> history = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found! Please login again.')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.1.60/Empetz/api/v1/user-posted-history');
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
        history = data;
      });
    } else {
      print('Error fetching users: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch user data')),
      );
    }
  }

  Future<void> delete( String id ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token not found! Please login again.')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.1.60/Empetz/api/v1/pet/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('deleted succesfully')),
      );
      fetchHistory();
    } else {
      print('Error fetching history: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete data')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Sellerscreen()),
          );
        },
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    body: ListView.builder(
      itemCount: history.length,
      itemBuilder: (context,index){
        final his = history[index];
        SizedBox(height: 10);
        return Padding(
  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
  child: Card(
    child: ListTile(
     leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      his['image'] != null
                          ? MemoryImage(base64Decode(his['image']))
                          : null,
                  child:
                      his['image'] == null
                          ? Icon(Icons.person) // fallback if image missing
                          : null,
                ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(his['name'] ?? 'Unknown Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(his['breedName'] ?? 'Unknown Breed'),
        ],
      ),
      subtitle: Row(
        children: [
          Icon(Icons.currency_rupee,size: 15,),
          Text(his['price']?.toString() ?? 'Price not available'),
        ],
      ),
      trailing: IconButton(
        onPressed: (){
          final petid = his['id'];
          if(petid != null){
            delete(petid);
          }
        }, 
        icon: Icon(Icons.delete,size: 30,)),
    ),
  ),
);

      }),
    );
  }
}
