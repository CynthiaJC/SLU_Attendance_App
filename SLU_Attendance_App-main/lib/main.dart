import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'intern_reports_provider.dart';
import 'intern_reports_page.dart'; // Add this import!

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => InternReportsProvider(),
      child: const MaterialApp(
        home: InternReportsPage(), // Point here
      ),
    ),
  );
}