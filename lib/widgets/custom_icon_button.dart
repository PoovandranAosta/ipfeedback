import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.iconSize = 24,
    this.borderRadius = 12,
    this.borderColor,
    this.borderWidth = 1,
    this.elevation = 0,
    this.contentPadding,
    this.tooltip,
    this.splashColor,
    this.shadowColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.onLongPress,
    this.shape = BoxShape.rectangle,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? contentPadding;
  final String? tooltip;
  final Color? splashColor;
  final Color? shadowColor;
  final bool isLoading;
  final bool isDisabled;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || isLoading;

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        elevation: elevation,
        shadowColor: shadowColor,
        shape: shape == BoxShape.circle
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: borderColor != null
                    ? BorderSide(color: borderColor!, width: borderWidth)
                    : BorderSide.none,
              ),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          onLongPress: disabled ? null : onLongPress,
          splashColor: splashColor,
          customBorder: shape == BoxShape.circle
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
          child: Container(
            padding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: disabled
                  ? backgroundColor.withOpacity(0.9)
                  : backgroundColor,
              shape: shape,
              borderRadius: shape == BoxShape.circle
                  ? null
                  : BorderRadius.circular(borderRadius),
              border: shape == BoxShape.circle
                  ? null
                  : borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth)
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, size: iconSize, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
