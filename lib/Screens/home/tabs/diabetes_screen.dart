import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/info%20screen/info-screen.dart';
import 'package:e_pharmacy/Screens/home/services-item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiabetesScreen extends StatelessWidget {
  const DiabetesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
          child: Column(
            children: [
              // Title styling
              Text(
                'Diabetes',
                style: GoogleFonts.greatVibes(
                  fontSize: 40,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // StreamBuilder for fetching services
              StreamBuilder(
                stream: FirebaseFunctions.getDiabetes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(child: Text('No services available'));
                  } else {
                    return GridView.builder(
                      shrinkWrap:
                          true, // Allows GridView to be scrollable within the SingleChildScrollView
                      physics:
                          NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final service = snapshot.data![index];
                        return ServicesItem(
                          service: service,
                          callBack: () {
                            Navigator.pushNamed(context, InfoScreen.routeName,
                                arguments: service);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
