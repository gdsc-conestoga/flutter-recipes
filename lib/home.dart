import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipes/welcome.dart';
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
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: "Image picker",
          ),
        ],
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
      body: _pageIndex == 0
          ? const WelcomePage()
          : Center(
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
      floatingActionButton: _pageIndex == 0
          ? null
          : FloatingActionButton(
              onPressed: _uploadImage,
              tooltip: 'Upload File',
              child: const Icon(Icons.image),
            ),
    );
  }

  void _uploadImage() async {
    final upload = await _picker.pickImage(source: ImageSource.camera);
    if (upload == null) return;

    setState(() {
      _uploadedFile = upload;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.fixed,
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _uploadedFile = null;
            });
          },
        ),
        content: const Text("Image uploaded"),
      ),
    );
  }
}
