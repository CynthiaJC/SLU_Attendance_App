import 'package:flutter/material.dart';
import '../screens/program_details_screen.dart';

class Program {
  final String title;
  final String startDate;
  final String shortDescription;

  Program({
    required this.title,
    required this.startDate,
    required this.shortDescription,
  });

  String get schedule => null;

  String get eligibility => null;
}

final List<Program> dummyPrograms = [
  Program(
    title: 'Flutter Development',
    startDate: '2024-01-15',
    shortDescription: 'Learn Flutter app development from basics to advanced',
  ),
  Program(
    title: 'Web Development',
    startDate: '2024-02-01',
    shortDescription: 'Master HTML, CSS, and JavaScript for web development',
  ),
];

class ProgramListingScreen extends StatelessWidget {
  const ProgramListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Programs'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyPrograms.length,
        itemBuilder: (context, index) {
          final program = dummyPrograms[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'Starts: ${program.startDate}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    program.shortDescription,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramDetailsScreen(program: program),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
