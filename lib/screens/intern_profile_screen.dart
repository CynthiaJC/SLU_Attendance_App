import 'package:flutter/material.dart';

import '../widgets/profile_widgets.dart';

class InternProfileScreen extends StatelessWidget {
  const InternProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScaffold(
      bottomNavigationBar: ProfileBottomNavigationBar(),
      children: [
        ProfileHeader(
          name: 'Amara Okafor',
          primaryLine: 'Engineering Intern • Product Development',
          icon: Icons.person,
        ),
        ProfileSectionHeader('Personal Information'),
        ProfileTileGroup(
          children: [
            ProfileInfoTile(
              icon: Icons.email_outlined,
              label: 'Email Address',
              value: 'amara.okafor@excelerateglobal.com',
            ),
            ProfileInfoTile(
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              value: '+1 (555) 012-3456',
            ),
            ProfileInfoTile(
              icon: Icons.badge_outlined,
              label: 'Internship ID',
              value: 'EG-2024-00892',
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
              icon: Icons.lock_outline,
              title: 'Privacy Settings',
            ),
            ProfileSettingTile(icon: Icons.help_outline, title: 'Help Center'),
          ],
        ),
        SizedBox(height: 34),
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
