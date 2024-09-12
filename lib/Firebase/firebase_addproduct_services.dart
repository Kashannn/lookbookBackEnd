import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/AddProductModel/add_photographer_model.dart';
import '../Model/AddProductModel/add_product_model.dart';

class FirebaseAddProductServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> savePhotographer(String productId, AddPhotographerModel photographer) async {
    try {
      await _db
          .collection('DesignerProducts')
          .doc(productId)
          .collection('photographers')
          .add(photographer.toMap());

      print('Photographer saved successfully in subcollection');
    } catch (e) {
      print('Error saving photographer: $e');
      throw e;
    }
  }
  Future<String> saveProductAndGetId(AddProductModel product) async {
    try {
      DocumentReference productRef = await _db.collection('DesignerProducts').add(product.toMap());
      return productRef.id;
    } catch (e) {
      throw Exception('Error saving product and retrieving ID: $e');
    }
  }

  Future<void> saveProduct(AddProductModel product) async {
    try {
      await _db.collection('DesignerProducts').add(product.toMap());
    } catch (e) {
      throw Exception('Error saving product: $e');
    }
  }
}
