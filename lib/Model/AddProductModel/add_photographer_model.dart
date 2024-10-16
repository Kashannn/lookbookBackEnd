class AddPhotographerModel {
  String? name;
  String? image;
  String? email;
  String? phone;
  String? about;
  final List<Map<String, String?>> socialLinks;

  AddPhotographerModel({
    this.name,
    this.image,
    this.email,
    this.phone,
    this.about,
    required this.socialLinks,
  });

  factory AddPhotographerModel.fromMap(Map<String, dynamic> map) {
    return AddPhotographerModel(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      about: map['about'] ?? '',
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
      'about': about,
      'socialLinks': socialLinks,
    };
  }
}