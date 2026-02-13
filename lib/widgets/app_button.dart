import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final AppButtonVariant variant;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = widget.onPressed != null;

    Color bgColor;
    Color fgColor;
    Border? border;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        bgColor = enabled ? AppTheme.primary : AppTheme.onSurfaceVariant.withValues(alpha: 0.3);
        fgColor = Colors.white;
        break;
      case AppButtonVariant.secondary:
        bgColor = enabled ? AppTheme.surfaceVariant : AppTheme.surfaceVariant;
        fgColor = enabled ? AppTheme.primaryLight : AppTheme.onSurfaceVariant;
        break;
      case AppButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = enabled ? AppTheme.primaryLight : AppTheme.onSurfaceVariant;
        border = Border.all(
          color: enabled ? AppTheme.primary.withValues(alpha: 0.6) : AppTheme.onSurfaceVariant.withValues(alpha: 0.3),
          width: 1.5,
        );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: border,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20, color: fgColor),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
