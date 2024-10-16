import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/user_model.dart';

class ProductReportedModel {
  final String? productName;
  final String productId;
  final String reason;
  final String reportedBy;
  final String reportedDesigner;
  final DateTime reportedAt;
  UserModel? reportedByUser;

  ProductReportedModel({
    this.productName,
    required this.productId,
    required this.reason,
    required this.reportedBy,
    required this.reportedDesigner,
    required this.reportedAt,
    this.reportedByUser,
  });

  factory ProductReportedModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductReportedModel(
      productId: map['productId'] ?? 'Unknown Product',
      reason: map['reason'] ?? 'No reason provided',
      reportedBy: map['reportedBy'] ?? 'Unknown User',
      reportedDesigner: map['reportedDesigner'] ?? 'Unknown User',
      reportedAt: (map['reportedAt'] as Timestamp).toDate(),


    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'reason': reason,
      'reportedBy': reportedBy,
      'reportedDesigner': reportedDesigner,
      'reportedAt': Timestamp.fromDate(reportedAt),
    };
  }

  void attachReportedByUser(UserModel user) {
    reportedByUser = user;
  }
}
