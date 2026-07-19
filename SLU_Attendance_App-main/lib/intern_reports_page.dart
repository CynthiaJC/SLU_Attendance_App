import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InternReportsPage extends StatelessWidget {
  const InternReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Intern Reports"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards Row
            Row(
              children: [
                _buildSummaryCard("ATTENDANCE", "92%", Colors.blue),
                const SizedBox(width: 15),
                _buildSummaryCard("TOTAL SESSIONS", "45", Colors.grey),
              ],
            ),
            const SizedBox(height: 30),
            
            // Monthly Trend Section
            const Text("Monthly Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 85, color: Colors.blue)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 92, color: Colors.blue)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 88, color: Colors.blue)]),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Recent Exceptions Section
            const Text("Recent Exceptions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildExceptionItem("Team Sync", "Jan 15, 2024", "Absent", Colors.red),
            _buildExceptionItem("General Meeting", "Jan 10, 2024", "Late", Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildExceptionItem(String title, String date, String status, Color statusColor) {
    return ListTile(
      title: Text(title),
      subtitle: Text(date),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
        child: Text(status, style: TextStyle(color: statusColor)),
      ),
    );
  }
}