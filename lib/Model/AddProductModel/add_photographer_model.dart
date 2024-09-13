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
