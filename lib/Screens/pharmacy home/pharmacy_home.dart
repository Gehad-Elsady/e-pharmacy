import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:e_pharmacy/Screens/pharmacy%20orders/model/pharmacy_order_maodel.dart';
import 'package:e_pharmacy/Screens/pharmacy%20orders/pharmacy_orders_screen.dart';
import 'package:e_pharmacy/notifications/notification_back.dart';
import 'package:flutter/material.dart';
import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/Auth/login-screen.dart';
import 'package:e_pharmacy/Screens/history/model/historymaodel.dart';
import 'package:e_pharmacy/Screens/profile/user-profile-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PharmacyHome extends StatefulWidget {
  static const String routeName = 'pharmacy-home';

  @override
  State<PharmacyHome> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<PharmacyHome> {
  String? currentUserEmail;
  String? currentUserCity;
  String? currentPharmacyName;

  @override
  void initState() {
    super.initState();
    fetchUserCity();
  }

  void fetchUserCity() async {
    try {
      final profile = await FirebaseFunctions.getUserProfile(
              FirebaseAuth.instance.currentUser?.uid ?? '')
          .first;

      setState(() {
        currentUserCity = profile?.city ?? 'Unknown';
        currentUserEmail =
            FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
        currentPharmacyName = profile?.firstName ?? 'Unknown';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Orders',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, UserProfile.routeName);
            },
            icon: const Icon(Icons.person_2_rounded),
          ),
          TextButton(
            onPressed: () {
              // Navigate to My Orders Screen
              Navigator.pushNamed(context, PharmacyOrdersScreen.routeName);
            },
            child: const Text(
              "My Orders",
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseFunctions.signOut();
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
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
        child: StreamBuilder<List<HistoryModel>>(
          stream:
              FirebaseFunctions.getPharmacyOrdersStream(currentUserCity ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No orders available.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            List<HistoryModel>? orders = snapshot.data;

            return ListView.builder(
              itemCount: orders?.length ?? 0,
              itemBuilder: (context, index) {
                final history = orders![index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // City and Governorate Information
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'City: ${history.city}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Governorate: ${history.governorate}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Payment Method
                        Text(
                          'Payment Method: ${history.paymentMethod}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(),

                        // Items Section
                        if (history.items != null &&
                            history.items!.isNotEmpty) ...[
                          const Text(
                            'Items:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...history.items!.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.serviceModel.image,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${item.serviceModel.name}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Type: ${item.serviceModel.type}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        Text(
                                          'Price: \$${item.serviceModel.price}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          const Divider(),
                        ],

                        // Order Details
                        Text(
                          'Order ID: ${history.id}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Timestamp: ${DateTime.fromMillisecondsSinceEpoch(history.timestamp!).toString()}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(),

                        // Total Price and Order Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price: \$${history.totalPrice}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Status: ${history.orderStatus}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: history.orderStatus == "Accepted"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        history.orderStatus == "Pending"
                            ? Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [Colors.blue, Colors.blueAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    PharmacyOrderMaodel order =
                                        PharmacyOrderMaodel(
                                      pharmacyId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      order: history,
                                      pharmacyName: currentPharmacyName!,
                                    );
                                    await FirebaseFunctions.acceptPharmacyOrder(
                                        order, "Accepted");
                                    await FirebaseFunctions.notificationUser(
                                        history.userId!);
                                    final snackBar = SnackBar(
                                      showCloseIcon: false,
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Congratulations',
                                        message: 'The order has been accepted',
                                        inMaterialBanner: true,
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    // notification to the order owner
                                    await NotificationBack
                                        .sendAcceptNotification(
                                            history.userId!);
                                  },
                                  child: const Text(
                                    "Accept Order",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.tealAccent,
                                    // primary: Colors.transparent, // Transparent background as we are using gradient
                                    shadowColor: Colors
                                        .transparent, // Transparent shadow to rely on custom shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                "this order is already accepted",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
