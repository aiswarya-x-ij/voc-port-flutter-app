import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ============================================================
// REUSABLE WIDGETS
// ============================================================

/// VOC Port Logo widget - uses the real official VOC Port Authority logo image
class VocPortLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool darkBackground;

  const VocPortLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.darkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Real VOC logo image with white bg container for dark backgrounds
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.15),
          ),
          padding: EdgeInsets.all(size * 0.06),
          child: Image.asset(
            'assets/images/voc_logo_symbol.png',
            fit: BoxFit.contain,
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'V.O.C. Port Authority',
                style: TextStyle(
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.w700,
                  color: darkBackground ? Colors.white : AppTheme.vocNavy,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'Truck Movement Monitoring System',
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w400,
                  color: darkBackground ? Colors.white70 : AppTheme.vocGrey,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class VocLogoPainter extends CustomPainter {
  final bool darkBg;
  VocLogoPainter({this.darkBg = false});

  @override
  void paint(Canvas canvas, Size size) {
    final color = darkBg ? AppTheme.vocNavy : Colors.white;
    final accentColor = const Color(0xFF90CAF9);
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    // Draw simplified V shape (matching VOC logo)
    final path = Path();
    // Left wing
    path.moveTo(size.width * 0.1, 0);
    path.lineTo(size.width * 0.42, size.height * 0.72);
    path.lineTo(size.width * 0.5, size.height * 0.60);
    path.lineTo(size.width * 0.22, 0);
    path.close();

    // Right wing
    final path2 = Path();
    path2.moveTo(size.width * 0.9, 0);
    path2.lineTo(size.width * 0.58, size.height * 0.72);
    path2.lineTo(size.width * 0.5, size.height * 0.60);
    path2.lineTo(size.width * 0.78, 0);
    path2.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);

    // Pearl circle at bottom
    final circlePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.88),
      size.width * 0.10,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Status badge widget
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor ?? color,
        ),
      ),
    );
  }
}

/// Section card with title
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final List<Widget>? actions;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.vocBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: iconColor ?? AppTheme.vocNavy),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.vocNavy,
                    ),
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.vocBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Info row for displaying key-value pairs
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.vocGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.vocNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Styled text field
class VocTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLength;
  final void Function(String)? onChanged;

  const VocTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.vocNavy,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          maxLength: maxLength,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: AppTheme.vocGrey) : null,
            suffixIcon: suffixIcon,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

/// Styled dropdown
class VocDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final bool enabled;
  final String? hint;
  final IconData? prefixIcon;

  const VocDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.hint,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.vocNavy,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.vocNavy),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: AppTheme.vocGrey) : null,
            filled: true,
            fillColor: enabled ? AppTheme.vocLightGrey : AppTheme.vocBorder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.vocBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.vocBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.vocNavy, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.vocGrey),
        ),
      ],
    );
  }
}

/// Primary action button
class VocButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;

  const VocButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.vocNavy,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Stat card for dashboards
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String? change;
  final bool changePositive;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.change,
    this.changePositive = true,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.vocBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.vocNavy,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppTheme.vocGrey),
                ),
                if (change != null)
                  Text(
                    change!,
                    style: TextStyle(
                      fontSize: 11,
                      color: changePositive ? AppTheme.vocSuccess : AppTheme.vocError,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Alert card widget
class AlertCard extends StatelessWidget {
  final String title;
  final String message;
  final AlertSeverity severity;
  final String time;

  const AlertCard({
    super.key,
    required this.title,
    required this.message,
    required this.severity,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    IconData icon;
    switch (severity) {
      case AlertSeverity.danger:
        color = AppTheme.vocError;
        bg = const Color(0xFFFFF0F0);
        icon = Icons.warning_rounded;
        break;
      case AlertSeverity.warning:
        color = AppTheme.vocWarning;
        bg = const Color(0xFFFFF8E1);
        icon = Icons.info_rounded;
        break;
      case AlertSeverity.success:
        color = AppTheme.vocSuccess;
        bg = const Color(0xFFF0FFF4);
        icon = Icons.check_circle_rounded;
        break;
      case AlertSeverity.info:
        color = AppTheme.vocLightBlue;
        bg = const Color(0xFFF0F4FF);
        icon = Icons.notifications_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12, color: AppTheme.vocNavy),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 10, color: AppTheme.vocGrey),
          ),
        ],
      ),
    );
  }
}

enum AlertSeverity { danger, warning, success, info }
