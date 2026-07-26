import 'package:flutter/material.dart';
import '../models/attendance_models.dart';
import '../services/mock_api_service.dart';
import 'feedback_screen.dart';

// ---------------------------------------------------------------------------
// Colors (matches design system in intern_report_page.dart)
// ---------------------------------------------------------------------------
const _primary = Color(0xFF004AC6);
const _surface = Color(0xFFF9F9FF);

const _onSurface = Color(0xFF141B2B);
const _onSurfaceVariant = Color(0xFF434655);
const _outlineVariant = Color(0xFFC3C6D7);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class InternDashboard extends StatefulWidget {
  final String internId;
  const InternDashboard({super.key, required this.internId});

  @override
  State<InternDashboard> createState() => _InternDashboardState();
}

class _InternDashboardState extends State<InternDashboard>
    with SingleTickerProviderStateMixin {
  late Future<_DashboardData> _future;
  bool _isCheckedIn = false;
  String _checkInTime = '--:--';

  // Pulse animation for skeleton shimmer
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _shimmerAnim = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<_DashboardData> _loadData() async {
    final api = MockApiService();
    final intern = await api.getInternById(widget.internId);
    final records = await api.getAttendanceRecords(internId: widget.internId);
    // Take the 5 most recent records (assume chronological order)
    final recent = records.length > 5 ? records.sublist(records.length - 5) : records;
    return _DashboardData(intern: intern, recentRecords: recent.reversed.toList());
  }

  void _retry() => setState(() => _future = _loadData());

  Future<void> _toggleCheckIn(Intern? intern) async {
    final newCheckedInState = !_isCheckedIn;
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    if (newCheckedInState && intern != null) {
      // Add real record to MockApiService
      await MockApiService().addAttendanceRecord(
        internId: intern.id,
        internName: intern.name,
        meetingId: 'MTG-TODAY',
        meetingTitle: 'Daily Standup & Progress Sync',
        status: 'Present',
        checkInMethod: 'App Check-In',
        notes: 'Checked in via intern dashboard',
      );
    }

    if (mounted) {
      setState(() {
        _isCheckedIn = newCheckedInState;
        _checkInTime = timeString;
        _future = _loadData(); // refresh dashboard data to reflect new log/stats
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isCheckedIn
                ? 'Checked in successfully at $_checkInTime'
                : 'Checked out successfully',
          ),
          backgroundColor: _isCheckedIn ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar('Dashboard'),
      body: FutureBuilder<_DashboardData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeleton();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return _buildError();
          }
          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: _outlineVariant,
      title: Text(
        'Excelerate Global',
        style: const TextStyle(
          color: _primary,
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
      ],
    );
  }

  // ── Loading skeleton ───────────────────────────────────────────────────────

  Widget _buildSkeleton() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, _) {
        final alpha = (_shimmerAnim.value * 255).round();
        final shimmerColor = Color.fromARGB(alpha, 200, 210, 230);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _skeletonBox(width: double.infinity, height: 100, color: shimmerColor),
              const SizedBox(height: 16),
              _skeletonBox(width: double.infinity, height: 70, color: shimmerColor),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _skeletonBox(height: 80, color: shimmerColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _skeletonBox(height: 80, color: shimmerColor)),
                ],
              ),
              const SizedBox(height: 16),
              _skeletonBox(width: double.infinity, height: 120, color: shimmerColor),
              const SizedBox(height: 16),
              _skeletonBox(width: double.infinity, height: 60, color: shimmerColor),
              const SizedBox(height: 8),
              _skeletonBox(width: double.infinity, height: 60, color: shimmerColor),
            ],
          ),
        );
      },
    );
  }

  Widget _skeletonBox({double? width, required double height, required Color color}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 64, color: _onSurfaceVariant),
            const SizedBox(height: 16),
            const Text(
              'Could not load dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _onSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'There was a problem fetching your data.\nPlease try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Loaded content ─────────────────────────────────────────────────────────

  Widget _buildContent(_DashboardData data) {
    final intern = data.intern;
    final firstName = intern != null ? intern.name.split(' ').first : 'Intern';
    final attendanceRate = intern != null
        ? (intern.participationRate * 100).round()
        : 0;
    final presentCount = intern?.presentCount ?? 0;
    final totalSessions = intern?.totalSessions ?? 0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Card
            _buildWelcomeCard(firstName),
            const SizedBox(height: 20),

            // 2. Attendance Action Card
            _buildCheckInCard(intern),
            const SizedBox(height: 20),

            // 3. Feedback Button
            _buildFeedbackButton(context),
            const SizedBox(height: 20),

            // 4. Quick Stats Grid
            Row(
              children: [
                _buildStatCard(
                  'Attendance Rate',
                  '$attendanceRate%',
                  Icons.verified_outlined,
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Sessions Attended',
                  '$presentCount / $totalSessions',
                  Icons.event_available_outlined,
                  _primary,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 5. Recent Activity Log
            const Text(
              'Recent Log History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _onSurface,
              ),
            ),
            const SizedBox(height: 12),

            if (data.recentRecords.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No attendance records yet.',
                  style: TextStyle(color: _onSurfaceVariant),
                ),
              )
            else
              ...data.recentRecords.map((r) => _buildActivityTile(r)),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Welcome card ──────────────────────────────────────────────────────────

  Widget _buildWelcomeCard(String firstName) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $firstName! 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep up the great work and track your progress daily.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ── Check-in card ─────────────────────────────────────────────────────────

  Widget _buildCheckInCard(Intern? intern) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Attendance",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  _isCheckedIn
                      ? 'Status: Checked In at $_checkInTime'
                      : 'Status: Not Checked In',
                  style: TextStyle(
                    color: _isCheckedIn ? Colors.green : Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _toggleCheckIn(intern),
              icon: Icon(_isCheckedIn ? Icons.logout : Icons.login),
              label: Text(_isCheckedIn ? 'Check Out' : 'Check In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCheckedIn ? Colors.deepOrange : _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Feedback button ────────────────────────────────────────────────────────

  Widget _buildFeedbackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.feedback_outlined),
        label: const Text(
          'Submit Feedback',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ── Stat card ─────────────────────────────────────────────────────────────

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: _onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ── Activity tile (real record) ────────────────────────────────────────────

  Widget _buildActivityTile(AttendanceRecord record) {
    final isPresent = record.status == 'Present';
    final isLate = record.status == 'Late';
    final iconData = isPresent
        ? Icons.arrow_downward
        : isLate
            ? Icons.schedule_outlined
            : Icons.event_busy_outlined;
    final iconColor = isPresent
        ? Colors.green
        : isLate
            ? Colors.orange
            : Colors.red;

    // Format date nicely: "2026-07-06" → "Jul 06, 2026"
    String formattedDate = record.date;
    try {
      final parts = record.date.split('-');
      if (parts.length == 3) {
        const months = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        final m = int.parse(parts[1]);
        formattedDate = '${months[m]} ${parts[2]}, ${parts[0]}';
      }
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _outlineVariant),
      ),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withValues(alpha: 0.12),
          child: Icon(iconData, size: 17, color: iconColor),
        ),
        title: Text(
          record.meetingTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: Text(
          '$formattedDate  •  ${record.timeIn}',
          style: const TextStyle(fontSize: 11, color: _onSurfaceVariant),
        ),
        trailing: _StatusBadge(status: record.status),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal data holder
// ---------------------------------------------------------------------------

class _DashboardData {
  final Intern? intern;
  final List<AttendanceRecord> recentRecords;
  const _DashboardData({required this.intern, required this.recentRecords});
}

// ---------------------------------------------------------------------------
// Small status badge widget
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'Present':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
        break;
      case 'Late':
        bg = const Color(0xFFFEF9C3);
        fg = const Color(0xFF854D0E);
        break;
      default: // Absent
        bg = const Color(0xFFFFE4E6);
        fg = const Color(0xFF9F1239);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
