import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> postAd({
    required String title,
    required String description,
    required int durationDays,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final adRef = _firestore.collection('ads').doc();
    final now = Timestamp.now();
    final expiration = Timestamp.fromDate(now.toDate().add(Duration(days: durationDays)));

    await adRef.set({
      'uid': uid,
      'title': title,
      'description': description,
      'startDate': now,
      'endDate': expiration,
      'active': true,
    });
  }

  Stream<QuerySnapshot> get activeAds {
    return _firestore
        .collection('ads')
        .where('endDate', isGreaterThan: Timestamp.now())
        .snapshots();
  }
}
