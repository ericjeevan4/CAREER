import 'package:flutter/material.dart';

class AiSuggestionScreen extends StatelessWidget {
  const AiSuggestionScreen({super.key});

  final suggestions = const [
    {
      'title': 'Data Scientist',
      'description': 'Work with big data, AI models, and predictive analytics.',
    },
    {
      'title': 'UX Designer',
      'description': 'Design user-friendly interfaces and improve usability.',
    },
    {
      'title': 'Mechanical Engineer',
      'description': 'Design and manufacture mechanical systems.',
    },
    {
      'title': 'Entrepreneur',
      'description': 'Start and grow your own business idea.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Career Suggestions")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.auto_awesome, color: Colors.deepPurple),
              title: Text(
                suggestion['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(suggestion['description']!),
            ),
          );
        },
      ),
    );
  }
}
