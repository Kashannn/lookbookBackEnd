import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/AddProductModel/add_photographer_model.dart';
import '../Model/AddProductModel/add_product_model.dart';

class FirebaseAddProductServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // Save photographer details as a subcollection within the product document
  Future<void> savePhotographer(String productId, AddPhotographerModel photographer) async {
    try {
      // Add photographer to the 'photographers' subcollection inside the product document
      await _db
          .collection('DesignerProducts')
          .doc(productId)  // Reference the specific product document
          .collection('photographers')  // Subcollection
          .add(photographer.toMap());

      print('Photographer saved successfully in subcollection');
    } catch (e) {
      print('Error saving photographer: $e');
      throw e;
    }
  }
  Future<String> saveProductAndGetId(AddProductModel product) async {
    try {
      // Save the product to Firestore and get the DocumentReference
      DocumentReference productRef = await _db.collection('DesignerProducts').add(product.toMap());

      // Return the generated product ID (Document ID)
      return productRef.id;
    } catch (e) {
      throw Exception('Error saving product and retrieving ID: $e');
    }
  }

  // Optionally, if you already have a saveProduct method, ensure it’s similar to this one
  Future<void> saveProduct(AddProductModel product) async {
    try {
      await _db.collection('DesignerProducts').add(product.toMap());
    } catch (e) {
      throw Exception('Error saving product: $e');
    }
  }
}
