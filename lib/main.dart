import 'package:e_pharmacy/Screens/Auth/login-screen.dart';
import 'package:e_pharmacy/Screens/Auth/signup-screen.dart';
import 'package:e_pharmacy/Screens/OnBoarding/boarding-screen.dart';
import 'package:e_pharmacy/Screens/Search/search_screen.dart';
import 'package:e_pharmacy/Screens/add-services/addservicescreen.dart';
import 'package:e_pharmacy/Screens/cart/cart-screen.dart';
import 'package:e_pharmacy/Screens/contact/contact-screen.dart';
import 'package:e_pharmacy/Screens/history/historyscreen.dart';
import 'package:e_pharmacy/Screens/info%20screen/info-screen.dart';
import 'package:e_pharmacy/Screens/pharmacy%20home/pharmacy_home.dart';
import 'package:e_pharmacy/Screens/pharmacy%20orders/pharmacy_orders_screen.dart';
import 'package:e_pharmacy/Screens/profile/user-profile-screen.dart';
import 'package:e_pharmacy/notifications/notification.dart';
import 'package:e_pharmacy/provider/check-user.dart';
import 'package:e_pharmacy/provider/finish-onboarding.dart';
import 'package:e_pharmacy/Backend/firebase_options.dart';
import 'package:e_pharmacy/Screens/home/home-screen.dart';
import 'package:e_pharmacy/Screens/Splash/splash-screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Optionally, initialize Firebase Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  MyNotification.initialize();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CheckUser()),
    ChangeNotifierProvider(create: (context) => FinishOnboarding()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        HomeScreen.routeName: (context) => HomeScreen(),
        UserProfile.routeName: (context) => UserProfile(),
        AddServicePage.routeName: (context) => AddServicePage(),
        InfoScreen.routeName: (context) => InfoScreen(),
        CartScreen.routeName: (context) => CartScreen(),
        HistoryScreen.routeName: (context) => HistoryScreen(),
        ContactScreen.routeName: (context) => ContactScreen(),
        ServicesSearchPage.routeName: (context) => ServicesSearchPage(),
        PharmacyHome.routeName: (context) => PharmacyHome(),
        PharmacyOrdersScreen.routeName: (context) => PharmacyOrdersScreen(),
      },
    );
  }
}
