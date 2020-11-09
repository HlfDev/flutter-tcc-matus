import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matus_app/app/models/message.dart';

class MessageController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Message> allMessages = [];
}
