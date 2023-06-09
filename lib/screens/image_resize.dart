import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageResize extends StatefulWidget {
  const ImageResize({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ImageResize> createState() => _ImageResizeState();
}

class _ImageResizeState extends State<ImageResize> {
  File? imageTemporary;
  int? width;
  int? height;
  File? selectedImage;
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      selectedImage = File(pickedFile.path);
      imageTemporary = selectedImage;
    });
  }

  Future<void> resizeImage(int width, int height) async {
    if (imageTemporary == null) return;
    final image = img.decodeImage(selectedImage!.readAsBytesSync())!;
    final resizedImage = img.copyResize(image, width: width, height: height);
    final directory = await Directory.systemTemp.createTemp();
    final imagePath = path.join(directory.path, 'resized.png');
    setState(() {
      imageTemporary = File(imagePath)
        ..writeAsBytesSync(img.encodePng(resizedImage));
    });
  }

  Future<void> saveImage() async {
    if (imageTemporary == null) return;
    final directory = await getExternalStorageDirectory();
    final imagePath = imageTemporary!.path;
    final fileName = path.basename(imagePath);
    final newPath = path.join(directory!.path, fileName);
    File(imagePath).copy(newPath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image saved to $newPath'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: selectedImage != null
              ? [
                  IconButton(
                    onPressed: () => saveImage(),
                    icon: Icon(Icons.save),
                  ),
                ]
              : null,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (imageTemporary != null) ...[
                  Text('Preview'),
                  const SizedBox(height: 20),
                  Image.file(
                    imageTemporary!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                ],
                if (imageTemporary == null)
                  Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, size: 100, color: Colors.grey),
                      )),
                const SizedBox(height: 20),
                Text('Select an image to resize'),
                const SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => getImage(),
                      child: const Text('Select from gallery'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          imageTemporary = null;
                          _widthController.clear();
                          _heightController.clear();
                          ImageCache().clear();
                        });
                      },
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _widthController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Width',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Height',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        resizeImage(int.parse(_widthController.text),
                            int.parse(_heightController.text));
                      },
                      child: const Text('Resize'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
