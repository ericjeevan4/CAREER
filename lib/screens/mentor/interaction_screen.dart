import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/video_call_page.dart';

class MentorInteractionScreen extends StatelessWidget {
  const MentorInteractionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMentorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Connected Students")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('interactions')
            .where('mentorId', isEqualTo: currentMentorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final studentId = docs[index]['studentId'];
              return ListTile(
                title: Text("Student ID: $studentId"),
                subtitle: const Text("Career Guidance"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat),
                      onPressed: () {
                        // TODO: implement chat
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.video_call),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VideoCallPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
