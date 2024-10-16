import 'package:cloud_firestore/cloud_firestore.dart'; // For handling Firestore Timestamp

class MessageModel {
  String? id;
  String? text;
  String? sender;
  String? receiver;
  DateTime? sentOn;
  String? img;
  bool? isRead;
  bool? isReported;

  MessageModel(
      {this.id,
      this.text,
      this.sender,
      this.receiver,
      this.sentOn,
      this.img,
      this.isRead,
      this.isReported});

  // Factory constructor to create a MessageModel from Firestore data
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '', // Default to empty string if 'id' is null
      text: map['text'] ?? '', // Default to empty string if 'text' is null
      sender:
          map['sender'] ?? '', // Default to empty string if 'sender' is null
      receiver: map['receiver'] ?? '',
      sentOn: map['sentOn'] != null
          ? (map['sentOn'] as Timestamp).toDate()
          : null, // Convert Timestamp to DateTime if present
      img: map['img'] ?? '', // Default to empty string if 'img' is null
      isRead: map['isRead'] ?? false, // Default to false if 'isRead' is null
      isReported: map['isReported'] ?? false,
    );
  }

  // Convert MessageModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'receiver': receiver,
      'sentOn': sentOn != null
          ? Timestamp.fromDate(sentOn!)
          : null, // Convert DateTime to Firestore Timestamp, handle null
      'img': img,
      'isRead': isRead,
      'isReported': isReported
    };
  }
}
