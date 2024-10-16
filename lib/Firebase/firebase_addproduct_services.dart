import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Model/AddProductModel/add_photographer_model.dart';
import '../Model/AddProductModel/add_product_model.dart';
import '../Model/user/user_model.dart';
import '../views/Designer/designer_main_screen.dart';
import '../views/Designer/home_screnn.dart';

class FirebaseAddProductServices {
  var isLoading = false.obs;



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

  Stream<List<AddProductModel>> fetchProductsStream() {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('DesignerProducts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AddProductModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<AddProductModel?> fetchSingleProduct(String productId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('DesignerProducts').doc(productId).get();
      if (doc.exists) {
        print("Product fetched");
        return AddProductModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print("Product not found");
        return null;
      }
    } catch (e) {
      print("Error fetching product: $e");
      return null;
    }
  }

  Future<UserModel?> fetchDesigner(String userId) async {
    try {
      final designerSnapshot = await _db.collection('users').doc(userId).get();
      if (designerSnapshot.exists) {
        return UserModel.fromMap(
            designerSnapshot.data() as Map<String, dynamic>);
      } else {
        print("Designer not found");
        return null;
      }
    } catch (e) {
      print("Error fetching product: $e");
      return null;
    }
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

  Future<void> deleteProduct(String productId) async {
    isLoading.value = true;
    try {
      CollectionReference photographerRef = FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .collection('photographers');
      QuerySnapshot photographersSnapshot = await photographerRef.get();
      for (QueryDocumentSnapshot doc in photographersSnapshot.docs) {
        await doc.reference.delete();
      }
      await FirebaseFirestore.instance
          .collection('DesignerProducts')
          .doc(productId)
          .delete();
      Get.snackbar(
          'Success', 'Product and its photographers deleted successfully!');
      Get.offAll(
        () => DesignerMainScreen(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product and photographers: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
