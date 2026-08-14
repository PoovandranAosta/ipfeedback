import 'package:flutter/material.dart';

class CustomHeaderCard extends StatelessWidget {
  final String title;

  // Title styling
  final TextStyle? titleStyle;

  // Accent bar
  final bool showAccent;
  final Color accentColor;
  final double accentHeight;
  final double accentWidth;
  final double accentRadius;

  // Action button
  final bool showAction;
  final String actionText;
  final IconData actionIcon;
  final Color actionColor;
  final VoidCallback? onActionPressed;

  // Layout
  final EdgeInsetsGeometry padding;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;

  const CustomHeaderCard({
    super.key,
    required this.title,

    // Title
    this.titleStyle,

    // Accent bar
    this.showAccent = true,
    this.accentColor = Colors.green,
    this.accentHeight = 36,
    this.accentWidth = 4,
    this.accentRadius = 4,

    // Action button
    this.showAction = true,
    this.actionText = "Clear",
    this.actionIcon = Icons.clear,
    this.actionColor = Colors.red,
    this.onActionPressed,

    // Layout
    this.padding = EdgeInsets.zero,
    this.spacing = 10,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          /// Left Section (Accent + Title)
          Row(
            children: [
              if (showAccent)
                Container(
                  height: accentHeight,
                  width: accentWidth,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(accentRadius),
                  ),
                ),

              if (showAccent) SizedBox(width: spacing),

              Text(
                title,
                style: titleStyle ??
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
              ),
            ],
          ),

          /// Action Button
          if (showAction)
            TextButton.icon(
              onPressed: onActionPressed,
              icon: Icon(
                actionIcon,
                size: 18,
                color: actionColor,
              ),
              label: Text(
                actionText,
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}