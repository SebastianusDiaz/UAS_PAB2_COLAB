class Venue {
  final String id;
  final String name;
  final String address;
  final String whatsappNumber;
  final String image;
  final String description;
  final List<String> facilities;
  final double rating;
  final String openHours;
  final String category;
  final double latitude;
  final double longitude;
  final List<Map<String, dynamic>> reviews;
  final List<Field> fields;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.whatsappNumber,
    required this.image,
    required this.description,
    required this.facilities,
    required this.rating,
    required this.openHours,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.reviews,8
    required this.fields,
  });

  // Konversi dari JSON ke objek Venue
  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      whatsappNumber: json['whatsappNumber'],
      image: json['image'],
      description: json['description'],
      facilities: List<String>.from(json['facilities']),
      rating: json['rating'].toDouble(),
      openHours: json['openHours'],
      category: json['category'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      reviews: List<Map<String, dynamic>>.from(json['reviews']),
      fields: (json['fields'] as List<dynamic>)
          .map((fieldJson) => Field.fromJson(fieldJson))
          .toList(),
    );
  }

  // Konversi dari objek Venue ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'whatsappNumber': whatsappNumber,
      'image': image,
      'description': description,
      'facilities': facilities,
      'rating': rating,
      'openHours': openHours,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'reviews': reviews,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }
}

class Field {
  final String name;
  final int morningPrice;
  final int afternoonPrice;

  Field({
    required this.name,
    required this.morningPrice,
    required this.afternoonPrice,
  });

  // Konversi dari JSON ke objek Field
  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      name: json['name'],
      morningPrice: json['morningPrice'],
      afternoonPrice: json['afternoonPrice'],
    );
  }

  // Konversi dari objek Field ke JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'morningPrice': morningPrice,
      'afternoonPrice': afternoonPrice,
    };
  }
}
