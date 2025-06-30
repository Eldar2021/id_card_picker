import 'dart:io';
import 'package:flutter/material.dart';
import 'package:id_card_picker/id_card_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Card Picker Example',
      theme: ThemeData(primarySwatch: Colors.blue, visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _croppedImageFile;

  Future<void> _pickIdCard() async {
    // Paketin ana metodunu çağırıyoruz
    final File? imageFile = await IdCardPicker.pick(
      context: context,
      label: 'Kimliğini Tara',
      overlayBorderColor: Colors.greenAccent,
    );

    if (imageFile != null) {
      setState(() {
        _croppedImageFile = imageFile;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to: ${imageFile.path}')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID card picking cancelled.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ID Card Picker Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_croppedImageFile != null)
              Padding(padding: const EdgeInsets.all(16.0), child: Image.file(_croppedImageFile!, height: 200))
            else
              const Text('Press the button to scan your ID card.'),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _pickIdCard, child: const Text('Scan ID Card')),
          ],
        ),
      ),
    );
  }
}
