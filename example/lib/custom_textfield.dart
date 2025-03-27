library;

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isRequired;
  final bool? bottomPadding;
  final bool center;
  final bool filled;
  final bool showTitle;
  final bool isAmount;
  final bool mobile;
  final String code;
  final Color? fillColor;
  final bool? readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final bool selectAll;
  final IconData? icon;
  final bool isBold;
  final Function(dynamic event)? onTapOutside;

  const CustomTextField({
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
            hintText: "Enter $title",
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
