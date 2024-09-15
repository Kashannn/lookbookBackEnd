class AddPhotographerModel {
  String? name;
  String? image;
  String? email;
  String? phone;
  final List<Map<String, String?>> socialLinks;

  AddPhotographerModel({
    this.name,
    this.image,
    this.email,
    this.phone,
    required this.socialLinks,
  });

  factory AddPhotographerModel.fromMap(Map<String, dynamic> map) {
    return AddPhotographerModel(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      socialLinks: List<Map<String, String?>>.from(
        map['socialLinks']?.map((item) => Map<String, String?>.from(item)) ??
            [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'email': email,
      'phone': phone,
      'socialLinks': socialLinks,
    };
  }
}