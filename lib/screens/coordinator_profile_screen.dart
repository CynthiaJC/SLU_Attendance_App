import 'package:flutter/material.dart';

import '../widgets/profile_widgets.dart';

class CoordinatorProfileScreen extends StatelessWidget {
  const CoordinatorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScaffold(
      children: [
        ProfileHeader(
          name: 'Marcus Chen',
          primaryLine: 'Senior Coordinator',
          secondaryLine: 'Global Operations',
          badge: 'Global Operations',
          inCard: true,
          icon: Icons.manage_accounts,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            ProfileStatisticCard(label: 'Teams', value: '12'),
            SizedBox(width: 8),
            ProfileStatisticCard(label: 'Interns', value: '156'),
            SizedBox(width: 8),
            ProfileStatisticCard(label: 'Sync', value: '85%'),
          ],
        ),
        SizedBox(height: 20),
        ProfileSectionHeader('Coordinator Tools'),
        ProfileTileGroup(
          children: [
            ProfileSettingTile(
              icon: Icons.groups_outlined,
              title: 'Team Management',
            ),
            ProfileSettingTile(
              icon: Icons.file_download_outlined,
              title: 'Bulk Attendance Export',
            ),
            ProfileSettingTile(
              icon: Icons.calendar_month_outlined,
              title: 'Meeting Schedules',
            ),
          ],
        ),
        SizedBox(height: 20),
        ProfileSectionHeader('Account Settings'),
        ProfileTileGroup(
          children: [
            ProfileSettingTile(
              icon: Icons.notifications_none,
              title: 'Notification Preferences',
            ),
            ProfileSettingTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Settings',
            ),
            ProfileSettingTile(icon: Icons.help_outline, title: 'Help Center'),
          ],
        ),
        SizedBox(height: 24),
        ProfileLogoutButton(),
        SizedBox(height: 18),
        Center(
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
