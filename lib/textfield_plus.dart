import 'dart:ui';

import 'package:flutter/material.dart';

/// A customizable wrapper around [TextFormField] with additional UI features.
///
/// `TextFieldPlus` provides convenient options for setting title labels,
/// validation, padding, keyboard input types, read-only states, and more.
/// Now includes a modern aesthetic design option.
class TextFieldPlus extends StatefulWidget {
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

  /// Whether to use modern aesthetic design.
  final bool isModern;

  /// Modern design accent color (used for borders, labels, etc.).
  final Color? accentColor;

  /// Modern design background color.
  final Color? modernBackgroundColor;

  /// Border radius for modern design.
  final double? borderRadius;

  /// Whether to show floating label in modern design.
  final bool showFloatingLabel;

  /// Whether to show helper text in modern design.
  final String? helperText;

  /// Custom error color for modern design.
  final Color? errorColor;

  /// Whether to use glass morphism effect in modern design.
  final bool useGlassMorphism;

  /// Shadow elevation for modern design.
  final double shadowElevation;

  /// Suffix icon for modern design.
  final IconData? suffixIcon;

  /// Suffix icon callback.
  final VoidCallback? onSuffixIconTap;

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
    this.isModern = false,
    this.accentColor,
    this.modernBackgroundColor,
    this.borderRadius,
    this.showFloatingLabel = true,
    this.helperText,
    this.errorColor,
    this.useGlassMorphism = false,
    this.shadowElevation = 0,
    this.suffixIcon,
    this.onSuffixIconTap,
  });

  @override
  State<TextFieldPlus> createState() => _TextFieldPlusState();
}

class _TextFieldPlusState extends State<TextFieldPlus>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;
  // ignore: unused_field
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode?.hasFocus ?? false;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isModern ? _buildModernTextField() : _buildClassicTextField();
  }

  Widget _buildModernTextField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = widget.accentColor ?? theme.primaryColor;
    final backgroundColor =
        widget.modernBackgroundColor ??
        (isDark ? Colors.grey[850] : Colors.grey[50]);
    final borderRadius = widget.borderRadius ?? 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showTitle && !widget.showFloatingLabel) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: accentColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow:
                    widget.shadowElevation > 0
                        ? [
                          BoxShadow(
                            color: accentColor.withAlpha(_isFocused ? 77 : 26),
                            blurRadius: widget.shadowElevation,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: BackdropFilter(
                  filter:
                      widget.useGlassMorphism
                          ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                          : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    onChanged: widget.onChanged,
                    onTap:
                        widget.selectAll
                            ? () =>
                                widget.controller.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: widget.controller.text.length,
                                )
                            : widget.onTap,
                    onTapOutside: widget.onTapOutside,
                    keyboardType:
                        widget.keyboardType == TextInputType.number
                            ? const TextInputType.numberWithOptions(
                              decimal: true,
                            )
                            : widget.keyboardType,
                    maxLines: widget.maxLines,
                    readOnly: widget.readOnly ?? false,
                    textAlign:
                        widget.center
                            ? TextAlign.center
                            : widget.keyboardType == TextInputType.number
                            ? TextAlign.end
                            : TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          widget.isBold ? FontWeight.w600 : FontWeight.w400,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: 0.2,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          widget.useGlassMorphism
                              ? backgroundColor?.withAlpha(179)
                              : backgroundColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical:
                            widget.maxLines != null && widget.maxLines! > 1
                                ? 16
                                : 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.grey.withAlpha(77),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: Colors.grey.withAlpha(77),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(color: accentColor, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: widget.errorColor ?? Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide(
                          color: widget.errorColor ?? Colors.red,
                          width: 2.0,
                        ),
                      ),
                      labelText: widget.showFloatingLabel ? widget.title : null,
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      hintText:
                          widget.showFloatingLabel
                              ? null
                              : "${widget.titlePrefix} ${widget.title}",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                      helperText: widget.helperText,
                      helperStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      prefixIcon:
                          widget.icon != null
                              ? Container(
                                margin: const EdgeInsets.only(
                                  left: 12,
                                  right: 8,
                                ),
                                child: Icon(
                                  widget.icon,
                                  color:
                                      _isFocused
                                          ? accentColor
                                          : Colors.grey[500],
                                  size: 20,
                                ),
                              )
                              : null,
                      suffixIcon:
                          widget.suffixIcon != null
                              ? GestureDetector(
                                onTap: widget.onSuffixIconTap,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                    right: 12,
                                  ),
                                  child: Icon(
                                    widget.suffixIcon,
                                    color:
                                        _isFocused
                                            ? accentColor
                                            : Colors.grey[500],
                                    size: 20,
                                  ),
                                ),
                              )
                              : null,
                    ),
                    validator: widget.isRequired ? _validateInput : null,
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.bottomPadding ?? true) const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildClassicTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showTitle) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 2),
        ],
        TextFormField(
          onTapOutside: widget.onTapOutside,
          onTap:
              widget.selectAll
                  ? () =>
                      widget.controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: widget.controller.text.length,
                      )
                  : widget.onTap,
          style: TextStyle(
            fontSize: 13,
            fontWeight: widget.isBold ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black87,
          ),
          textInputAction: TextInputAction.next,
          textAlign:
              widget.center
                  ? TextAlign.center
                  : widget.keyboardType == TextInputType.number
                  ? TextAlign.end
                  : TextAlign.start,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          keyboardType:
              widget.keyboardType == TextInputType.number
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : widget.keyboardType,
          controller: widget.controller,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly ?? false,
          decoration: InputDecoration(
            filled: widget.filled,
            fillColor: widget.fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderSide:
                  widget.filled
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: "${widget.titlePrefix} ${widget.title}",
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
            prefixIcon:
                widget.icon != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 8, right: 4),
                      child: Icon(
                        widget.icon,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                    )
                    : null,
          ),
          validator: widget.isRequired ? _validateInput : null,
        ),
        if (widget.bottomPadding ?? true) const SizedBox(height: 8),
      ],
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      setState(() => _hasError = true);
      return 'Please enter ${widget.title}';
    }

    if (widget.keyboardType == TextInputType.phone) {
      if (value.length < 6) {
        setState(() => _hasError = true);
        return 'Mobile number must be at least 6 digits';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        setState(() => _hasError = true);
        return 'Please enter a valid mobile number';
      }
    }

    if (widget.keyboardType == TextInputType.emailAddress) {
      if (!RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(value)) {
        setState(() => _hasError = true);
        return 'Please enter a valid email address';
      }
    }

    setState(() => _hasError = false);
    return null;
  }
}
