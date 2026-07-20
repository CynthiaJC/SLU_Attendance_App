import 'package:flutter/material.dart';

import 'coordinator_profile_screen.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

enum AttendanceStatus { onTrack, needsReview, atRisk }

class InternRecord {
  final String name;
  final String initials;
  final int presentCount;
  final int absentCount;
  final int totalSessions;
  final AttendanceStatus status;
  final String department;

  const InternRecord({
    required this.name,
    required this.initials,
    required this.presentCount,
    required this.absentCount,
    required this.totalSessions,
    required this.status,
    required this.department,
  });

  double get participationRate =>
      totalSessions == 0 ? 0 : (presentCount / totalSessions).clamp(0.0, 1.0);

  String get participationLabel => '${(participationRate * 100).round()}%';
}

// ---------------------------------------------------------------------------
// Sample data
// ---------------------------------------------------------------------------

const List<InternRecord> _allInterns = [
  InternRecord(
    name: 'Sarah Jenkins',
    initials: 'SJ',
    presentCount: 42,
    absentCount: 3,
    totalSessions: 45,
    status: AttendanceStatus.onTrack,
    department: 'Engineering',
  ),
  InternRecord(
    name: 'Michael Chen',
    initials: 'MC',
    presentCount: 38,
    absentCount: 7,
    totalSessions: 45,
    status: AttendanceStatus.needsReview,
    department: 'Design',
  ),
  InternRecord(
    name: 'David Miller',
    initials: 'DM',
    presentCount: 45,
    absentCount: 0,
    totalSessions: 45,
    status: AttendanceStatus.onTrack,
    department: 'Engineering',
  ),
  InternRecord(
    name: 'Elena Rodriguez',
    initials: 'ER',
    presentCount: 35,
    absentCount: 10,
    totalSessions: 45,
    status: AttendanceStatus.atRisk,
    department: 'Marketing',
  ),
  InternRecord(
    name: 'James Liu',
    initials: 'JL',
    presentCount: 40,
    absentCount: 5,
    totalSessions: 45,
    status: AttendanceStatus.onTrack,
    department: 'Marketing',
  ),
  InternRecord(
    name: 'Aisha Patel',
    initials: 'AP',
    presentCount: 30,
    absentCount: 15,
    totalSessions: 45,
    status: AttendanceStatus.atRisk,
    department: 'Design',
  ),
];

const _monthlyTrend = [
  (month: 'Sep', value: 0.82),
  (month: 'Oct', value: 0.85),
  (month: 'Nov', value: 0.88),
  (month: 'Dec', value: 0.92),
];

const _departments = ['All', 'Engineering', 'Design', 'Marketing'];

// ---------------------------------------------------------------------------
// Theme constants (matching the HTML inspo color palette)
// ---------------------------------------------------------------------------

const _primaryColor = Color(0xFF004AC6);
const _surfaceColor = Color(0xFFF9F9FF);
const _surfaceContainerLowest = Color(0xFFFFFFFF);
const _surfaceContainerLow = Color(0xFFF1F3FF);
const _surfaceContainer = Color(0xFFE9EDFF);
const _surfaceContainerHigh = Color(0xFFE1E8FD);
const _onSurface = Color(0xFF141B2B);
const _onSurfaceVariant = Color(0xFF434655);
const _outlineVariant = Color(0xFFC3C6D7);

Color _statusBg(AttendanceStatus s) {
  switch (s) {
    case AttendanceStatus.onTrack:
      return const Color(0xFFDCFCE7);
    case AttendanceStatus.needsReview:
      return const Color(0xFFFEF9C3);
    case AttendanceStatus.atRisk:
      return const Color(0xFFFEE2E2);
  }
}

Color _statusFg(AttendanceStatus s) {
  switch (s) {
    case AttendanceStatus.onTrack:
      return const Color(0xFF166534);
    case AttendanceStatus.needsReview:
      return const Color(0xFF854D0E);
    case AttendanceStatus.atRisk:
      return const Color(0xFF991B1B);
  }
}

