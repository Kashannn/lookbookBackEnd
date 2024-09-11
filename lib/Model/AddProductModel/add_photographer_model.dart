class AddPhotographerModel {
  String? name;
  String? image;
  String? email;
  String? phone;
  List<String>? socialLinks;

  AddPhotographerModel({
    this.name,
    this.image,
    this.email,
    this.phone,
    this.socialLinks,
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
