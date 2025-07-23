import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'career_detail_screen.dart';

class CareerPortalScreen extends StatefulWidget {
  const CareerPortalScreen({super.key});

  @override
  State<CareerPortalScreen> createState() => _CareerPortalScreenState();
}

class _CareerPortalScreenState extends State<CareerPortalScreen> {
  Map<String, dynamic> careerData = {};

  @override
  void initState() {
    super.initState();
    loadCareerData();
  }

  Future<void> loadCareerData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/career_recommendations.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      careerData = jsonMap;
    });
  }

  void _navigateToDetail(String field, String category) {
    final items = List<String>.from(careerData[field]?[category] ?? []);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CareerDetailScreen(field: field, category: category, items: items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Career Recommendations")),
      body: careerData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: careerData.entries.map((entry) {
                final field = entry.key;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ExpansionTile(
                    title: Text(
                      field,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.work_outline),
                        title: const Text("Internships"),
                        onTap: () => _navigateToDetail(field, "internships"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.school_outlined),
                        title: const Text("Certifications"),
                        onTap: () => _navigateToDetail(field, "certifications"),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
