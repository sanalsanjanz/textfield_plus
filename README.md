# Text Field Plus for Flutter

A customizable and feature-rich text field widget for Flutter applications. This package provides a `TextFieldPlus` widget with various styling and validation options.

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
```

## Usage

Import the package and use the `TextFieldPlus` widget in your Flutter application:

```dart
import 'package:textfield_plus/textfield_plus.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Field Plus Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTextField(
          hintText: 'Enter your text here',
          prefixIcon: Icon(Icons.text_fields),
          onChanged: (value) {
            print('Input value: $value');
          },
        ),
      ),
    );
  }
}
```
## Screenshot

Below is a screenshot of the `TextFieldPlus` widget in action:

![Screenshot 1](https://raw.githubusercontent.com/sanalsanjanz/textfield_plus/main/assets/images/screenshot1.jpeg)
![Screenshot 2](https://raw.githubusercontent.com/sanalsanjanz/textfield_plus/main/assets/images/screenshot2.jpeg)


