import 'package:flutter/material.dart';

/// A clean, professional-looking selectable "chip-style" checkbox item.
/// No animations — instant state changes, simple and lightweight.
class CustomCheckBoxItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;

  final double? width;
  final double? height;
  final double borderRadius;
  final double iconSize;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const CustomCheckBoxItem({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.selectedColor,
    this.unselectedColor,
    this.iconColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius = 14,
    this.iconSize = 20,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color activeColor = selectedColor ?? theme.colorScheme.primary;
    final Color inactiveColor = unselectedColor ?? Colors.white;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: value ? activeColor.withOpacity(0.08) : inactiveColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: value ? activeColor : (borderColor ?? Colors.grey.shade300),
            width: value ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: value
                  ? activeColor.withOpacity(0.18)
                  : Colors.black.withOpacity(0.03),
              blurRadius: value ? 10 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with a soft circular backdrop
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: value ? activeColor.withOpacity(0.15) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: value ? activeColor : (iconColor ?? Colors.grey.shade600),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: value ? FontWeight.w700 : FontWeight.w500,
                  color: value ? activeColor : (textColor ?? Colors.grey.shade800),
                  letterSpacing: 0.1,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Circular check indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? activeColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: value ? activeColor : Colors.grey.shade400,
                  width: 1.6,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}