import 'package:flutter/material.dart';

import 'profile_tokens.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.onBackTap,
    required this.onSettingsTap,
    super.key,
  });

  final VoidCallback onBackTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: <Widget>[
          _HeaderIconButton(icon: Icons.chevron_left_rounded, onTap: onBackTap),
          const Expanded(
            child: Text(
              'PROFILE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: profileWhite,
                letterSpacing: 4,
                shadows: <Shadow>[Shadow(color: profileBlue, blurRadius: 14)],
              ),
            ),
          ),
          _HeaderIconButton(icon: Icons.settings_rounded, onTap: onSettingsTap),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[profilePanelElevated, profilePanel],
            ),
            border: Border.all(color: profileBorder),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: profileBlue.withValues(alpha: 0.08),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(icon, color: profileWhite, size: 18),
        ),
      ),
    );
  }
}
