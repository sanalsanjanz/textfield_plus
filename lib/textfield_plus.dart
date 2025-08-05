// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';

/// A customizable and modern text field with optional autocomplete support.
///
/// Supports classic and modern UI modes, validation, focus animations,
/// and both String or Model-based autocomplete.
class TextFieldPlus<T extends Object> extends StatefulWidget {
  /// Controller to manage the text input value.
  final TextEditingController controller;

  /// Title or label for the text field.
  final String title;

  /// Optional list for String autocomplete.
  final List<String>? list;

  /// Optional model list for model-based autocomplete.
  final List<T>? modelList;

  /// Function to get the display label from a model.
  String Function(T)? getDisplayLabel;

  /// Callback when a model is selected from autocomplete.
  final void Function(T)? onSelectedModel;

  /// Called when text changes.
  final void Function(String)? onChanged;

  /// Keyboard input type.
  final TextInputType? keyboardType;

  /// Maximum number of input lines.
  final int? maxLines;

  /// Whether this field is required (for validation).
  final bool isRequired;

  /// Whether to fill the background color.
  final bool filled;

  /// Background fill color (used when [filled] is true).
  final Color? fillColor;

  /// Whether to center align the text.
  final bool center;

  /// Whether to show the title label.
  final bool showTitle;

  /// Whether this field is for amount entry.
  final bool isAmount;

  /// Whether this field is for mobile number entry.
  final bool mobile;

  /// Optional prefix code for phone number fields.
  final String code;

  /// Custom text for prefixing the hint.
  final String titlePrefix;

  /// Whether this field is read-only.
  final bool? readOnly;

  /// Whether to select all text when tapped.
  final bool selectAll;

  /// An optional prefix icon.
  final IconData? icon;

  /// Whether to make text bold.
  final bool isBold;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Callback when the field is tapped.
  final VoidCallback? onTap;

  /// Callback when tapped outside the field.
  final Function(dynamic)? onTapOutside;

  /// Whether to use the modern UI style.
  final bool isModern;

  /// Color accent for modern design (used for focused border, labels, etc.).
  final Color? accentColor;

  /// Background color for modern design.
  final Color? modernBackgroundColor;

  /// Border radius for modern field container.
  final double? borderRadius;

  /// Whether to show floating label.
  final bool showFloatingLabel;

  /// Optional helper text.
  final String? hintText;

  /// Custom error color for validation.
  final Color? errorColor;

  /// Whether to apply glass morphism effect in modern mode.
  final bool useGlassMorphism;

  /// Shadow elevation for modern design.
  final double shadowElevation;

  /// Optional suffix icon.
  final IconData? suffixIcon;

  /// Callback when suffix icon is tapped.
  final VoidCallback? onSuffixIconTap;

  /// Optional padding below the field.
  final bool? bottomPadding;

  /// Constructor for [TextFieldPlus] with all customization options.
  TextFieldPlus({
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
    this.hintText,
    this.errorColor,
    this.useGlassMorphism = false,
    this.shadowElevation = 0,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.list,
    this.modelList,
    this.getDisplayLabel,
    this.onSelectedModel,
  });

  @override
  State<TextFieldPlus<T>> createState() => _TextFieldPlusState<T>();
}

class _TextFieldPlusState<T extends Object> extends State<TextFieldPlus<T>>
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

  /// Handles focus animation state change.
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

  /// Builds modern-style TextField with optional autocomplete.
  Widget _buildModernTextField() {
    if ((widget.list != null && widget.list!.isNotEmpty) ||
        (widget.modelList != null && widget.modelList!.isNotEmpty)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: widget.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
              children:
                  widget.isRequired
                      ? const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ]
                      : null,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[50],
            ),
            child: _buildAutoComplete(context),
          ),
        ],
      );
    }

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
                      /*      helperText: widget.hintText, */
                      /*   helperStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ), */
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

  /// Builds classic TextField with optional autocomplete.
  Widget _buildClassicTextField() {
    if ((widget.list != null && widget.list!.isNotEmpty) ||
        (widget.modelList != null && widget.modelList!.isNotEmpty)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
              children:
                  widget.isRequired
                      ? const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ]
                      : null,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[50],
            ),
            child: _buildAutoComplete(context),
          ),
        ],
      );
    }

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

  /// Builds Autocomplete (both String and Model based).
  Widget _buildAutoComplete(BuildContext context) {
    if (widget.list != null && widget.list!.isNotEmpty) {
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return widget.list!.where(
            (item) => item.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10), // Rounded border
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(10), // Rounded border
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ), // Optional: border color
                ),
                /* constraints: const BoxConstraints(
                            maxHeight: 200,
                          ), // Limit height */
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onSelected: (String selection) {
          widget.controller.text = selection;
          widget.onChanged?.call(selection);
        },
        fieldViewBuilder: (
          context,
          textFieldController,
          focusNode,
          onFieldSubmitted,
        ) {
          textFieldController.text = widget.controller.text;
          return TextFormField(
            controller: textFieldController,
            focusNode: focusNode,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              prefixIcon:
                  widget.icon != null
                      ? Icon(widget.icon, color: Colors.grey[600], size: 20)
                      : null,
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              hintText: widget.hintText ?? 'Enter ${widget.title}',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            onFieldSubmitted: (value) => onFieldSubmitted(),
          );
        },
      );
    } else if (widget.modelList != null &&
        widget.modelList!.isNotEmpty &&
        widget.getDisplayLabel != null) {
      return Autocomplete<T>(
        displayStringForOption: widget.getDisplayLabel!,
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10), // Rounded border
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(10), // Rounded border
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ), // Optional border color
                ),
                constraints: const BoxConstraints(
                  maxHeight: 200, // Optional: Limit dropdown height
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          widget.getDisplayLabel!(
                            option,
                          ), // ✅ Display label using your function
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },

        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return Iterable<T>.empty();
          }
          return widget.modelList!.where((item) {
            final label = widget.getDisplayLabel!(item);
            return label.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          });
        },
        onSelected: (T selectedModel) {
          widget.controller.text = widget.getDisplayLabel!(selectedModel);
          widget.onSelectedModel?.call(selectedModel);
          widget.onChanged?.call(widget.controller.text);
        },
        fieldViewBuilder: (
          context,
          textFieldController,
          focusNode,
          onFieldSubmitted,
        ) {
          textFieldController.text = widget.controller.text;
          return TextFormField(
            controller: textFieldController,
            focusNode: focusNode,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(
                widget.icon,
                color: Colors.grey[500],
                size: 19.5,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              hintText: widget.hintText ?? 'Enter ${widget.title}',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            onFieldSubmitted: (value) => onFieldSubmitted(),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  /// Validates the input text.
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      setState(() => _hasError = true);
      return 'Please enter ${widget.title}';
    }
    return null;
  }
}
