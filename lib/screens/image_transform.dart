import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageTransform extends StatefulWidget {
  const ImageTransform({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ImageTransform> createState() => _ImageTransformState();
}

class _ImageTransformState extends State<ImageTransform> {
  File? imageTemporary;
  File? selectedImage;

  getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      selectedImage = File(pickedFile.path);
      imageTemporary = selectedImage;
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

  Future<void> rotate90(String direction) async {
    if (imageTemporary == null) return;
    final image = img.decodeImage(imageTemporary!.readAsBytesSync())!;
    final rotatedImage = direction == 'left'
        ? img.copyRotate(image, angle: -90)
        : img.copyRotate(image, angle: 90);
    final directory = await Directory.systemTemp.createTemp();
    final imagePath = path.join(directory.path, 'transformed.jpg');
    setState(() {
      imageTemporary = File(imagePath)
        ..writeAsBytesSync(img.encodeJpg(rotatedImage));
    });
  }

  Future<void> flipImage(String direction) async {
    if (imageTemporary == null) return;
    final image = img.decodeImage(imageTemporary!.readAsBytesSync())!;
    final flippedImage = direction == 'horizontal'
        ? img.flipHorizontal(image)
        : img.flipVertical(image);
    final directory = await Directory.systemTemp.createTemp();
    final imagePath = path.join(directory.path, 'transformed.jpg');
    setState(() {
      imageTemporary = File(imagePath)
        ..writeAsBytesSync(img.encodeJpg(flippedImage));
    });
  }

  saveTemporaryImage() async {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            children: [
              if (imageTemporary != null)
                Image.file(
                  imageTemporary!,
                  height: 500,
                ),
              if (imageTemporary == null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 200,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => getImage(),
                    child: Text('Select Image'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => rotate90('left'),
                    child: Icon(Icons.rotate_left),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => rotate90('right'),
                    child: Icon(Icons.rotate_right),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => flipImage('horizontal'),
                    child: Icon(Icons.flip),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => flipImage('vertical'),
                    // rotated Icons.flip
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationZ(0.5 * 3.14),
                      child: Icon(Icons.flip),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
