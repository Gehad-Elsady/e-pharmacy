// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_pharmacy/Screens/Auth/model/usermodel.dart';
import 'package:e_pharmacy/Screens/add-services/model/service-model.dart';
import 'package:e_pharmacy/Screens/cart/model/cart-model.dart';
import 'package:e_pharmacy/Screens/contact/model/contact-model.dart';
import 'package:e_pharmacy/Screens/history/model/historymaodel.dart';
import 'package:e_pharmacy/Screens/pharmacy%20orders/model/pharmacy_order_maodel.dart';
import 'package:e_pharmacy/Screens/profile/model/profilemodel.dart';
import 'package:e_pharmacy/location/model/locationmodel.dart';
import 'package:e_pharmacy/notifications/model/notification_model.dart';
import 'package:e_pharmacy/notifications/notification_back.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  //-----------------------Login and SignUp--------------------------
  static SignUp(String emailAddress, String password,
      {required Function onSuccess,
      required Function onError,
      required String userName,
      required String role,
      required int age}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      credential.user?.sendEmailVerification();
      UserModel userModel = UserModel(
          age: age,
          email: emailAddress,
          name: userName,
          id: credential.user!.uid,
          role: role);
      addUser(userModel);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      print(e);
    }
  }

  static Login(
    String emailAddress,
    String password, {
    required Function onSuccess,
    required Function onError,
    // Callback for unverified email
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      // Check if the user's email is verified
      if (credential.user?.emailVerified ?? false) {
        onSuccess();
      } else {
        onError('Email not verified. Please verify your email.');
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
  }
  //--------------------------------------------------
  //---------------------------User Profile---------------------------

  //--------------------------------------------------
  //---------------------------User Profile---------------------------

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJason(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJason();
      },
    );
  }

  static Future<void> addUser(UserModel user) {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Future<UserModel?> readUserData() async {
    var collection = getUserCollection();

    DocumentSnapshot<UserModel> docUser =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    return docUser.data();
  }

  static CollectionReference<ProfileModel> getUserProfileCollection() {
    return FirebaseFirestore.instance
        .collection("UsersProfile")
        .withConverter<ProfileModel>(
      fromFirestore: (snapshot, options) {
        return ProfileModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addUserProfile(ProfileModel user) {
    var collection = getUserProfileCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Stream<ProfileModel?> getUserProfile(String uid) {
    return FirebaseFirestore.instance
        .collection('UsersProfile')
        .doc(uid)
        .snapshots()
        .map((userProfileSnapshot) {
      if (userProfileSnapshot.exists) {
        var data = userProfileSnapshot.data() as Map<String, dynamic>;
        return ProfileModel.fromJson(
            data); // Assuming ProfileModel has a fromJson constructor
      } else {
        print('User profile not found');
      }
    }).handleError((e) {
      print('Error fetching user profile: $e');
      return null; // Handle errors by returning null
    });
  }

  //------------------------------------------------
  static Stream<List<ServiceModel>> getAntibiotics() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore
          .collection('services')
          .where('type', isEqualTo: 'Antibiotics') // Add this filter
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            type: data['type'] ?? 'No Type',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Stream<List<ServiceModel>> getDiabetes() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore
          .collection('services')
          .where('type', isEqualTo: 'Diabetes') // Add this filter
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            type: data['type'] ?? 'No Type',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Stream<List<ServiceModel>> getHygiene() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore
          .collection('services')
          .where('type', isEqualTo: 'Hygiene') // Add this filter
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            type: data['type'] ?? 'No Type',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Stream<List<ServiceModel>> getPainRelievers() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore
          .collection('services')
          .where('type', isEqualTo: 'PainRelievers') // Add this filter
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            type: data['type'] ?? 'No Type',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Stream<List<ServiceModel>> getBabyFood() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore
          .collection('services')
          .where('type', isEqualTo: 'Baby food') // Add this filter
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            type: data['type'] ?? 'No Type',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Stream<List<ServiceModel>> getEyeHealth() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection where type is "Seeds"
      return _firestore
          .collection('services')
          .where('type', isEqualTo: 'Eye health') // Add this filter
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ServiceModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            type: data['type'] ?? 'No Type',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      return const Stream.empty(); // Return an empty stream in case of error
    }
  }

  static Future<void> clearCart(String uid) async {
    final cartCollection = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: uid);
    await cartCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  static Future<void> orderHistory(
    HistoryModel order,
  ) async {
    try {
      // Get the highest existing orderId and increment it
      final historyCollection =
          FirebaseFirestore.instance.collection('History');
      final snapshot = await historyCollection
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      int newId = 1; // Default to 1 if no orders are in the collection
      if (snapshot.docs.isNotEmpty) {
        final lastId = snapshot.docs.first['id']; // Use 'id' to compare
        if (lastId != null) {
          newId = int.tryParse(lastId) ?? 1; // Parse as int, fallback to 1
          newId += 1; // Increment the orderId
        }
      }
      ProfileModel? userProfile =
          await getUserProfile(FirebaseAuth.instance.currentUser!.uid).first;

      // Manually include additional fields from order.toJson()
      final newOrder = HistoryModel(
          id: newId.toString(),
          userId: FirebaseAuth.instance.currentUser!
              .uid, // Include additional fields explicitly
          items: order.items,
          locationModel: order.locationModel,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          city: userProfile!.city,
          governorate: userProfile.governorate,
          paymentMethod: order.paymentMethod,
          totalPrice: order.totalPrice,
          orderStatus: order.orderStatus,
          phoneNumber: userProfile.phoneNumber);

      // Add the new order to the 'History' collection with the generated orderId
      await historyCollection
          .doc() // Firestore automatically generates the document ID
          .set(newOrder.toJson()); // Use toJson() to save the data

      // Clear the cart for the current user
      clearCart(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  static Stream<List<HistoryModel>> getHistoryStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return _firestore
        .collection('History')
        .where('userId', isEqualTo: uid) // Filter by current user's ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return HistoryModel(
          timestamp: data['timestamp'] ?? 0,
          userId: data['userId'] ?? "no id",
          locationModel: data['locationModel'] != null
              ? LocationModel.fromMap(data['locationModel'])
              : null,
          items: data['items'] != null
              ? (data['items'] as List<dynamic>)
                  .map((item) => CartModel.fromMap(item))
                  .toList()
              : [],
          id: data['id'] ?? "No Id",
          city: data['city'] ?? "No City",
          governorate: data['governorate'] ?? "No Governorate",
          paymentMethod: data['paymentMethod'] ?? "No Payment Method",
          totalPrice: data['totalPrice'] ?? 0,
          orderStatus: data['orderStatus'] ?? "No Order Status",
        );
      }).toList();
    });
  }

  static Future<void> deleteHistoryOrder(String itemId) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print('User is not authenticated.');
      return;
    }

    try {
      // Get the document(s) that match the userId and itemId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('History')
          .where('id', isEqualTo: itemId)
          .where('userId',
              isEqualTo: uid) // Ensure the item belongs to the current user
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No items found to delete.');
        return;
      }

      // Delete each document found
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Service deleted successfully!');
    } catch (e) {
      print('Error deleting service: $e');
    }
  }
  //---------------------------Cart---------------------------

  static Stream<List<CartModel>> getCardStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _firestore
        .collection('cart')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartModel(
          userId: data['userId'] ?? "no id",
          serviceModel: ServiceModel.fromJson(data['serviceModel']),
          itemId: data['itemId'] ?? "no id",
        );
      }).toList();
    });
  }

  static Future<void> addCartService(CartModel model) async {
    // Get the highest existing itemId and increment it
    final cartCollection = FirebaseFirestore.instance.collection('cart');
    final snapshot =
        await cartCollection.orderBy('itemId', descending: true).limit(1).get();

    int newId = 1; // Default to 1 if no items are in the collection
    if (snapshot.docs.isNotEmpty) {
      final lastId = int.parse(snapshot.docs.first['itemId']);
      newId = lastId + 1;
    }

    final cartItem = CartModel(
      itemId: newId.toString(),
      serviceModel: model.serviceModel,
      userId: model.userId,
    );

    await cartCollection.add(cartItem.toMap());
  }

  static Future<void> deleteCartService(String itemId) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print('User is not authenticated.');
      return;
    }

    try {
      // Get the document(s) that match the userId and itemId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('itemId', isEqualTo: itemId)
          .where('userId',
              isEqualTo: uid) // Ensure the item belongs to the current user
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No items found to delete.');
        return;
      }

      // Delete each document found
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Service deleted successfully!');
    } catch (e) {
      print('Error deleting service: $e');
    }
  }

  static Future<void> checkOut(
      int totalPrice, Function onSuccess, Function onError) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Listen to the user profile stream
    await for (var profileData in getUserProfile(uid)) {
      if (profileData != null) {
        onSuccess(); // Profile is valid, proceed with success
        return; // Exit after success is handled
      } else {
        onError(); // Handle the error if profile data is null
        return; // Exit after error is handled
      }
    }
  }

  static Future<void> addProblem(ContactModel problem) async {
    try {
      await FirebaseFirestore.instance
          .collection('Problem')
          .doc()
          .withConverter<ContactModel>(
        fromFirestore: (snapshot, options) {
          return ContactModel.fromJson(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toJson();
        },
      ).set(problem);
      print('problem added successfully!');
    } catch (e) {
      print('Error adding problem: $e');
    }
  }

  // ----------------------------------------------------------------business

  static Stream<List<HistoryModel>> getPharmacyOrdersStream(String city) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection('History')
        .where('city', isEqualTo: city) // Filter by current user's ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return HistoryModel(
          timestamp: data['timestamp'] ?? 0,
          userId: data['userId'] ?? "no id",
          locationModel: data['locationModel'] != null
              ? LocationModel.fromMap(data['locationModel'])
              : null,
          items: data['items'] != null
              ? (data['items'] as List<dynamic>)
                  .map((item) => CartModel.fromMap(item))
                  .toList()
              : [],
          id: data['id'] ?? "No Id",
          city: data['city'] ?? "No City",
          governorate: data['governorate'] ?? "No Governorate",
          paymentMethod: data['paymentMethod'] ?? "No Payment Method",
          totalPrice: data['totalPrice'] ?? 0,
          orderStatus: data['orderStatus'] ?? "No Status",
          phoneNumber: data['phoneNumber'] ?? "No Phone Number",
        );
      }).toList();
    });
  }

  static Future<void> acceptPharmacyOrder(
      PharmacyOrderMaodel order, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('PharmacyOrders')
          .doc()
          .withConverter<PharmacyOrderMaodel>(
        fromFirestore: (snapshot, options) {
          return PharmacyOrderMaodel.fromJson(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toJson();
        },
      ).set(order);
      updateOrderStatus(order.order.id!, newStatus);
      print('Order added successfully!');
    } catch (e) {
      print('Error adding Order: $e');
    }
  }

  static Future<void> updateOrderStatus(
      String orderId, String newStatus) async {
    try {
      // Reference to the Firestore collection 'History'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('History')
          .where('id', isEqualTo: orderId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference from the first document in the query result
        DocumentReference orderRef = querySnapshot.docs[0].reference;

        // Update the orderStatus field
        await orderRef.update({
          'orderStatus': newStatus,
        });

        print("Order status updated successfully!");
      } else {
        print("Order not found!");
      }
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  static Stream<List<PharmacyOrderMaodel>> getMyPharmacyOrdersStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return _firestore
        .collection('PharmacyOrders')
        .where('pharmacyId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PharmacyOrderMaodel.fromJson(
            data); // Assuming a `fromMap` method exists
      }).toList();
    });
  }

  static Future<void> cancelMyPharmacyOrder(String pharmacyId, String orderId,
      String orderStatus, String orderUserId) async {
    try {
      final query = FirebaseFirestore.instance
          .collection('PharmacyOrders')
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('order.id',
              isEqualTo: orderId); // Use dot notation for nested field

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        // Delete the specific order
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
        updateOrderStatus(orderId, orderStatus);
        await NotificationBack.sendDeclinedNotification(orderUserId);
        print(
            'Order deleted successfully for orderId: $orderId and pharmacyId: $pharmacyId');
      } else {
        print(
            'No matching order found for orderId: $orderId and pharmacyId: $pharmacyId');
      }
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  static Future<void> notificationUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(userId) // Set the document ID as the user ID
        .set({
      'message': 'Your order is accepted Order will delivered  after 45m',
    });
    Timer(Duration(minutes: 1), () {
      deleteNotification(userId);
    });
  }

  static Future<void> deleteNotification(String userId) async {
    try {
      // Access the Notifications collection and delete the document with the specific userId
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(userId) // Target the document ID corresponding to the userId
          .delete();

      print('Notification deleted successfully for userId: $userId');
    } catch (e) {
      print('Error deleting notification for userId: $userId. Error: $e');
    }
  }

  //--------------------------Notifications--------------------------

  static Future<void> addDeviceTokens(NotificationModel token) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserTokens')
          .doc(token.id)
          .withConverter<NotificationModel>(
        fromFirestore: (snapshot, options) {
          return NotificationModel.fromJson(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toJson();
        },
      ).set(token);
      print('token added successfully!');
    } catch (e) {
      print('Error adding token: $e');
    }
  }

  static Stream<String?> getUserDeviceTokenStream(String userId) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection('UserTokens')
        .doc(
            userId) // Directly reference the document with the userId as the document ID.
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return data['deviceToken'] as String?; // Return the deviceToken field.
      }
      return null; // Return null if the document does not exist.
    });
  }
}
