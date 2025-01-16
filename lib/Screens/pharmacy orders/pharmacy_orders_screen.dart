import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/pharmacy%20orders/model/pharmacy_order_maodel.dart';
import 'package:e_pharmacy/Screens/pharmacy%20orders/order_location.dart';
import 'package:e_pharmacy/notifications/notification_back.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PharmacyOrdersScreen extends StatelessWidget {
  static const String routeName = 'pharmacy-orders';
  const PharmacyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy Orders'),
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
        child: StreamBuilder<List<PharmacyOrderMaodel>>(
          stream: FirebaseFunctions.getMyPharmacyOrdersStream(),
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

            List<PharmacyOrderMaodel>? orders = snapshot.data;

            return ListView.builder(
              itemCount: orders?.length ?? 0,
              itemBuilder: (context, index) {
                final order = orders![index];
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
                                'City: ${order.order.city}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Governorate: ${order.order.governorate}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Payment Method: ${order.order.paymentMethod}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(),

                        // Items Section
                        if (order.order.items != null &&
                            order.order.items!.isNotEmpty) ...[
                          const Text(
                            'Items:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...order.order.items!.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: item.serviceModel.image,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Icon(Icons.error,
                                            color: Colors.red),
                                      ),
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
                          'Order ID: ${order.order.id}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Timestamp: ${DateTime.fromMillisecondsSinceEpoch(order.order.timestamp!).toString()}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(),

                        // Total Price and Order Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price: \$${order.order.totalPrice}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderLocation(
                                                longitude: order.order
                                                    .locationModel!.longitude,
                                                latitude: order.order
                                                    .locationModel!.latitude,
                                              )));
                                },
                                child: Text(
                                  "Order Location 🗺️",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
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
                              await FirebaseFunctions.cancelMyPharmacyOrder(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  order.order.id!,
                                  "Pending",
                                  order.order.userId!);
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
                            },
                            child: const Text(
                              "Cancel Order",
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
