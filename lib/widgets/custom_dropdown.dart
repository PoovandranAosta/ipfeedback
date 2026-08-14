import 'package:flutter/material.dart';

class CommonDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final String labelText;
  final String Function(T item) itemLabel;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  final bool enabled;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final double menuMaxHeight;
  final Color? backgroundColor;

  /// ⭐ NEW
  final bool isRequired;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    this.selectedValue,
    required this.labelText,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.borderRadius = 8,
    this.borderColor = Colors.grey,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    this.menuMaxHeight = 250,
    this.backgroundColor,
    this.isRequired = false, // default
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      isExpanded: true,
      menuMaxHeight: menuMaxHeight,
      validator: validator,
      onChanged: enabled ? onChanged : null,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabel(item), overflow: TextOverflow.ellipsis),
        );
      }).toList(),

      decoration: InputDecoration(
        contentPadding: padding,
        filled: true,
        fillColor: backgroundColor ?? Colors.white,

        /// ⭐ LABEL WITH REQUIRED STAR
        label: RichText(
          text: TextSpan(
            text: labelText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),

        floatingLabelBehavior: FloatingLabelBehavior.auto,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor.withOpacity(0.4)),
        ),
      ),
    );
  }
}
