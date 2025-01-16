import 'package:e_pharmacy/Screens/history/model/historymaodel.dart';

class PharmacyOrderMaodel {
  HistoryModel order;
  String pharmacyName;
  String pharmacyId;

  PharmacyOrderMaodel(
      {required this.order,
      required this.pharmacyName,
      required this.pharmacyId});

  factory PharmacyOrderMaodel.fromJson(Map<String, dynamic> json) {
    return PharmacyOrderMaodel(
      order: HistoryModel.fromJson(json['order']),
      pharmacyName: json['pharmacyName'],
      pharmacyId: json['pharmacyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order.toJson(),
      'pharmacyName': pharmacyName,
      'pharmacyId': pharmacyId,
    };
  }
}
