import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save role (student or mentor) for the user by email
  Future<void> saveUserRole(String email, String role) async {
    await _db.collection('users').doc(email).set({
      'role': role,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // merge prevents overwriting if doc exists
  }

  /// Get user role from Firestore
  Future<String?> getUserRole(String email) async {
    final doc = await _db.collection('users').doc(email).get();
    if (doc.exists && doc.data()!.containsKey('role')) {
      return doc['role'];
    }
    return null;
  }

  Future<void> saveInteraction(String studentId, String mentorId) async {
    await _db.collection('interactions').add({
      'studentId': studentId,
      'mentorId': mentorId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
