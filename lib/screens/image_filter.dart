import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageFilter extends StatefulWidget {
  const ImageFilter({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ImageFilter> createState() => _ImageFilterState();
}

class _ImageFilterState extends State<ImageFilter> {
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

  Future<void> grayscale() async {
    if (imageTemporary == null) return;
    final image = img.decodeImage(selectedImage!.readAsBytesSync())!;
    final grayscaleImage = img.grayscale(image);
    final directory = await Directory.systemTemp.createTemp();
    final imagePath = path.join(directory.path, 'filtered.jpg');
    setState(() {
      imageTemporary = File(imagePath)
        ..writeAsBytesSync(img.encodeJpg(grayscaleImage));
    });
  }

  Future<void> sepia() async {
    if (imageTemporary == null) return;
    final image = img.decodeImage(selectedImage!.readAsBytesSync())!;
    final sepiaImage = img.sepia(image);
    final directory = await Directory.systemTemp.createTemp();
    final imagePath = path.join(directory.path, 'filtered.jpg');
    setState(() {
      imageTemporary = File(imagePath)
        ..writeAsBytesSync(img.encodeJpg(sepiaImage));
    });
  }

  Future<void> invert() async {
    if (imageTemporary == null) return;
    final image = img.decodeImage(selectedImage!.readAsBytesSync())!;
    final invertImage = img.invert(image);
    final directory = await Directory.systemTemp.createTemp();
    final imagePath = path.join(directory.path, 'filtered.jpg');
    setState(() {
      imageTemporary = File(imagePath)
        ..writeAsBytesSync(img.encodeJpg(invertImage));
    });
  }

  Future<void> blur() async {
    if (imageTemporary == null) return;
    final image = img.decodeImage(selectedImage!.readAsBytesSync())!;
    final blurImage = img.gaussianBlur(image, radius: 10);
    final directory = await Directory.systemTemp.createTemp();
    final imagePath = path.join(directory.path, 'filtered.jpg');
    setState(() {
      imageTemporary = File(imagePath)
        ..writeAsBytesSync(img.encodeJpg(blurImage));
    });
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => getImage(),
                    child: Text('Select Image'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (imageTemporary != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => grayscale(),
                      child: Text('Grayscale'),
                    ),
                    ElevatedButton(
                      onPressed: () => sepia(),
                      child: Text('Sepia'),
                    )
                  ],
                ),
              if (imageTemporary != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => invert(),
                      child: Text('Invert'),
                    ),
                    ElevatedButton(
                      onPressed: () => blur(),
                      child: Text('Blur'),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
