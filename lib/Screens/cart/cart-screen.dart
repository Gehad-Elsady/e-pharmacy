import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/cart/widget/cartitem.dart';
import 'package:e_pharmacy/Screens/history/model/historymaodel.dart';
import 'package:e_pharmacy/Screens/profile/model/profilemodel.dart';
import 'package:e_pharmacy/Screens/profile/user-profile-screen.dart';
import 'package:e_pharmacy/constants/photos/photos.dart';
import 'package:e_pharmacy/drawer/mydrawer.dart';
import 'package:e_pharmacy/location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'cart',
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("are-you-sure"),
                    actions: [
                      TextButton(
                        child: Text("yes"),
                        onPressed: () {
                          FirebaseFunctions.clearCart(
                              FirebaseAuth.instance.currentUser!.uid);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("no"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      drawer: MyDrawer(),
      body: Container(
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
          stream: FirebaseFunctions.getCardStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(Photos.emptyCart),
                  Text(
                    'Cart Empty',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }

            // Calculate the total price by summing the prices of all items
            int totalPrice = snapshot.data!
                .map((item) => int.parse(
                    item.serviceModel.price)) // Safe parse with fallback
                .reduce((value, element) => value + element); // Sum all prices

            return Column(
              children: [
                // List of cart items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final service = snapshot.data![index].serviceModel;
                      String itemId = snapshot.data![index].itemId ?? "";
                      return Column(
                        children: [
                          CartItem(service: service, itemId: itemId),
                        ],
                      );
                    },
                  ),
                ),
                // Total price at the bottom of the page
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total-price',
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'checkout',
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      onPressed: () async {
                        final userId = FirebaseAuth.instance.currentUser!.uid;
                        ProfileModel? userProfile =
                            await FirebaseFunctions.getUserProfile(userId)
                                .first;

                        if (userProfile != null) {
                          HistoryModel historyModel = HistoryModel(
                            userId: userId,
                            items: snapshot.data!,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Gps(
                                historymaodel: historyModel,
                                totalPrice: totalPrice,
                              ),
                            ),
                          );
                        } else {
                          final snackBar = SnackBar(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.5),
                            showCloseIcon: false,
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Oh Snap!',
                              message:
                                  'Your profile is not complete. Please complete it first.',
                              inMaterialBanner: true,
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                      }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
