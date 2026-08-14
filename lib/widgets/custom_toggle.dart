import 'package:flutter/material.dart';

class ModernToggleButton extends StatefulWidget {
  final String option1Label;
  final String option2Label;
  final bool initialSelection; // true = option1, false = option2
  final ValueChanged<bool>? onChanged;

  final String subTitle1;
  final String subTitle2;

  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? borderColor;

  final IconData? option1Icon;
  final IconData? option2Icon;

  const ModernToggleButton({
    super.key,
    this.option1Label = 'English',
    this.option2Label = 'தமிழ்',
    this.initialSelection = true,
    this.onChanged,
    required this.subTitle1,
    required this.subTitle2,
    this.backgroundColor,
    this.selectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.borderColor,
    this.option1Icon = Icons.language,
    this.option2Icon = Icons.language,
  });

  @override
  State<ModernToggleButton> createState() => _ModernToggleButtonState();
}

class _ModernToggleButtonState extends State<ModernToggleButton>
    with SingleTickerProviderStateMixin {
  late bool _isOption1Selected;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _isOption1Selected = widget.initialSelection;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _animation = Tween<double>(
      begin: 0.97,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(bool selectOption1) {
    if (_isOption1Selected == selectOption1) return;

    setState(() {
      _isOption1Selected = selectOption1;
    });

    widget.onChanged?.call(selectOption1);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor =
        widget.backgroundColor ?? Colors.white; // Deep Blue
    final selectedColor =
        widget.selectedColor ?? Colors.white.withOpacity(0.18);
    final selectedTextColor = widget.selectedTextColor ?? Colors.white;
    final unselectedTextColor =
        widget.unselectedTextColor ?? Colors.white.withOpacity(0.85);
    final borderColor = widget.borderColor ?? Colors.white.withOpacity(0.12);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegment(
              label: widget.option1Label,
              icon: widget.option1Icon,
              subtitle: widget.subTitle1,
              isSelected: _isOption1Selected,
              onTap: () => _toggle(true),
              selectedColor: selectedColor,
              selectedTextColor: selectedTextColor,
              unselectedTextColor: unselectedTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSegment(
              label: widget.option2Label,
              icon: widget.option2Icon,
              subtitle: widget.subTitle2,
              isSelected: !_isOption1Selected,
              onTap: () => _toggle(false),
              selectedColor: selectedColor,
              selectedTextColor: selectedTextColor,
              unselectedTextColor: unselectedTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required String label,
    required IconData? icon,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required Color selectedColor,
    required Color selectedTextColor,
    required Color unselectedTextColor,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _animation.value : 1.0,
          child: Material(
            color: isSelected ? selectedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.white.withOpacity(0.10),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 16,
                        color: isSelected
                            ? selectedTextColor
                            : unselectedTextColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: label,
                              style: TextStyle(
                                color: isSelected
                                    ? selectedTextColor
                                    : unselectedTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' · $subtitle',
                              style: TextStyle(
                                color: isSelected
                                    ? selectedTextColor.withOpacity(0.9)
                                    : unselectedTextColor.withOpacity(0.75),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
