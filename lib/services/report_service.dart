import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> reportMessage(String messageId, String reason) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('reports').add({
      'reporterId': uid,
      'messageId': messageId,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
