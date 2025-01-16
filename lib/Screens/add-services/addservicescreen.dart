import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddServicePage extends StatefulWidget {
  static const String routeName = 'AddServicePage';

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  // Dropdown variables
  String? _selectedServiceType;
  final List<String> _serviceTypes = [
    "Antibiotics",
    "Diabetes",
    "Hygiene",
    "PainRelievers",
    "Baby food",
    "Eye health"
  ];

  // Pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload image to Firebase Storage and get URL
  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('service_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Save service data to Firestore
  Future<void> _saveService() async {
    if (_formKey.currentState!.validate() &&
        _image != null &&
        _selectedServiceType != null) {
      setState(() => _isUploading = true);
      final imageUrl = await _uploadImage(_image!);

      if (imageUrl != null) {
        await FirebaseFirestore.instance.collection('services').add({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': _priceController.text.trim(),
          'type': _selectedServiceType,
          'image': imageUrl,
          'createdAt': Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service added successfully')));
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _selectedServiceType = null;
        _image = null;
        // Navigator.pop(context); // Go back after saving
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload image')));
      }
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Service')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24),

                // Service Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                SizedBox(height: 16),

                // Price
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                ),
                SizedBox(height: 16),

                // Service Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Service Type',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                  value: _selectedServiceType,
                  items: _serviceTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a service type' : null,
                ),
                SizedBox(height: 16),

                // Image Picker
                _image == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No image selected',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Image.file(_image!, height: 150, fit: BoxFit.cover),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Submit Button
                _isUploading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _saveService,
                        child: Text('Add Service'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
