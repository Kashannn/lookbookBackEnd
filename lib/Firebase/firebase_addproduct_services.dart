import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/AddProductModel/add_photographer_model.dart';
import '../Model/AddProductModel/add_product_model.dart';

class FirebaseAddProductServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<DocumentReference> saveProduct(AddProductModel product) {
    return FirebaseFirestore.instance
        .collection('DesignerProducts')
        .add(product.toMap());
  }

}
