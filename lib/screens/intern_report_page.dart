import 'dart:math' as math;
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Color palette (matches HTML inspo)
// ---------------------------------------------------------------------------

const _primary = Color(0xFF004AC6);
const _surface = Color(0xFFF9F9FF);
const _surfaceLowest = Color(0xFFFFFFFF);
const _surfaceContainerLow = Color(0xFFF1F3FF);
const _surfaceContainer = Color(0xFFE9EDFF);
const _surfaceContainerHigh = Color(0xFFE1E8FD);
const _onSurface = Color(0xFF141B2B);
const _onSurfaceVariant = Color(0xFF434655);
const _outlineVariant = Color(0xFFC3C6D7);
const _errorContainer = Color(0xFFFFDAD6);
const _onErrorContainer = Color(0xFF93000A);

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

const _trendData = [
  (month: 'Oct', value: 0.85),
  (month: 'Nov', value: 0.90),
  (month: 'Dec', value: 1.00),
  (month: 'Jan', value: 0.80),
  (month: 'Feb', value: 0.95),
  (month: 'Mar', value: 0.92),
];

enum ExceptionType { absent, late }

class _Exception {
  final String session;
  final String dateTime;
  final ExceptionType type;
  final String? detail; // e.g. "15m" for late

  const _Exception({
    required this.session,
    required this.dateTime,
    required this.type,
    this.detail,
  });
}

const _exceptions = [
  _Exception(
    session: 'Team Sync',
    dateTime: 'Jan 15, 2024 • 10:00 AM',
    type: ExceptionType.absent,
  ),
  _Exception(
    session: 'General Meeting',
    dateTime: 'Jan 02, 2024 • 09:00 AM',
    type: ExceptionType.late,
    detail: '15m',
  ),
  _Exception(
    session: 'Workshop: Leadership',
    dateTime: 'Dec 20, 2023 • 02:00 PM',
    type: ExceptionType.late,
    detail: '8m',
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class InternReportPage extends StatefulWidget {
  const InternReportPage({super.key});

  @override
  State<InternReportPage> createState() => _InternReportPageState();
}

class _InternReportPageState extends State<InternReportPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _anim;
  int _bottomNavIndex = 1; // Reports active

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _surfaceLowest,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: _outlineVariant,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 18,
            backgroundColor: _surfaceContainerHigh,
            child: const Text(
              'IN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _primary,
              ),
            ),
          ),
        ),
      ),
      title: const Text(
        'Excelerate Global',
        style: TextStyle(
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

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildPageTitle()),
        SliverToBoxAdapter(child: _buildSummaryCards()),
        SliverToBoxAdapter(child: _buildTrendChart()),
        SliverToBoxAdapter(child: _buildExceptionsList()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  // ── Page title ────────────────────────────────────────────────────────────

  Widget _buildPageTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'My Reports',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _onSurface,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Overview of your attendance and activity.',
            style: TextStyle(fontSize: 14, color: _onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ── Summary stat cards ────────────────────────────────────────────────────

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(child: _buildAttendanceCard()),
          const SizedBox(width: 12),
          Expanded(child: _buildSessionsCard()),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle_outline, color: _primary, size: 18),
              SizedBox(width: 6),
              Text(
                'ATTENDANCE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CustomPaint(
                      painter: _RingPainter(progress: 0.92 * _anim.value),
                    ),
                  ),
                  Text(
                    '${(92 * _anim.value).round()}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _primary,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            '+2% from last month',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsCard() {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.event_available_outlined, color: _primary, size: 18),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'SESSIONS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              return Text(
                '${(45 * _anim.value).round()}',
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: _onSurface,
                  letterSpacing: -1,
                  height: 1,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'This Quarter',
            style: TextStyle(fontSize: 12, color: _onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          // Mini progress bar: 45/52 sessions completed
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, _) {
                return LinearProgressIndicator(
                  value: (45 / 52) * _anim.value,
                  minHeight: 6,
                  backgroundColor: _surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation<Color>(_primary),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '45 of 52 sessions',
            style: TextStyle(fontSize: 10, color: _onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ── Monthly trend bar chart ────────────────────────────────────────────────

  Widget _buildTrendChart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: _CardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Last 6 Months',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _anim,
              builder: (context, _) {
                return SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _trendData.map((entry) {
                      final h = entry.value * _anim.value;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Opacity(
                                opacity: _anim.value,
                                child: Text(
                                  '${(entry.value * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: _primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              // Background track
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: _surfaceContainerHigh,
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(5)),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(5)),
                                    child: Container(
                                      height: 90 * h,
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
              children: _trendData
                  .map(
                    (e) => Expanded(
                      child: Text(
                        e.month,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
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

  // ── Recent Exceptions list ─────────────────────────────────────────────────

  Widget _buildExceptionsList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceLowest,
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
            Container(
              color: _surfaceContainer,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Text(
                'Recent Exceptions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _onSurface,
                ),
              ),
            ),
            if (_exceptions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No exceptions — great attendance!',
                    style: TextStyle(color: _onSurfaceVariant, fontSize: 14),
                  ),
                ),
              )
            else
              ..._exceptions.map((ex) => _ExceptionTile(exception: ex)),
          ],
        ),
      ),
    );
  }

}

// ---------------------------------------------------------------------------
// Shared card shell
// ---------------------------------------------------------------------------

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceLowest,
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
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Circular ring painter for attendance %
// ---------------------------------------------------------------------------

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    const strokeWidth = 7.0;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _surfaceContainerHigh
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = _primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ---------------------------------------------------------------------------
// Exception tile
// ---------------------------------------------------------------------------

class _ExceptionTile extends StatelessWidget {
  final _Exception exception;
  const _ExceptionTile({required this.exception});

  bool get _isAbsent => exception.type == ExceptionType.absent;

  Color get _iconBg => _isAbsent ? _errorContainer : const Color(0xFFFEF9C3);
  Color get _iconFg => _isAbsent ? _onErrorContainer : const Color(0xFF854D0E);
  Color get _badgeBg => _isAbsent ? const Color(0xFFFEE2E2) : const Color(0xFFFEF9C3);
  Color get _badgeFg => _isAbsent ? const Color(0xFF991B1B) : const Color(0xFF854D0E);
  IconData get _icon => _isAbsent ? Icons.event_busy_outlined : Icons.schedule_outlined;
  String get _label =>
      _isAbsent ? 'Absent' : 'Late (${exception.detail ?? ''})';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _outlineVariant, width: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () {},
        splashColor: _surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, size: 20, color: _iconFg),
              ),
              const SizedBox(width: 14),
              // Session info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exception.session,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      exception.dateTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _badgeFg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}