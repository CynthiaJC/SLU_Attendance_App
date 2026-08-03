import 'package:flutter/material.dart';
import '../models/attendance_models.dart';
import '../services/mock_api_service.dart';
import 'meeting_details_screen.dart';

// ---------------------------------------------------------------------------
// Design Palette (consistent with reports & design system)
// ---------------------------------------------------------------------------
const _primaryColor = Color(0xFF004AC6);
const _surfaceColor = Color(0xFFF9F9FF);
const _surfaceContainerLowest = Color(0xFFFFFFFF);
const _surfaceContainerHigh = Color(0xFFE1E8FD);
const _onSurface = Color(0xFF141B2B);
const _onSurfaceVariant = Color(0xFF434655);
const _outlineVariant = Color(0xFFC3C6D7);

// ---------------------------------------------------------------------------
// Dashboard
// ---------------------------------------------------------------------------
class CoordinatorDashboard extends StatelessWidget {
  const CoordinatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _surfaceColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: _outlineVariant,
          title: const Text(
            "Excelerate Global",
            style: TextStyle(
              color: _primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: -0.3,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: _onSurfaceVariant),
              onPressed: () {},
              tooltip: 'Notifications',
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: _surfaceContainerHigh,
                child: const Text(
                  'CG',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: _primaryColor,
            labelColor: _primaryColor,
            unselectedLabelColor: _onSurfaceVariant,
            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: [
              Tab(text: "General Meetings"),
              Tab(text: "Team Syncs"),
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

// ---------------------------------------------------------------------------
// Tab 1: General Meetings Tab
// ---------------------------------------------------------------------------
class _GeneralDashboardData {
  final List<Meeting> meetings;
  final List<Intern> interns;
  final List<AttendanceRecord> records;
  _GeneralDashboardData({required this.meetings, required this.interns, required this.records});
}

class GeneralMeetingsTab extends StatefulWidget {
  const GeneralMeetingsTab({super.key});

  @override
  State<GeneralMeetingsTab> createState() => _GeneralMeetingsTabState();
}

class _GeneralMeetingsTabState extends State<GeneralMeetingsTab> {
  final MockApiService _apiService = MockApiService();
  late Future<_GeneralDashboardData> _future;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_GeneralDashboardData> _loadData() async {
    final meetings = await _apiService.getMeetings(type: 'General');
    final interns = await _apiService.getInterns();
    final records = await _apiService.getAttendanceRecords();
    return _GeneralDashboardData(meetings: meetings, interns: interns, records: records);
  }

  void _reload() {
    setState(() {
      _future = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GeneralDashboardData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _primaryColor));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                const Text("Failed to load dashboard data", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _reload, child: const Text("Retry")),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        
        final totalMeetings = data.meetings.length;
        
        var totalRate = 0.0;
        var completedCount = 0;
        for (final m in data.meetings) {
          if (m.status == 'Completed' && m.totalInvited > 0) {
            totalRate += m.presentCount / m.totalInvited;
            completedCount++;
          }
        }
        final avgAttendance = completedCount > 0 ? (totalRate / completedCount * 100).round() : 0;
        
        final now = DateTime.now();
        final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        
        final todayRecords = data.records.where((r) => r.date == dateStr).toList();
        final checkedInCount = todayRecords.map((r) => r.internId).toSet().length;
        final totalInterns = data.interns.length;
        
        var filteredMeetings = data.meetings;
        if (_searchQuery.trim().isNotEmpty) {
          filteredMeetings = data.meetings.where((m) => 
            m.title.toLowerCase().contains(_searchQuery.trim().toLowerCase())
          ).toList();
        }

        return RefreshIndicator(
          onRefresh: () async {
            _reload();
          },
          color: _primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: "General Mtgs",
                        value: "$totalMeetings",
                        icon: Icons.meeting_room,
                        iconColor: _primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: "Avg Attendance",
                        value: "$avgAttendance%",
                        icon: Icons.show_chart,
                        iconColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: "Today Active",
                        value: "$checkedInCount / $totalInterns",
                        icon: Icons.how_to_reg,
                        iconColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  "Today's Intern Roll-Call",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Real-time attendance logs for today.",
                  style: TextStyle(fontSize: 12, color: _onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                
                if (data.interns.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No interns found.")),
                  )
                else
                  ...data.interns.map((intern) {
                    final todayRecord = todayRecords.firstWhere(
                      (r) => r.internId == intern.id,
                      orElse: () => const AttendanceRecord(
                        id: '', internId: '', internName: '', meetingId: '',
                        meetingTitle: '', date: '', timeIn: '', timeOut: '',
                        status: '', checkInMethod: '', notes: ''
                      ),
                    );
                    return _InternRollCallTile(
                      intern: intern,
                      todayRecord: todayRecord.id.isNotEmpty ? todayRecord : null,
                    );
                  }),
                
                const SizedBox(height: 24),
                
                const Text(
                  "General Meetings History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search general meetings...",
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _primaryColor, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                if (filteredMeetings.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text("No meetings found.")),
                  )
                else
                  ...filteredMeetings.map((meeting) => _MeetingTile(meeting: meeting)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2: Team Meetings Tab
// ---------------------------------------------------------------------------
class _TeamDashboardData {
  final List<Meeting> meetings;
  final List<Intern> interns;
  _TeamDashboardData({required this.meetings, required this.interns});
}

class TeamMeetingsTab extends StatefulWidget {
  const TeamMeetingsTab({super.key});

  @override
  State<TeamMeetingsTab> createState() => _TeamMeetingsTabState();
}

class _TeamMeetingsTabState extends State<TeamMeetingsTab> {
  final MockApiService _apiService = MockApiService();
  late Future<_TeamDashboardData> _future;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_TeamDashboardData> _loadData() async {
    final meetings = await _apiService.getMeetings(type: 'Team');
    final interns = await _apiService.getInterns();
    return _TeamDashboardData(meetings: meetings, interns: interns);
  }

  void _reload() {
    setState(() {
      _future = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TeamDashboardData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _primaryColor));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                const Text("Failed to load team data", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _reload, child: const Text("Retry")),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        
        final Map<String, List<Intern>> teamGroups = {};
        for (final i in data.interns) {
          teamGroups.putIfAbsent(i.department, () => []).add(i);
        }
        
        final totalTeams = teamGroups.keys.length;
        
        var totalRateSum = 0.0;
        for (final teamInterns in teamGroups.values) {
          final teamRate = teamInterns.isEmpty 
              ? 0.0 
              : teamInterns.map((i) => i.participationRate).reduce((a, b) => a + b) / teamInterns.length;
          totalRateSum += teamRate;
        }
        final avgSyncRate = totalTeams > 0 ? (totalRateSum / totalTeams * 100).round() : 0;
        final totalTeamMeetings = data.meetings.length;

        var filteredMeetings = data.meetings;
        if (_searchQuery.trim().isNotEmpty) {
          filteredMeetings = data.meetings.where((m) => 
            m.title.toLowerCase().contains(_searchQuery.trim().toLowerCase()) ||
            m.department.toLowerCase().contains(_searchQuery.trim().toLowerCase())
          ).toList();
        }

        return RefreshIndicator(
          onRefresh: () async {
            _reload();
          },
          color: _primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: "Active Teams",
                        value: "$totalTeams",
                        icon: Icons.groups_3,
                        iconColor: _primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: "Avg Sync Rate",
                        value: "$avgSyncRate%",
                        icon: Icons.sync,
                        iconColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: "Team Syncs",
                        value: "$totalTeamMeetings",
                        icon: Icons.calendar_month,
                        iconColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                const Text(
                  "Team Attendance Breakdown",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                
                if (teamGroups.isEmpty)
                  const Center(child: Text("No teams found."))
                else
                  ...teamGroups.entries.map((entry) {
                    final dept = entry.key;
                    final interns = entry.value;
                    final rate = interns.isEmpty 
                        ? 0.0 
                        : interns.map((i) => i.participationRate).reduce((a, b) => a + b) / interns.length;
                    final ratePercent = (rate * 100).round();
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$dept Team",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _onSurface),
                              ),
                              Text(
                                "$ratePercent%",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800, 
                                  fontSize: 14, 
                                  color: ratePercent >= 80 ? const Color(0xFF166534) : const Color(0xFF991B1B)
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${interns.length} Intern${interns.length != 1 ? 's' : ''}",
                            style: const TextStyle(fontSize: 12, color: _onSurfaceVariant),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: rate,
                              minHeight: 6,
                              backgroundColor: _surfaceContainerHigh,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ratePercent >= 80 ? Colors.green : Colors.orange
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                
                const SizedBox(height: 24),
                
                const Text(
                  "Recent Team Sync Meetings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search team meetings...",
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _primaryColor, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                if (filteredMeetings.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text("No team meetings found.")),
                  )
                else
                  ...filteredMeetings.map((meeting) => _MeetingTile(meeting: meeting)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Common Shared Helper Widgets
// ---------------------------------------------------------------------------
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: _onSurfaceVariant,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InternRollCallTile extends StatelessWidget {
  final Intern intern;
  final AttendanceRecord? todayRecord;

  const _InternRollCallTile({required this.intern, required this.todayRecord});

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = todayRecord != null;
    final timeStr = isCheckedIn ? todayRecord!.timeIn : '--:--';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: _surfaceContainerHigh,
          child: Text(
            intern.avatarInitials,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: _primaryColor,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          intern.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: _onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${intern.role} • ${intern.department}',
              style: const TextStyle(fontSize: 11, color: _onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              isCheckedIn ? 'Checked in at $timeStr' : 'Not checked in yet',
              style: TextStyle(
                color: isCheckedIn ? Colors.green.shade700 : const Color(0xFF991B1B),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isCheckedIn ? const Color(0xFFDCFCE7) : const Color(0xFFFFE4E6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isCheckedIn ? 'Present' : 'Absent',
            style: TextStyle(
              color: isCheckedIn ? const Color(0xFF166534) : const Color(0xFF9F1239),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class _MeetingTile extends StatelessWidget {
  final Meeting meeting;
  const _MeetingTile({required this.meeting});

  @override
  Widget build(BuildContext context) {
    final hasAttendance = meeting.totalInvited > 0;
    final ratePercent = hasAttendance 
        ? ((meeting.presentCount / meeting.totalInvited) * 100).round() 
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outlineVariant),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeetingDetailsScreen(
                title: meeting.title,
                date: meeting.date,
                time: '${meeting.startTime} - ${meeting.endTime}',
                location: meeting.location,
                description: meeting.description,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      meeting.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(status: meeting.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: _onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    meeting.date,
                    style: const TextStyle(fontSize: 12, color: _onSurfaceVariant, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.access_time, size: 14, color: _onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    meeting.startTime,
                    style: const TextStyle(fontSize: 12, color: _onSurfaceVariant, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: _onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      meeting.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: _onSurfaceVariant, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: _outlineVariant),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meeting.type == 'General' ? 'Coordinator: ${meeting.coordinator}' : 'Team: ${meeting.department}',
                    style: const TextStyle(fontSize: 12, color: _onSurfaceVariant, fontWeight: FontWeight.w600),
                  ),
                  if (meeting.status == 'Completed' && hasAttendance)
                    Text(
                      'Attendance: $ratePercent%',
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.w700, 
                        color: ratePercent >= 80 ? const Color(0xFF166534) : const Color(0xFF991B1B)
                      ),
                    )
                  else if (meeting.status == 'Completed')
                    const Text(
                      'Attendance: --',
                      style: TextStyle(fontSize: 12, color: _onSurfaceVariant),
                    )
                  else
                    Text(
                      'Invited: ${meeting.totalInvited}',
                      style: const TextStyle(fontSize: 12, color: _primaryColor, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status.toLowerCase()) {
      case 'completed':
      case 'present':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
        break;
      case 'scheduled':
      case 'late':
        bg = const Color(0xFFFEF9C3);
        fg = const Color(0xFF854D0E);
        break;
      default: // Absent, Cancelled, etc.
        bg = const Color(0xFFFFE4E6);
        fg = const Color(0xFF9F1239);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}