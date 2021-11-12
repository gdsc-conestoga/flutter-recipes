import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _uploadedFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_uploadedFile == null)
              const Text("Waiting for upload")
            else
              kIsWeb
                  ? Image.network(_uploadedFile!.path)
                  : Image.file(File(_uploadedFile!.path)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        tooltip: 'Upload File',
        child: const Icon(Icons.image),
      ),
    );
  }

  void _uploadImage() async {
    final upload = await _picker.pickImage(source: ImageSource.gallery);
    if (upload == null) return;

    setState(() {
      _uploadedFile = upload;
    });
  }
}
