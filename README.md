# 🪪 Id Card Picker

A Flutter package for **capturing and cropping ID card images** with ease.
Handles camera permissions, provides a customizable camera overlay, and returns a cropped image file ready for use in your app.

---

## 🚀 Features

- 📸 **Take photos with the camera**
- ✂️ **Automatic cropping**
- 🎨 **Customizable overlay (colors, title)**
- 🔒 **Camera permission handling**
- 🧩 **Easy integration**

---

## 🖼️ Demo
<p align="center">
  <!-- Place your demo.gif or a short video here -->
  <img src="/doc/id_card_picker_example.gif" alt="Id Card Picker Demo" width="300"/>
</p>

---

## ⚡️ Quick Start

### 1. Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  id_card_picker: ^0.1.0
```

### 2. Permissions

Make sure to add camera permissions for Android and iOS.
See the [permission_handler](https://pub.dev/packages/permission_handler) documentation for details.

### 3. Usage

```dart
import 'package:id_card_picker/id_card_picker.dart';

// ...

final file = await IdCardPicker.pick(
  context: context,
  label: 'Scan your ID Card',
  onPermissionDenied: 'Camera permission is required!',
  overlayBackgroundColor: Colors.black54,
  overlayBorderColor: Colors.white,
);

if (file != null) {
  // Image successfully picked!
  print('File path: [32m${file.path}[0m');
}
```

---

## ⚙️ Parameters

| Parameter                | Description                           | Default                      |
| ------------------------ | ------------------------------------- | ---------------------------- |
| `context`                | BuildContext (required)               | -                            |
| `label`                  | Camera screen title                   | `'Scan ID Card'`             |
| `onPermissionDenied`     | Message shown if permission is denied | `'Camera permission denied'` |
| `overlayBackgroundColor` | Overlay background color              | `Colors.black54`             |
| `overlayBorderColor`     | Overlay border color                  | `Colors.white`               |

---

## 🛠️ Contributing & Feedback

Feel free to open issues or pull requests for suggestions, improvements, or bug reports!

---

## 📄 License

MIT
