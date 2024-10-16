import 'package:cloud_firestore/cloud_firestore.dart';

import '../user/user_model.dart';

class ReportsModel {
  String? id;
  String? reportedBy;
  String? reported;
  String? messageId;
  String? chatroomId;
  String? reason;
  String? imageUrl;
  DateTime? date;
  UserModel? reportedByUser;

  ReportsModel({
    this.id,
    this.reportedBy,
    this.reported,
    this.messageId,
    this.chatroomId,
    this.reason,
    this.imageUrl,
    this.date,
    this.reportedByUser,
  });

  factory ReportsModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ReportsModel(
      id: documentId,
      reportedBy: map['reportedBy'] ?? '',
      reported: map['reported'] ?? '',
      messageId: map['messageId'] ?? '',
      chatroomId: map['chatroomId'] ?? '',
      reason: map['reason'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      date: map['date'] != null ? (map['date'] as Timestamp).toDate() : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'reportedBy': reportedBy,
      'reported': reported,
      'messageId': messageId,
      'chatroomId': chatroomId,
      'reason' : reason,
      'imageUrl' : imageUrl,
      'date': date != null ? Timestamp.fromDate(date!) : null,
    };
  }
}
