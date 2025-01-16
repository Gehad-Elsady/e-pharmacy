// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_pharmacy/Screens/add-services/model/service-model.dart';
import 'package:flutter/material.dart';

class ServicesItem extends StatelessWidget {
  ServiceModel service;
  Function? callBack;
  // String buttonTitle;
  ServicesItem({
    super.key,
    required this.service,
    this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBack!();
      },
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: service.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            Text(
              service.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                service.price.toString() + "  " + "pound",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
