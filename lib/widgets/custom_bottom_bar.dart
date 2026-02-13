import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const double _height = 64;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      height: _height + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.onSurfaceVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _BarItem(
              icon: Icons.list_alt_rounded,
              label: 'Coinler',
              selected: selectedIndex == 0,
              onTap: () => onTap(0),
              textStyle: textTheme.labelMedium,
            ),
            _BarItem(
              icon: Icons.star_rounded,
              label: 'Takip',
              selected: selectedIndex == 1,
              onTap: () => onTap(1),
              textStyle: textTheme.labelMedium,
            ),
            _BarItem(
              icon: Icons.person_rounded,
              label: 'Profil',
              selected: selectedIndex == 2,
              onTap: () => onTap(2),
              textStyle: textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.textStyle,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.primaryLight : AppTheme.onSurfaceVariant;
    final bgColor = selected
        ? AppTheme.secondaryDark.withValues(alpha: 0.6)
        : Colors.transparent;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppTheme.primary.withValues(alpha: 0.2),
          highlightColor: AppTheme.primary.withValues(alpha: 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: (textStyle ?? const TextStyle()).copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
