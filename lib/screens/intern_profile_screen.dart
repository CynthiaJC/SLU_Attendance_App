import 'package:flutter/material.dart';
import '../models/attendance_models.dart';
import '../services/mock_api_service.dart';
import '../widgets/profile_widgets.dart';
import 'login_screen.dart';

class InternProfileScreen extends StatefulWidget {
  final String internId;
  const InternProfileScreen({super.key, required this.internId});

  @override
  State<InternProfileScreen> createState() => _InternProfileScreenState();
}

class _InternProfileScreenState extends State<InternProfileScreen>
    with TickerProviderStateMixin {
  late Future<Intern?> _future;

  // Shimmer pulse
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _future = MockApiService().getInternById(widget.internId);
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

  void _retry() =>
      setState(() => _future = MockApiService().getInternById(widget.internId));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Intern?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScaffold();
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _buildErrorScaffold();
        }
        return _buildProfile(snapshot.data!);
      },
    );
  }

  // ── Loading state ─────────────────────────────────────────────────────────

  Widget _buildLoadingScaffold() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, _) {
        final alpha = (_shimmerAnim.value * 255).round();
        final shimmer = Color.fromARGB(alpha, 200, 210, 230);
        return Scaffold(
          backgroundColor: profileBackground,
          appBar: AppBar(
            backgroundColor: profileBackground,
            elevation: 0,
            title: Text(
              'Profile',
              style: TextStyle(
                  color: profilePrimaryBlue, fontWeight: FontWeight.w700),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Avatar placeholder
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                        color: shimmer, shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(height: 16),
                _skeletonBox(width: 160, height: 20, color: shimmer),
                const SizedBox(height: 8),
                _skeletonBox(width: 220, height: 14, color: shimmer),
                const SizedBox(height: 32),
                _skeletonBox(width: double.infinity, height: 130, color: shimmer),
                const SizedBox(height: 16),
                _skeletonBox(width: double.infinity, height: 100, color: shimmer),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _skeletonBox(
      {double? width, required double height, required Color color}) {
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

  Widget _buildErrorScaffold() {
    return Scaffold(
      backgroundColor: profileBackground,
      appBar: AppBar(
        backgroundColor: profileBackground,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: profilePrimaryBlue, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined,
                  size: 64, color: profileTextSecondary),
              const SizedBox(height: 16),
              const Text(
                'Could not load profile',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: profileTextPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'There was a problem fetching your profile.\nPlease try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: profileTextSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: profilePrimaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Loaded profile ────────────────────────────────────────────────────────

  Widget _buildProfile(Intern intern) {
    final attendancePercent =
        '${(intern.participationRate * 100).round()}%';
    final sessionsLabel = '${intern.presentCount}/${intern.totalSessions}';

    return ProfileScaffold(
      children: [
        ProfileHeader(
          name: intern.name,
          primaryLine: '${intern.role} • ${intern.department}',
          secondaryLine: 'Supervisor: ${intern.supervisor}',
          icon: Icons.person,
          badge: intern.status == 'onTrack'
              ? '✓ On Track'
              : intern.status == 'needsReview'
                  ? '⚠ Needs Review'
                  : '⚠ At Risk',
        ),

        // Quick stats row
        Row(
          children: [
            ProfileStatisticCard(
              label: 'Attendance',
              value: attendancePercent,
            ),
            const SizedBox(width: 12),
            ProfileStatisticCard(
              label: 'Sessions',
              value: sessionsLabel,
            ),
            const SizedBox(width: 12),
            ProfileStatisticCard(
              label: 'Late',
              value: '${intern.lateCount}',
            ),
          ],
        ),
        const SizedBox(height: 28),

        const ProfileSectionHeader('Personal Information'),
        ProfileTileGroup(
          children: [
            ProfileInfoTile(
              icon: Icons.email_outlined,
              label: 'Email Address',
              value: intern.email,
            ),
            ProfileInfoTile(
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              value: intern.phone,
            ),
            ProfileInfoTile(
              icon: Icons.badge_outlined,
              label: 'Student ID',
              value: intern.studentId,
            ),
            ProfileInfoTile(
              icon: Icons.calendar_today_outlined,
              label: 'Date Joined',
              value: intern.dateJoined,
            ),
          ],
        ),
        const SizedBox(height: 20),

        const ProfileSectionHeader('Account Settings'),
        ProfileTileGroup(
          children: [
            const ProfileSettingTile(
              icon: Icons.notifications_none,
              title: 'Notification Preferences',
            ),
            const ProfileSettingTile(
              icon: Icons.lock_outline,
              title: 'Privacy Settings',
            ),
            const ProfileSettingTile(
                icon: Icons.help_outline, title: 'Help Center'),
          ],
        ),
        const SizedBox(height: 34),

        ProfileLogoutButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            'v1.0',
            style: TextStyle(
              color: profileTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}