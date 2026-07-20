import 'package:flutter/material.dart';

class CoordinatorDashboard extends StatelessWidget {
  const CoordinatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FB),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Coordinator Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 18),
              child: Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
            )
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "General Meetings"),
              Tab(text: "Team Meetings"),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            GeneralMeetingsTab(),
            TeamMeetingsTab(),
          ],
        ),
      ),
    );
  }
}

class GeneralMeetingsTab extends StatelessWidget {
  const GeneralMeetingsTab({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      padding: const EdgeInsets.all(16),

      child: Column(

        children: [

          Row(

            children: const [

              Expanded(
                child: StatCard(
                  title: "Interns",
                  value: "150",
                  icon: Icons.groups,
                  iconColor: Colors.blue,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: StatCard(
                  title: "Present",
                  value: "141",
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: StatCard(
                  title: "Absent",
                  value: "9",
                  icon: Icons.cancel,
                  iconColor: Colors.red,
                ),
              ),

            ],

          ),

          const SizedBox(height: 25),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Intern Roll-call",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            decoration: InputDecoration(
              hintText: "Search interns...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(

            children: [

              Expanded(
                child: DropdownButtonFormField<String>(

                  decoration: const InputDecoration(
                    labelText: "Department",
                    border: OutlineInputBorder(),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: "All",
                      child: Text("All"),
                    ),

                    DropdownMenuItem(
                      value: "Internship",
                      child: Text("Internship"),
                    ),

                    DropdownMenuItem(
                      value: "Course",
                      child: Text("Course"),
                    ),

                  ],

                  onChanged: (value) {},

                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: DropdownButtonFormField<String>(

                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: "All",
                      child: Text("All"),
                    ),

                    DropdownMenuItem(
                      value: "Present",
                      child: Text("Present"),
                    ),

                    DropdownMenuItem(
                      value: "Absent",
                      child: Text("Absent"),
                    ),

                  ],

                  onChanged: (value) {},

                ),
              ),

            ],

          ),

          const SizedBox(height: 20),

          const InternTile(
            name: "Sarah Jenkins",
            department: "Internship",
            present: true,
          ),

          const InternTile(
            name: "Ali Khan",
            department: "Course",
            present: false,
          ),

          const InternTile(
            name: "Emma Wilson",
            department: "Internship",
            present: true,
          ),

          const InternTile(
            name: "John David",
            department: "Internship",
            present: true,
          ),

          const InternTile(
            name: "Fatima Noor",
            department: "Course",
            present: false,
          ),

        ],

      ),

    );

  }

}
class TeamMeetingsTab extends StatelessWidget {
  const TeamMeetingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          Row(
            children: const [

              Expanded(
                child: StatCard(
                  title: "Teams",
                  value: "15",
                  icon: Icons.groups_2,
                  iconColor: Colors.indigo,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: StatCard(
                  title: "Avg Sync",
                  value: "94%",
                  icon: Icons.sync,
                  iconColor: Colors.green,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: StatCard(
                  title: "Meetings",
                  value: "18",
                  icon: Icons.calendar_today,
                  iconColor: Colors.orange,
                ),
              ),

            ],
          ),

          const SizedBox(height: 25),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Team Attendance",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            decoration: InputDecoration(
              hintText: "Search team...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          _teamCard(
            "Team 1",
            "10 / 10 Present",
            "100%",
            Colors.green,
          ),

          _teamCard(
            "Team 2",
            "9 / 10 Present",
            "90%",
            Colors.green,
          ),

          _teamCard(
            "Team 3",
            "10 / 10 Present",
            "100%",
            Colors.green,
          ),

          _teamCard(
            "Team 4",
            "8 / 10 Present",
            "80%",
            Colors.orange,
          ),

          _teamCard(
            "Team 5",
            "9 / 10 Present",
            "90%",
            Colors.green,
          ),

          _teamCard(
            "Team 6",
            "10 / 10 Present",
            "100%",
            Colors.green,
          ),

          _teamCard(
            "Team 7",
            "9 / 10 Present",
            "90%",
            Colors.green,
          ),

          _teamCard(
            "Team 8",
            "10 / 10 Present",
            "100%",
            Colors.green,
          ),

          _teamCard(
            "Team 9",
            "8 / 10 Present",
            "80%",
            Colors.orange,
          ),

          _teamCard(
            "Team 10",
            "9 / 10 Present",
            "90%",
            Colors.green,
          ),

          _teamCard(
            "Team 11",
            "10 / 10 Present",
            "100%",
            Colors.green,
          ),

          _teamCard(
            "Team 12",
            "9 / 10 Present",
            "90%",
            Colors.green,
          ),

          _teamCard(
            "Team 13",
            "10 / 10 Present",
            "100%",
            Colors.green,
          ),

          _teamCard(
            "Team 14",
            "8 / 10 Present",
            "80%",
            Colors.orange,
          ),

          _teamCard(
            "Team 15",
            "10 / 10 Present",
            "100%",
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _teamCard(
      String team,
      String attendance,
      String percentage,
      Color color,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(
            Icons.groups,
            color: Colors.blue,
          ),
        ),

        title: Text(
          team,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(attendance),

        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            percentage,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconColor.withValues(alpha: 0.15),
              child: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InternTile extends StatelessWidget {
  final String name;
  final String department;
  final bool present;

  const InternTile({
    super.key,
    required this.name,
    required this.department,
    required this.present,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e[0])
        .join();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            initials,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(department),
            const SizedBox(height: 4),
            Text(
              present ? "Checked In" : "Not Checked In",
              style: TextStyle(
                color: present ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),

        trailing: StatusChip(
          present: present,
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final bool present;

  const StatusChip({
    super.key,
    required this.present,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: present
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.red.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        present ? "Present" : "Absent",
        style: TextStyle(
          color: present ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
