class ServiceModel {
  String name;
  String image;
  String description;
  String price;
  String userId;
  String type;

  ServiceModel({
    required this.name,
    required this.image,
    required this.description,
    required this.userId,
    required this.type,
    required this.price,
  });

  // Factory method to create a ServiceModel from Firestore JSON data
  factory ServiceModel.fromJson(Map<dynamic, dynamic> json) {
    return ServiceModel(
      name: json['name'] ?? '', // Default to empty string if null
      image: json['image'] ?? '', // Default to empty string if null
      description: json['description'] ??
          'No description available', // Default description if null
      price: json['price'] ?? '0.0', // Default price if null
      userId: json['userId'] ?? '', // Default to empty string if null
      type: json['type'] ?? 'Unknown', // Default type if null
    );
  }

  // Method to convert ServiceModel to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'description': description,
        'price': price,
        'userId': userId,
        'type': type,
      };
}
