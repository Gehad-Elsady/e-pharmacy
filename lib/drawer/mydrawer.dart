import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/Auth/login-screen.dart';
import 'package:e_pharmacy/Screens/cart/cart-screen.dart';
import 'package:e_pharmacy/Screens/contact/contact-screen.dart';
import 'package:e_pharmacy/Screens/history/historyscreen.dart';
import 'package:e_pharmacy/Screens/home/home-screen.dart';
import 'package:e_pharmacy/Screens/profile/user-profile-screen.dart';
import 'package:e_pharmacy/drawer/social-media-icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFunctions.getUserProfile(
                  FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2e6f95), // Fallback color
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            snapshot.data!.profileImage,
                          ),
                        ),
                        Text(
                          snapshot.data!.email,
                          style: GoogleFonts.domine(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF2e6f95),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF2e6f95),
                    ),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/005/720/408/small_2x/crossed-image-icon-picture-not-available-delete-picture-symbol-free-vector.jpg',
                        )),
                  );
                }
              }),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'Home',
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.home,
                    color: Color(0xFF723c70),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName);
                  },
                ),
                // ListTile(
                //   title: Text(
                //     'Services',
                //     style: GoogleFonts.domine(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //   ),
                //   leading: const Icon(
                //     Icons.miscellaneous_services_outlined,
                //     color: Color(0xFF723c70),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);

                //     Navigator.pushNamed(context, AddServicePage.routeName);
                //   },
                // ),
                ListTile(
                  title: Text(
                    'Cart',
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.shopping_cart_rounded,
                    color: Color(0xFF723c70),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Color(0xFF723c70),
                  ),
                  title: Text(
                    'History',
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, HistoryScreen.routeName);
                    print(FirebaseAuth.instance.currentUser?.uid);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: Color(0xFF723c70),
                  ),
                  title: Text(
                    'Profile',
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, UserProfile.routeName);
                  },
                ),

                const Divider(),

                // ListTile(
                //   leading: const Icon(
                //     Icons.settings,
                //     color: Color(0xFF723c70),
                //   ),
                //   title: Text(
                //     'Settings',
                //     style: GoogleFonts.domine(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (_) => Gps(
                //                   historymaodel: HistoryModel(),
                //                   totalPrice: 500,
                //                 )));
                //   },
                // ),
                ListTile(
                  title: Text(
                    'Contact Us',
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.contact_page,
                    color: Color(0xFF723c70),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, ContactScreen.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Color(0xFF723c70),
                  ),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    FirebaseFunctions.signOut();
                    Navigator.pushReplacementNamed(
                        context, LoginPage.routeName);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          SocialMediaIcons(),
        ],
      ),
    );
  }
}
