import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/AddProductModel/add_photographer_model.dart';
import '../Model/AddProductModel/add_product_model.dart';

class FirebaseAddProductServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<DocumentReference> saveProduct(AddProductModel product) {
    return FirebaseFirestore.instance
        .collection('DesignerProducts')
        .add(product.toMap());
  }
  Future<List<AddProductModel>> fetchProducts() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await _db
        .collection('DesignerProducts')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => AddProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }
  Future<AddPhotographerModel?> fetchPhotographer(String productId) async {
    try {
      final photographerSnapshot = await _db
          .collection('DesignerProducts')
          .doc(productId)
          .collection('photographers')
          .get();

      if (photographerSnapshot.docs.isNotEmpty) {
        return AddPhotographerModel.fromMap(
            photographerSnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error fetching photographer: $e');
      return null;
    }
  }


}
