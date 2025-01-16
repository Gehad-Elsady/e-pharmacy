import 'dart:async'; // For Timer
import 'package:e_pharmacy/Backend/firebase_functions.dart';
import 'package:e_pharmacy/Screens/history/model/historymaodel.dart';
import 'package:e_pharmacy/drawer/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history';
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Timer? _timer;

  // A method to periodically check for expired time and refresh the UI
  void startTimer(Duration duration) {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(duration, () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose the timer when the screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          "History",
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey,
        centerTitle: true,
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
        child: StreamBuilder<List<HistoryModel>>(
          stream: FirebaseFunctions.getHistoryStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text("Error loading history: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No history available"));
            }

            final historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];

                // Handling null timestamp with a fallback
                DateTime timestamp = history.timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(history.timestamp!)
                    : DateTime.now();
                DateTime now = DateTime.now();
                Duration timeDiff = now.difference(timestamp);

                // Show cancel button only if the order was placed within 1 minute
                bool enableCancelButton = timeDiff.inMinutes < 5;

                // Start a timer to refresh the UI after 60 seconds
                if (enableCancelButton) {
                  startTimer(Duration(minutes: 5) - timeDiff);
                }
                String formattedTime = DateFormat('yyyy-MM-dd HH:mm a')
                    .format(timestamp.toLocal());

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Order ID: ${history.id ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Timestamp: ${formattedTime}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Status: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              history.orderStatus == 'Pending'
                                  ? TextSpan(
                                      text: history.orderStatus,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : TextSpan(
                                      text: history.orderStatus,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                            ],
                          ),
                        ),
                        Divider(),
                        if (history.items != null && history.items!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: history.items!.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Medicine Name: ${item.serviceModel.name ?? 'N/A'}"),
                                    Text(
                                        "Price: ${item.serviceModel.price ?? 'N/A'}"),
                                    Text(
                                        "Payment: ${history.paymentMethod ?? 'N/A'}"),
                                    SizedBox(height: 8),
                                    if (item.serviceModel.image != null &&
                                        item.serviceModel.image!.isNotEmpty)
                                      Image.network(
                                        item.serviceModel.image!,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        SizedBox(height: 10),
                        if (enableCancelButton)
                          Text(
                            "Cancel within ${5 - timeDiff.inMinutes} minutes",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0091ad),
                            ),
                            onPressed: enableCancelButton
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Cancel Order"),
                                          content: Text(
                                              "Are you sure you want to cancel this order?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Yes"),
                                              onPressed: () {
                                                FirebaseFunctions
                                                    .deleteHistoryOrder(
                                                        history.id!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                : null,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
