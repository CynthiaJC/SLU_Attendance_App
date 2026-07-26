import 'package:flutter/material.dart';
import 'intern_dashboard.dart';
import 'intern_report_page.dart';
import 'intern_profile_screen.dart';

class InternMainScreen extends StatefulWidget {
  const InternMainScreen({super.key});

  @override
  State<InternMainScreen> createState() => _InternMainScreenState();
}

class _InternMainScreenState extends State<InternMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    InternDashboard(),
    InternReportPage(),
    InternProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: const Color(0xFFE1E8FD), // matches _surfaceContainerHigh in report
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF004AC6)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment, color: Color(0xFF004AC6)),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF004AC6)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
