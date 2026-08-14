import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomThreeArchedLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final bool isVisible;
  final Widget? background;
  final double? overlayOpacity;
  final BorderRadius? borderRadius;

  const CustomThreeArchedLoader({
    Key? key,
    this.size = 45,
    this.color,
    this.padding = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
    this.isVisible = true,
    this.background,
    this.overlayOpacity,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox();

    final loader = Padding(
      padding: padding,
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );

    // If overlay needed
    if (overlayOpacity != null) {
      return Container(
        alignment: alignment,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(overlayOpacity!),
          borderRadius: borderRadius,
        ),
        child: loader,
      );
    }

    // If custom background widget
    if (background != null) {
      return Stack(alignment: alignment, children: [background!, loader]);
    }

    return Align(alignment: alignment, child: loader);
  }
}
