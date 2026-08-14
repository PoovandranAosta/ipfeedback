import 'package:flutter/material.dart';

class CustomToast {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    IconData? icon,
    Color iconColor = Colors.white,
    double borderRadius = 12,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    Duration duration = const Duration(seconds: 2),
    ToastPosition position = ToastPosition.bottom,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: position == ToastPosition.top ? 80 : null,
          bottom: position == ToastPosition.bottom ? 80 : null,
          left: 20,
          right: 20,
          child: _ToastView(
            message: message,
            backgroundColor: backgroundColor,
            textColor: textColor,
            icon: icon,
            iconColor: iconColor,
            borderRadius: borderRadius,
            fontSize: fontSize,
            fontWeight: fontWeight,
            padding: padding,
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  /// SHOW LOADING TOAST
  static OverlayEntry? _loadingOverlay;

  static void showLoading({
    required BuildContext context,
    String message = "Please wait...",
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double borderRadius = 12,
  }) {
    if (_loadingOverlay != null) return; // prevent duplicate

    _loadingOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 20,
          right: 20,
          bottom: 80,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_loadingOverlay!);
  }

  /// HIDE LOADING TOAST
  static void hideLoading() {
    _loadingOverlay?.remove();
    _loadingOverlay = null;
  }
}

class _ToastView extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final Color iconColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const _ToastView({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    required this.iconColor,
    required this.borderRadius,
    required this.fontSize,
    required this.fontWeight,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ToastPosition { top, center, bottom }