String _statusLabel(AttendanceStatus s) {
  switch (s) {
    case AttendanceStatus.onTrack:
      return 'On Track';
    case AttendanceStatus.needsReview:
      return 'Needs Review';
    case AttendanceStatus.atRisk:
      return 'At Risk';
  }
}

// ---------------------------------------------------------------------------
// Main screen
// ---------------------------------------------------------------------------

class CoordinatorScreenReport extends StatefulWidget {
  const CoordinatorScreenReport({super.key});

  @override
  State<CoordinatorScreenReport> createState() =>
      _CoordinatorScreenReportState();
}

class _CoordinatorScreenReportState extends State<CoordinatorScreenReport>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _selectedDept = 'All';
  String _searchQuery = '';
  int _bottomNavIndex = 1;
  late AnimationController _barAnimCtrl;
  late Animation<double> _barAnim;
  bool _showAllInterns = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _searchQuery = _searchController.text.toLowerCase()),
    );
    _barAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _barAnim =
        CurvedAnimation(parent: _barAnimCtrl, curve: Curves.easeOutCubic);
    _barAnimCtrl.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _barAnimCtrl.dispose();
    super.dispose();
  }

  // Filtered intern list
  List<InternRecord> get _filteredInterns {
    var list = _allInterns.where((i) {
      final dept = _selectedDept == 'All' || i.department == _selectedDept;
      final search =
          _searchQuery.isEmpty || i.name.toLowerCase().contains(_searchQuery);
      return dept && search;
    }).toList();
    return _showAllInterns ? list : list.take(4).toList();
  }

  List<InternRecord> get _allFiltered => _selectedDept == 'All'
      ? _allInterns
      : _allInterns.where((i) => i.department == _selectedDept).toList();

  // Aggregate stats
  String get _avgAttendance {
    if (_allInterns.isEmpty) return '0%';
    final avg = _allInterns.map((i) => i.participationRate).reduce((a, b) => a + b) /
        _allInterns.length;
    return '${(avg * 100).round()}%';
  }

  int get _totalSessions => _allInterns.isNotEmpty ? _allInterns.first.totalSessions : 0;
  int get _activeInterns => _allInterns.length;

  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surfaceColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: _outlineVariant,
      title: const Text(
        'Excelerate Global',
        style: TextStyle(
          color: _primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: -0.3,
        ),
      ),
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
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildPageHeader()),
        SliverToBoxAdapter(child: _buildFilterChips()),
        SliverToBoxAdapter(child: _buildStatsRow()),
        SliverToBoxAdapter(child: _buildTrendChart()),
        SliverToBoxAdapter(child: _buildAttendanceTable()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  // ── Page header + search ──────────────────────────────────────────────────

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Overview of intern participation and historical data.',
            style: TextStyle(fontSize: 14, color: _onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: _surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _outlineVariant),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14, color: _onSurface),
              decoration: const InputDecoration(
                hintText: 'Search interns...',
                hintStyle: TextStyle(fontSize: 14, color: _onSurfaceVariant),
                prefixIcon:
                    Icon(Icons.search, size: 20, color: _onSurfaceVariant),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Department filter chips ───────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _departments.length,
        separatorBuilder: (_, sep) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final dept = _departments[i];
          final selected = dept == _selectedDept;
          return ChoiceChip(
            label: Text(dept),
            selected: selected,
            onSelected: (_) => setState(() {
              _selectedDept = dept;
              _showAllInterns = false;
            }),
            selectedColor: _primaryColor,
            backgroundColor: _surfaceContainerHigh,
            labelStyle: TextStyle(
              color: selected ? Colors.white : _onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            shape: const StadiumBorder(),
            side: BorderSide.none,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          );
        },
      ),
    );
  }

  // ── Stats row ─────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    final stats = [
      _StatItem('Avg. Attendance', _avgAttendance, Icons.show_chart, _primaryColor),
      _StatItem('Total Sessions', '$_totalSessions', Icons.calendar_today_outlined, _onSurface),
      _StatItem('Active Interns', '$_activeInterns', Icons.people_outline, _onSurface),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: List.generate(stats.length, (i) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < stats.length - 1 ? 10 : 0),
              child: _StatCard(item: stats[i]),
            ),
          );
        }),
      ),
    );
  }

  // ── Animated bar chart ────────────────────────────────────────────────────

  Widget _buildTrendChart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Participation Trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _onSurface,
                  ),
                ),
                const Icon(Icons.more_vert, color: _onSurfaceVariant, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _barAnim,
              builder: (context, _) {
                return SizedBox(
                  height: 130,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _monthlyTrend.map((entry) {
                      final h = entry.value * _barAnim.value;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Opacity(
                                opacity: _barAnim.value,
                                child: Text(
                                  '${(entry.value * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6)),
                                child: Container(
                                  height: 100 * h,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF2563EB),
                                        Color(0xFF004AC6),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: _monthlyTrend
                  .map(
                    (e) => Expanded(
                      child: Text(
                        e.month,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Attendance history table ───────────────────────────────────────────────

  Widget _buildAttendanceTable() {
    final interns = _filteredInterns;
    final hasMore = _allFiltered.length > 4 && !_showAllInterns;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Container(
              color: _surfaceContainer,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Text(
                'Attendance History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _onSurface,
                ),
              ),
            ),
            // Column headers
            Container(
              color: _surfaceContainerLowest,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: _ColHeader('Intern Name')),
                  Expanded(
                      flex: 2,
                      child: _ColHeader('Present', align: TextAlign.center)),
                  Expanded(
                      flex: 2,
                      child: _ColHeader('Status', align: TextAlign.center)),
                  Expanded(
                      flex: 2,
                      child: _ColHeader('Absent', align: TextAlign.center)),
                  Expanded(
                      flex: 2,
                      child: _ColHeader('Rate', align: TextAlign.center)),
                ],
              ),
            ),
            const Divider(height: 1, color: _outlineVariant),
            // Rows
            if (interns.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No interns found.',
                    style: const TextStyle(
                        color: _onSurfaceVariant, fontSize: 14),
                  ),
                ),
              )
            else
              ...interns.map((intern) => _InternRow(intern: intern)),
            // Footer button
            const Divider(height: 1, color: _outlineVariant),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () =>
                    setState(() => _showAllInterns = !_showAllInterns),
                style: TextButton.styleFrom(
                  foregroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                ),
                child: Text(
                  hasMore
                      ? 'View All Interns'
                      : (_showAllInterns ? 'Show Less' : 'View All Interns'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// ---------------------------------------------------------------------------
// Stat card
// ---------------------------------------------------------------------------

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const _StatItem(this.label, this.value, this.icon, this.valueColor);
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
            decoration: const BoxDecoration(
              color: _surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 17, color: _primaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            item.value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: item.valueColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: _onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Column header
// ---------------------------------------------------------------------------

class _ColHeader extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _ColHeader(this.text, {this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: align,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: _onSurfaceVariant,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Intern table row
// ---------------------------------------------------------------------------

class _InternRow extends StatelessWidget {
  final InternRecord intern;
  const _InternRow({required this.intern});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: _surfaceContainerLow,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _AvatarWidget(initials: intern.initials),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      intern.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${intern.presentCount}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: _onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(child: _StatusBadge(status: intern.status)),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${intern.absentCount}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: _onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                intern.participationLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _statusFg(intern.status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar with deterministic color from initials
// ---------------------------------------------------------------------------

class _AvatarWidget extends StatelessWidget {
  final String initials;
  const _AvatarWidget({required this.initials});

  Color get _bgColor {
    final hash = initials.codeUnits.fold(0, (a, b) => a + b);
    final hue = (hash * 47) % 360;
    return HSLColor.fromAHSL(1, hue.toDouble(), 0.45, 0.82).toColor();
  }

  Color get _fgColor {
    final hash = initials.codeUnits.fold(0, (a, b) => a + b);
    final hue = (hash * 47) % 360;
    return HSLColor.fromAHSL(1, hue.toDouble(), 0.55, 0.28).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: _outlineVariant),
      ),
      child: Center(
        child: Text(
          initials.length >= 2 ? initials.substring(0, 2) : initials,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _fgColor,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final AttendanceStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: _statusBg(status),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: _statusFg(status),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
