import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_pharmacy/Screens/add-services/model/service-model.dart';
import 'package:e_pharmacy/Screens/info%20screen/info-screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesSearchPage extends StatefulWidget {
  static const String routeName = '/services-search';
  const ServicesSearchPage({super.key});

  @override
  _ServicesSearchPageState createState() => _ServicesSearchPageState();
}

class _ServicesSearchPageState extends State<ServicesSearchPage> {
  String query = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Medicine",
            style: GoogleFonts.domine(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search TextField
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search for medicines...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // StreamBuilder to search in the services collection
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('services').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No services found."));
                  }

                  final results = snapshot.data!.docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final type = doc['type'].toString().toLowerCase();
                    return name.contains(query) || type.contains(query);
                  }).toList();

                  if (results.isEmpty) {
                    return const Center(
                        child: Text("No matching services found."));
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final service = results[index];
                      // Convert the document to ServiceModel using fromJson
                      final serviceModel = ServiceModel.fromJson(
                          service.data() as Map<dynamic, dynamic>);

                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            serviceModel.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(serviceModel.name),
                          subtitle: Text(
                              "Price: \$${serviceModel.price}\nType: ${serviceModel.type}"),
                          onTap: () {
                            // Pass the ServiceModel to InfoScreen
                            Navigator.pushNamed(context, InfoScreen.routeName,
                                arguments: serviceModel);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
