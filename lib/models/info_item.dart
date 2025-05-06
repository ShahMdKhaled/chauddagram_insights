class InfoItem {
  final String id;
  final String name;
  final String? picture;
  final String? imageUrl;
  final String? bloodType;
  final String? description;
  final String phoneNumber;
  final String? googleMapLocation;
  final DateTime? createdAt;

  InfoItem({
    required this.id,
    required this.name,
    this.picture,
    this.imageUrl,
    this.bloodType,
    this.description,
    this.googleMapLocation,
    required this.phoneNumber,
    this.createdAt,
  });

  factory InfoItem.fromJson(Map<String, dynamic> json, String tableName) {
    String? rawPic = json['picture'];
    String? pictureUrl = rawPic != null && !rawPic.startsWith('http')
        ? 'https://subturk.xyz/backend-dashboard/images/$rawPic'
        : rawPic;

    return InfoItem(
      id: json['id'],
      name: json['name'] ?? json['driver_name'] ?? 'Unknown',
      picture: pictureUrl,
      imageUrl: pictureUrl,
      bloodType: json['blood_type'],
      description: json['description'] ?? json['details'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      googleMapLocation: json['google_map_location'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap(String tableName) {
    return {
      'id': id,
      'name': name,
      'picture': picture,
      'imageUrl': imageUrl,
      'bloodType': bloodType,
      'description': description,
      'phoneNumber': phoneNumber,
      'googleMapLocation': googleMapLocation,
      'createdAt': createdAt?.toIso8601String(),
      'tableName': tableName,
    };
  }

  factory InfoItem.fromMap(Map<String, dynamic> map) {
    return InfoItem(
      id: map['id'],
      name: map['name'],
      picture: map['picture'],
      imageUrl: map['imageUrl'],
      bloodType: map['bloodType'],
      description: map['description'],
      phoneNumber: map['phoneNumber'],
      googleMapLocation: map['googleMapLocation'],
      createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
    );
  }
}
