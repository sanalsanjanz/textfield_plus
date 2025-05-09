# Custom Text Field for Flutter

A customizable and feature-rich text field widget for Flutter applications. This package provides a `CustomTextField` widget with various styling and validation options.

## Features

- Customizable appearance (filled background, border styles, icons, etc.).
- Input validation (phone numbers, emails, required fields).
- Support for different input types (text, number, email, phone).
- Prefix icons and currency support.
- Read-only and selectable text fields.
- Focus management and auto-selection of text.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  textfield_plus: ^latest_version


## Usage

import 'package:textfield_plus/textfield_plus.dart';

CustomTextField(
  controller: _controller,
  hintText: 'Enter text here',
  prefixIcon: Icon(Icons.text_fields),
  validator: (value) {
    if (value.isEmpty) {return 'This field cannot be empty';}
    else{
    return null;}},
),



![screenshot1](https://github.com/user-attachments/assets/8bfa5418-6e14-49e5-8513-75dc817bdea3)
![screenshot2](https://github.com/user-attachments/assets/4cf3d8eb-f554-48c8-ac23-83b9fd89dce8)

