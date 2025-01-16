import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/info%20screen/info-screen.dart';
import 'package:e_pharmacy/Screens/home/services-item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BabyFoodScreen extends StatelessWidget {
  const BabyFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey,
              Colors.white,
              Colors.grey,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Column(
              children: [
                // Title styling
                Text(
                  'Baby Food',
                  style: GoogleFonts.greatVibes(
                    fontSize: 40,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // StreamBuilder for fetching services
                StreamBuilder(
                  stream: FirebaseFunctions.getBabyFood(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No services available',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final service = snapshot.data![index];
                            return ServicesItem(
                              service: service,
                              callBack: () {
                                Navigator.pushNamed(
                                  context,
                                  InfoScreen.routeName,
                                  arguments: service,
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
