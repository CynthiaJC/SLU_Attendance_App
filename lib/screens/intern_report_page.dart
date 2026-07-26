import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/attendance_models.dart';
import '../services/mock_api_service.dart';

// ---------------------------------------------------------------------------
// Color palette
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
// Internal data holder
// ---------------------------------------------------------------------------

class _ReportData {
  final Intern? intern;
  final List<AttendanceRecord> exceptions; // Absent or Late records
  final List<({String month, double value})> trendData;

  const _ReportData({
    required this.intern,
    required this.exceptions,
    required this.trendData,
  });
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class InternReportPage extends StatefulWidget {
  final String internId;
  const InternReportPage({super.key, required this.internId});

  @override
  State<InternReportPage> createState() => _InternReportPageState();
}

class _InternReportPageState extends State<InternReportPage>
    with TickerProviderStateMixin {
  // Chart/ring animation
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  // Shimmer pulse
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  late Future<_ReportData> _future;
  bool _animCtrlInitialized = false;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _animCtrlInitialized = true;

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _shimmerAnim = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );

    _future = _loadData();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<_ReportData> _loadData() async {
    // Reset animation for re-loads (guard against call before init)
    if (_animCtrlInitialized) _animCtrl.reset();

    final api = MockApiService();
    final intern = await api.getInternById(widget.internId);
    final records = await api.getAttendanceRecords(internId: widget.internId);
    final trend = await api.getMonthlyTrend(widget.internId);

    final exceptions = records
        .where((r) => r.status == 'Absent' || r.status == 'Late')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // most recent first

    // Only animate if widget is still mounted
    if (mounted) _animCtrl.forward();

    return _ReportData(intern: intern, exceptions: exceptions, trendData: trend);
  }

  void _retry() => setState(() => _future = _loadData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: FutureBuilder<_ReportData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeleton();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return _buildError();
          }
          return _buildBody(snapshot.data!);
        },
      ),
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
              const SizedBox(height: 20),
              _skeletonBox(width: double.infinity, height: 28, color: shimmerColor),
              const SizedBox(height: 8),
              _skeletonBox(width: 220, height: 16, color: shimmerColor),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _skeletonBox(height: 130, color: shimmerColor)),
                  const SizedBox(width: 12),
                  Expanded(child: _skeletonBox(height: 130, color: shimmerColor)),
                ],
              ),
              const SizedBox(height: 16),
              _skeletonBox(width: double.infinity, height: 200, color: shimmerColor),
              const SizedBox(height: 16),
              _skeletonBox(width: double.infinity, height: 180, color: shimmerColor),
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
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
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
              'Could not load report',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: _onSurface),
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

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(_ReportData data) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildPageTitle()),
        SliverToBoxAdapter(child: _buildSummaryCards(data)),
        SliverToBoxAdapter(child: _buildTrendChart(data)),
        SliverToBoxAdapter(child: _buildExceptionsList(data)),
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

  Widget _buildSummaryCards(_ReportData data) {
    final intern = data.intern;
    final rate = intern?.participationRate ?? 0.0;
    final ratePercent = (rate * 100).round();
    final present = intern?.presentCount ?? 0;
    final total = intern?.totalSessions ?? 0;
    final lastMonthDiff = _computeLastMonthDiff(data.trendData);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(child: _buildAttendanceCard(rate, ratePercent, lastMonthDiff)),
          const SizedBox(width: 12),
          Expanded(child: _buildSessionsCard(present, total)),
        ],
      ),
    );
  }

  /// Returns the percentage-point delta vs the previous month, or null if unavailable.
  double? _computeLastMonthDiff(List<({String month, double value})> trend) {
    if (trend.length < 2) return null;
    return (trend.last.value - trend[trend.length - 2].value) * 100;
  }

  Widget _buildAttendanceCard(double rate, int ratePercent, double? lastMonthDiff) {
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
                      painter: _RingPainter(progress: rate * _anim.value),
                    ),
                  ),
                  Text(
                    '${(ratePercent * _anim.value).round()}%',
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
          if (lastMonthDiff != null)
            Text(
              lastMonthDiff >= 0
                  ? '+${lastMonthDiff.abs().toStringAsFixed(0)}% from last month'
                  : '-${lastMonthDiff.abs().toStringAsFixed(0)}% from last month',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: lastMonthDiff >= 0 ? _primary : const Color(0xFF991B1B),
              ),
            )
          else
            const Text(
              'No prior month data',
              style: TextStyle(fontSize: 11, color: _onSurfaceVariant),
            ),
        ],
      ),
    );
  }

  Widget _buildSessionsCard(int present, int total) {
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
                '${(present * _anim.value).round()}',
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
            'Sessions Attended',
            style: TextStyle(fontSize: 12, color: _onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, _) {
                final progress = total > 0 ? (present / total) * _anim.value : 0.0;
                return LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: _surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation<Color>(_primary),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$present of $total sessions',
            style: const TextStyle(fontSize: 10, color: _onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ── Monthly trend bar chart ────────────────────────────────────────────────

  Widget _buildTrendChart(_ReportData data) {
    final trend = data.trendData;

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend.isEmpty
                        ? 'No data'
                        : 'Last ${trend.length} Month${trend.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (trend.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No monthly data available yet.',
                    style: TextStyle(color: _onSurfaceVariant, fontSize: 14),
                  ),
                ),
              )
            else ...[
              AnimatedBuilder(
                animation: _anim,
                builder: (context, _) {
                  return SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: trend.map((entry) {
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
                children: trend
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
          ],
        ),
      ),
    );
  }

  // ── Recent Exceptions list ─────────────────────────────────────────────────

  Widget _buildExceptionsList(_ReportData data) {
    final exceptions = data.exceptions;

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Text(
                'Recent Exceptions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _onSurface,
                ),
              ),
            ),
            if (exceptions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No exceptions — great attendance! 🎉',
                    style: TextStyle(color: _onSurfaceVariant, fontSize: 14),
                  ),
                ),
              )
            else
              ...exceptions.map((r) => _ExceptionTile(record: r)),
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
// Exception tile (from real AttendanceRecord)
// ---------------------------------------------------------------------------

class _ExceptionTile extends StatelessWidget {
  final AttendanceRecord record;
  const _ExceptionTile({required this.record});

  bool get _isAbsent => record.status == 'Absent';

  Color get _iconBg => _isAbsent ? _errorContainer : const Color(0xFFFEF9C3);
  Color get _iconFg =>
      _isAbsent ? _onErrorContainer : const Color(0xFF854D0E);
  Color get _badgeBg =>
      _isAbsent ? const Color(0xFFFEE2E2) : const Color(0xFFFEF9C3);
  Color get _badgeFg =>
      _isAbsent ? const Color(0xFF991B1B) : const Color(0xFF854D0E);
  IconData get _icon =>
      _isAbsent ? Icons.event_busy_outlined : Icons.schedule_outlined;
  String get _label => _isAbsent ? 'Absent' : 'Late';

  String _formatDate(String raw) {
    try {
      final parts = raw.split('-');
      if (parts.length == 3) {
        const months = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        final m = int.parse(parts[1]);
        return '${months[m]} ${parts[2]}, ${parts[0]}';
      }
    } catch (_) {}
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final timeDisplay =
        record.timeIn.isNotEmpty && record.timeIn != 'N/A'
            ? record.timeIn
            : '--:--';

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
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      record.meetingTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_formatDate(record.date)}  •  $timeDisplay',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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