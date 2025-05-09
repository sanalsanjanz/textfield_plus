library;

import 'package:flutter/material.dart';

/// A customizable wrapper around [TextFormField] with additional UI features.
///
/// `TextFieldPlus` provides convenient options for setting title labels,
/// validation, padding, keyboard input types, read-only states, and more.
class TextFieldPlus extends StatelessWidget {
  /// The controller for managing the text field's value.
  final TextEditingController controller;

  /// The label/title displayed above the text field.
  final String title;

  /// The type of keyboard to use for the text field.
  final TextInputType? keyboardType;

  /// The maximum number of lines for the text input.
  final int? maxLines;

  /// Whether the field is required for validation.
  final bool isRequired;

  /// Whether to add bottom padding below the field.
  final bool? bottomPadding;

  /// Aligns the text to the center if true.
  final bool center;

  /// Fills the field background if true.
  final bool filled;

  /// Whether to show the title above the field.
  final bool showTitle;

  /// Whether this field is intended to be used for amount input.
  final bool isAmount;

  /// Whether this field is for mobile number input.
  final bool mobile;

  /// The country code prefix for mobile number inputs.
  final String code;

  /// The title prefix hint select choose- by default Enter.
  final String titlePrefix;

  /// Background color to use when [filled] is true.
  final Color? fillColor;

  /// Whether the text field is read-only.
  final bool? readOnly;

  /// Callback when the field is tapped.
  final VoidCallback? onTap;

  /// The [FocusNode] for managing focus.
  final FocusNode? focusNode;

  /// Callback when the field value changes.
  final void Function(String)? onChanged;

  /// Whether to select all text on tap.
  final bool selectAll;

  /// An optional prefix icon to display in the field.
  final IconData? icon;

  /// Whether to make the text bold.
  final bool isBold;

  /// Callback when tapped outside the field.
  final Function(dynamic event)? onTapOutside;

  /// Creates a [TextFieldPlus] widget with enhanced control over appearance and behavior.
  const TextFieldPlus({
    super.key,
    required this.title,
    required this.controller,
    this.keyboardType,
    this.maxLines,
    this.isRequired = true,
    this.filled = false,
    this.fillColor = Colors.transparent,
    this.center = false,
    this.onChanged,
    this.focusNode,
    this.mobile = false,
    this.code = "",
    this.titlePrefix = "Enter",
    this.showTitle = true,
    this.bottomPadding = true,
    this.readOnly = false,
    this.onTap,
    this.onTapOutside,
    this.selectAll = false,
    this.icon,
    this.isBold = false,
    this.isAmount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTitle) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 2),
        ],
        TextFormField(
          onTapOutside: onTapOutside,
          onTap:
              selectAll
                  ? () =>
                      controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: controller.text.length,
                      )
                  : onTap,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black87,
          ),
          textInputAction: TextInputAction.next,
          textAlign:
              center
                  ? TextAlign.center
                  : keyboardType == TextInputType.number
                  ? TextAlign.end
                  : TextAlign.start,
          focusNode: focusNode,
          onChanged: onChanged,
          keyboardType:
              keyboardType == TextInputType.number
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : keyboardType,
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly ?? false,
          decoration: InputDecoration(
            filled: filled,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderSide:
                  filled
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: "$titlePrefix $title",
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
            prefixIcon:
                icon != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 8, right: 4),
                      child: Icon(icon, color: Colors.grey.shade400, size: 18),
                    )
                    : null,
          ),
          validator: isRequired ? _validateInput : null,
        ),
        if (bottomPadding ?? true) const SizedBox(height: 8),
      ],
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) return 'Please enter $title';

    if (keyboardType == TextInputType.phone) {
      if (value.length < 6) return 'Mobile number must be at least 6 digits';
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Please enter a valid mobile number';
      }
    }

    if (keyboardType == TextInputType.emailAddress) {
      if (!RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }

    return null;
  }
}
