import 'package:e_pharmacy/Screens/Search/search_screen.dart';
import 'package:e_pharmacy/Screens/home/tabs/Eye_health_screen.dart';
import 'package:e_pharmacy/Screens/home/tabs/antibiotics_screen.dart';
import 'package:e_pharmacy/Screens/home/tabs/baby_food_screen.dart';
import 'package:e_pharmacy/Screens/home/tabs/diabetes_screen.dart';
import 'package:e_pharmacy/Screens/home/tabs/hygiene_screen.dart';
import 'package:e_pharmacy/Screens/home/tabs/painRelievers_screen.dart';
import 'package:e_pharmacy/drawer/mydrawer.dart';
import 'package:e_pharmacy/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  void initState() {
    MyNotification.initialize();

    super.initState();
  }

  // List of images for the Carousel
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.teal),
            onPressed: () {
              Navigator.pushNamed(context, ServicesSearchPage.routeName);
            },
          ),
        ],
        title: Row(
          mainAxisSize:
              MainAxisSize.min, // Ensures the Row takes only the required space
          children: [
            Image.asset('assets/images/logo.png', height: 35),
            Text(
              'E-Pharmacy',
              style: GoogleFonts.domine(
                fontSize: 25,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF344e41),
        selectedItemColor: Color(0xFF88D4AB),
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Antibiotics.png"),
              size: 30,
            ),
            label: 'Antibiotics',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Diabetes.png"),
              size: 30,
            ),
            label: "Diabetes",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Hygiene.png"),
              size: 30,
            ),
            label: "Hygiene And Cosmetics",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/PainRelievers.png"),
              size: 30,
            ),
            label: "PainRelievers And AntiInflammatories",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Baby_food.png"),
              size: 30,
            ),
            label: "Baby food",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/Eye_health.png"),
              size: 30,
            ),
            label: "Eye health",
          ),
        ],
      ),
    );
  }

  List<Widget> screens = [
    AntibioticsScreen(),
    DiabetesScreen(),
    HygieneScreen(),
    PainrelieversScreen(),
    BabyFoodScreen(),
    EyeHealthScreen(),
  ];
}
