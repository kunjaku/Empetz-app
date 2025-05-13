import 'dart:convert';
import 'dart:io';
import 'package:empetzapp/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Sellerscreen extends StatefulWidget {
  const Sellerscreen({super.key});

  @override
  State<Sellerscreen> createState() => _SellerscreenState();
}

class _SellerscreenState extends State<Sellerscreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? selectedGender;
  String? selectedCategoryName;
  String? selectedBreedName;
  String? selectedLocation;
  String? selectedCategoryId;
  String? selectedBreedId;
  String? selectedLocationId;

  List<dynamic> categoryList = [];
  List<dynamic> breedList = [];
  List<dynamic> locationList = [];

  File? _pickedImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchCategory();
    fetchLocations();
  }

  Future<void> fetchCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      showSnack('Token not found! Please login again.');
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
      setState(() => categoryList = data);
    }
  }

  Future<void> fetchBreedsByCategoryId(String categoryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      showSnack('Token not found! Please login again.');
      return;
    }

    final url = Uri.parse('http://192.168.1.60/Empetz/api/v1/breed/category/$categoryId');
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
        breedList = data;
        selectedBreedName = null;
      });
    }
  }

  Future<void> fetchLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      showSnack('Token not found! Please login again.');
      return;
    }
    

    final url = Uri.parse('http://192.168.1.60/Empetz/api/v1/location');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => locationList = data);
    }
  }

  Future<void> sendPetData() async {
    if (nameController.text.trim().isEmpty ||
        selectedGender == null ||
        selectedBreedId == null ||
        selectedCategoryId == null ||
        selectedLocationId == null) {
      showSnack('Please fill all required fields.');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      showSnack('Token not found! Please login again.');
      return;
    }

    final url = Uri.parse('http://192.168.1.60/Empetz/api/v1/pet');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['Gender'] = selectedGender!;
    request.fields['Vaccinated'] = 'false';
    request.fields['height'] = heightController.text.trim();
    request.fields['Price'] = priceController.text.trim();
    request.fields['Name'] = nameController.text.trim();
    request.fields['BreedId'] = selectedBreedId!;
    request.fields['weight'] = weightController.text.trim();
    request.fields['CategoryId'] = selectedCategoryId!;
    request.fields['Age'] = ageController.text.trim();
    request.fields['LocationId'] = selectedLocationId!;
    request.fields['Address'] = addressController.text.trim();
    request.fields['Discription'] = descriptionController.text.trim();
    request.fields['Certified'] = 'false';

    if (_pickedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('ImageFile', _pickedImage!.path));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        showSnack('Pet data submitted successfully!');
          Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homegage()),
      );
      } else {
        print('Failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        showSnack('Failed to submit data!');
      }
    } catch (e) {
      print('Error: $e');
      showSnack('Something went wrong!');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: const Text("Add Pet Details",
      style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: 150,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  image: _pickedImage != null
                      ? DecorationImage(
                          image: FileImage(_pickedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _pickedImage == null ? const Icon(Icons.add_a_photo, size: 50) : null,
              ),
            ),
            textField(nameController, "Nick Name"),
             // Category Dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select Category",
                ),
                value: selectedCategoryName,
                onChanged: (String? newValue) {
                  final selectedCat = categoryList.firstWhere(
                    (cat) => cat['name'] == newValue,
                    orElse: () => null,
                  );

                  setState(() {
                    selectedCategoryName = newValue;
                    selectedCategoryId = selectedCat?['id'];
                  });

                  if (selectedCategoryId != null) {
                    fetchBreedsByCategoryId(selectedCategoryId!);
                  }
                },
                items: categoryList.map<DropdownMenuItem<String>>((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['name'],
                    child: Row(
                      children: [
                        Image.network(
                          cat['imagePath'],
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        const SizedBox(width: 10),
                        Text(cat['name']),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            // Breed Dropdown
            if (selectedCategoryId != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Breed",
                  ),
                  value: selectedBreedName,
                  onChanged: (String? newValue) {
                    final selectedBreed = breedList.firstWhere(
                      (breed) => breed['name'] == newValue,
                      orElse: () => null,
                    );
                    setState(() {
                      selectedBreedName = newValue;
                      selectedBreedId = selectedBreed?['id'];
                    });
                  },
                  items: breedList.map<DropdownMenuItem<String>>((breed) {
                    return DropdownMenuItem<String>(
                      value: breed['name'],
                      child: Text(breed['name']),
                    );
                  }).toList(),
                ),
              ),

            
            textField(ageController, "Age", inputType: TextInputType.number),
            dropdownField(
              hint: "Select Gender",
              value: selectedGender,
              items: ['Male', 'Female', 'Other'],
              onChanged: (val) => setState(() => selectedGender = val),
            ),
             textField(heightController, "Height", inputType: TextInputType.number),
            textField(weightController, "Weight", inputType: TextInputType.number),
             textField(addressController, "Address"),
               // Location Dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select Location",
                ),
                value: selectedLocationId,
                onChanged: (String? newValue) {
                  final location = locationList.firstWhere(
                    (loc) => loc['id'] == newValue,
                    orElse: () => null,
                  );

                  setState(() {
                    selectedLocationId = newValue;
                    selectedLocation = location?['name'];
                  });
                },
                items: locationList.map<DropdownMenuItem<String>>((location) {
                  return DropdownMenuItem<String>(
                    value: location['id'],
                    child: Text(location['name']),
                  );
                }).toList(),
              ),
            ),
            textField(descriptionController, "Description"),
            textField(priceController, "Price", inputType: TextInputType.number),
          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: sendPetData,
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, String hint, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint,
        ),
      ),
    );
  }

  Widget dropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint,
        ),
        value: value,
        onChanged: onChanged,
        items: items.map((val) {
          return DropdownMenuItem<String>(value: val, child: Text(val));
        }).toList(),
      ),
    );
  }
}
