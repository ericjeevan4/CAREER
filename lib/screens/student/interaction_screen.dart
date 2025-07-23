import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/video_call_page.dart';

class InteractionScreen extends StatefulWidget {
  final String mentorId;
  final String studentId;

  const InteractionScreen({
    super.key,
    required this.mentorId,
    required this.studentId,
  });

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  Map<String, dynamic>? mentorData;

  @override
  void initState() {
    super.initState();
    fetchMentorDetails();
  }

  Future<void> fetchMentorDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.mentorId)
          .get();
      if (doc.exists) {
        setState(() => mentorData = doc.data());
      } else {
        debugPrint("❌ Mentor not found.");
      }
    } catch (e) {
      debugPrint("🔥 Error fetching mentor: $e");
    }
  }

  Future<void> registerInteractionAndStartCall() async {
    await FirebaseFirestore.instance.collection('interactions').add({
      'mentorId': widget.mentorId,
      'studentId': widget.studentId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoCallPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mentorData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentor Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "👨‍🏫 ${mentorData!['name'] ?? 'Unknown'}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Expertise: ${mentorData!['expertise'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              "Click below to register this interaction and begin a video call.",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: registerInteractionAndStartCall,
                icon: const Icon(Icons.video_call),
                label: const Text("Start Video Call"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
