import 'package:e_pharmacy/Screens/add-services/model/service-model.dart';
import 'package:e_pharmacy/Screens/cart/model/cart-model.dart';
import 'package:e_pharmacy/location/model/locationmodel.dart';

class HistoryModel {
  String? id;
  List<CartModel>? items;
  String? userId;
  LocationModel? locationModel;
  int? timestamp;
  String? governorate;
  String? city;
  String? paymentMethod;
  int? totalPrice;
  String? orderStatus;
  String? phoneNumber;

  HistoryModel({
    this.id,
    this.items,
    this.userId,
    this.locationModel,
    this.timestamp,
    this.governorate,
    this.city,
    this.paymentMethod,
    this.totalPrice,
    this.orderStatus,
    this.phoneNumber,
  });

  // Named constructor for deserialization
  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    items = (json['items'] as List<dynamic>?)
        ?.map((item) => CartModel.fromMap(item))
        .toList();
    userId = json['userId'] as String?;

    locationModel = json['locationModel'] != null
        ? LocationModel.fromMap(json['locationModel'])
        : null;
    timestamp = json['timestamp'];
    governorate = json['governorate'];
    city = json['city'];
    paymentMethod = json['paymentMethod'];
    totalPrice = json['totalPrice'];
    orderStatus = json['orderStatus'];
    phoneNumber = json['phoneNumber'];
  }

  // Method for serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['items'] = items?.map((item) => item.toMap()).toList();
    data['userId'] = userId;
    data['locationModel'] = locationModel?.toMap();
    data['timestamp'] = timestamp;
    data['governorate'] = governorate;
    data['city'] = city;
    data['paymentMethod'] = paymentMethod;
    data['totalPrice'] = totalPrice;
    data['orderStatus'] = orderStatus;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
