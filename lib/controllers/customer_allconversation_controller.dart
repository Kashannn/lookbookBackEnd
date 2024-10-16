import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/user/user_model.dart';

class CustomerAllConversationController extends GetxController {
  Stream<List<UserModel>> fetchDesignersForChat() async* {
    try {
      // Fetch the designer userIds from the products
      List<String> designerUserIds = await fetchDesignerUserIdsFromProducts();

      if (designerUserIds.isEmpty) {
        yield [];
        return;
      }
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'DESIGNER')
          .where(FieldPath.documentId, whereIn: designerUserIds)
          .snapshots() // Listen for real-time updates
          .map((snapshot) {
        // Convert the documents to UserModel and return as a list
        return snapshot.docs.map((doc) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error fetching designers: $e');
      yield [];
    }
  }

  Future<List<String>> fetchDesignerUserIdsFromProducts() async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the user's document reference
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Get the user's document snapshot
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Get the 'products' field from the user's document
      List<DocumentReference> productRefs =
          (userDocSnapshot.data() as Map<String, dynamic>)['products']
                  ?.cast<DocumentReference>() ??
              [];

      // List to store designer userIds
      List<String> designerUserIds = [];

      // Fetch each product document and extract the designer userId
      for (DocumentReference productRef in productRefs) {
        DocumentSnapshot productDoc = await productRef.get();
        String designerUserId = productDoc.get('userId')
            as String; // Assuming the 'userId' field exists
        designerUserIds.add(designerUserId);
      }

      return designerUserIds;
    } catch (e) {
      print('Error fetching designer userIds: $e');
      return [];
    }
  }
}
