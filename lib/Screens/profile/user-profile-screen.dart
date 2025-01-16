import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/profile/model/profilemodel.dart';
import 'package:e_pharmacy/drawer/mydrawer.dart';
import 'package:e_pharmacy/validation/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = "user-profile";
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _downloadURL;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final picker = ImagePicker();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  List<String> governorates = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Aswan',
    'Assiut'
  ];
  Map<String, List<String>> cities = {
    'Cairo': [
      'Nasr City',
      'Maadi',
      'Heliopolis',
      'Dokki',
      'Shubra',
      'El Mataria',
      'Heliopolis',
      'Musturud',
      'Fustat',
      'Bulaq'
    ],
    'Alexandria': [
      'Smouha',
      'Miami',
      'Montaza',
      'Agami',
      'Sidi Bishr',
      'Ar-Raml'
    ],
    'Giza': [
      'Dokki',
      'Agouza',
      'Imbaba',
      'Aş Şaff',
      'Al ‘Ayyāţ',
      'Madīnat Sittah Uktūbar',
      'Awsīm'
    ],
    'Aswan': ['Aswan City', 'Kom Ombo', '	Idfū', 'Abu Simbel'],
    'Assiut': [
      'Assiut Governorate',
      "Za'toun",
      'Qusayma',
      'Tall al-Asad',
      'Jirjawy',
      'Abnuda',
      'Al-Manshīḩ',
      'Al-‘Ubayyid',
      'Al-Mu’allaqa',
      'Al-‘Āzim',
      'Al-Waddā’',
      'Al-‘Azizīya',
      'Al-‘Izz',
      'Al-Nasr',
      'Al-‘Islah',
      'Al-Sharqīyah',
      'Al-Manṣūrah',
      'Al-Hamāmī',
    ]
  };

  String selectedGovernorate = 'Assiut';
  String selectedCity = 'Al-Hamāmī';

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    address.dispose();
    contactNumber.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        String fileName = _imageFile!.path.split('/').last;
        Reference storageRef = _storage.ref().child('profile/$fileName');
        await storageRef.putFile(_imageFile!);

        String downloadURL = await storageRef.getDownloadURL();
        setState(() {
          _downloadURL = downloadURL;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey,
              Colors.white,
              Colors.grey,
              Colors.white,
            ],
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFunctions.getUserProfile(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            // If the snapshot doesn't have data, show empty fields
            if (!snapshot.hasData || snapshot.data == null) {
              return _buildForm();
            }

            // If we have data, show the form with prefilled data
            ProfileModel userProfile = snapshot.data!;
            firstName.text = userProfile.firstName ?? "";
            lastName.text = userProfile.lastName ?? "";
            email.text = userProfile.email ?? "";
            address.text = userProfile.address ?? "";
            contactNumber.text = userProfile.phoneNumber ?? "";
            _downloadURL = userProfile.profileImage ?? "";
            selectedGovernorate = userProfile.governorate ?? "";
            selectedCity = userProfile.city ?? "";

            return _buildForm();
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) as ImageProvider
                      : _downloadURL != null && _downloadURL!.isNotEmpty
                          ? CachedNetworkImageProvider(_downloadURL!)
                          : const NetworkImage(
                              'https://static.vecteezy.com/system/resources/thumbnails/005/720/408/small_2x/crossed-image-icon-picture-not-available-delete-picture-symbol-free-vector.jpg',
                            ),
                  child: _downloadURL == null && _imageFile == null
                      ? Center(child: CircularProgressIndicator())
                      : null, // Optionally show a loading indicator if no image is present
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: firstName,
                    decoration: InputDecoration(
                        labelText: 'First name',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    validator: (value) =>
                        value!.isEmpty ? 'first-name-error' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: lastName,
                    decoration: InputDecoration(
                        labelText: 'Last name',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    validator: (value) =>
                        value!.isEmpty ? 'last-name-error' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: email,
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              validator: Validation.validateEmail(email.text),
            ),
            const SizedBox(height: 30),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: address,
              decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              validator: (value) => value!.isEmpty ? 'address-error' : null,
            ),
            const SizedBox(height: 30),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: contactNumber,
              decoration: InputDecoration(
                  labelText: 'Phone number',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              validator: (value) =>
                  value!.isEmpty ? 'phone-number-error' : null,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Governorate",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      enableFeedback: true,
                      dropdownColor: Colors.grey,
                      elevation: 3,
                      // isExpanded: true,
                      borderRadius: BorderRadius.zero,
                      icon: Icon(Icons.add_location),
                      value: selectedGovernorate,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGovernorate = newValue!;
                          // Reset city selection when governorate changes
                          selectedCity = cities[selectedGovernorate]![0];
                        });
                      },
                      items: governorates.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      "City",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      enableFeedback: true,
                      dropdownColor: Colors.grey,
                      elevation: 3,
                      icon: Icon(Icons.location_city_outlined),
                      value: selectedCity,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue!;
                        });
                      },
                      items: cities[selectedGovernorate]!.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _uploadImage(); // Upload the image before saving
                    if (_formKey.currentState!.validate()) {
                      ProfileModel data = ProfileModel(
                        firstName: firstName.text,
                        lastName: lastName.text,
                        address: address.text,
                        phoneNumber: contactNumber.text,
                        city: selectedCity,
                        governorate: selectedGovernorate,
                        email: email.text,
                        profileImage: _downloadURL ??
                            "", // Use existing URL if no image selected
                        id: FirebaseAuth.instance.currentUser!.uid,
                      );
                      FirebaseFunctions.addUserProfile(data);
                      firstName.clear();
                      lastName.clear();
                      address.clear();
                      contactNumber.clear();

                      email.clear();
                      final snackBar = SnackBar(
                        showCloseIcon: false,
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Congratulations',
                          message: 'Your profile has been saved successfully.',
                          inMaterialBanner: true,
                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    backgroundColor: Colors.green,
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  child: Text('Save',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
